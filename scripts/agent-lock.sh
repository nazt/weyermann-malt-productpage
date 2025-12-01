#!/bin/bash
# Agent Lock System
# Manage agent availability with lock files + git activity detection

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

LOCK_DIR=".agent-locks"

show_usage() {
    cat <<'USAGE'
Usage: agent-lock.sh <command> [agent-number] [task-description]

Commands:
  lock <N> <task>    - Lock agent N with task description
  unlock <N>         - Unlock agent N
  status [N]         - Check status of agent(s)
  force-unlock <N>   - Force unlock (use with caution)

Examples:
  agent-lock.sh lock 2 "Analyzing subagents feature"
  agent-lock.sh unlock 2
  agent-lock.sh status
  agent-lock.sh status 2

Lock File Format:
  .agent-locks/agent-N.lock contains:
    - task: Task description
    - locked_at: ISO timestamp
    - locked_by: main | agent-N
    - pid: Process ID (optional)
USAGE
}

init_lock_dir() {
    mkdir -p "$LOCK_DIR"
}

lock_agent() {
    local agent_num=$1
    local task_desc="${2:-Working on task}"
    local lock_file="$LOCK_DIR/agent-$agent_num.lock"

    init_lock_dir

    # Check if already locked
    if [ -f "$lock_file" ]; then
        echo -e "${RED}❌ Agent $agent_num is already locked${NC}"
        cat "$lock_file"
        return 1
    fi

    # Create lock file
    cat > "$lock_file" <<EOF
task: $task_desc
locked_at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
locked_by: main
agent_dir: agents/$agent_num
EOF

    echo -e "${GREEN}🔒 Agent $agent_num locked${NC}"
    echo "   Task: $task_desc"
    echo "   Lock file: $lock_file"
}

unlock_agent() {
    local agent_num=$1
    local lock_file="$LOCK_DIR/agent-$agent_num.lock"
    local force=${2:-false}

    if [ ! -f "$lock_file" ]; then
        echo -e "${YELLOW}⚠️  Agent $agent_num is not locked${NC}"
        return 0
    fi

    # If not force, check git status
    if [ "$force" = "false" ]; then
        local agent_dir="agents/$agent_num"
        if [ -d "$agent_dir" ]; then
            local git_status=$(git -C "$agent_dir" status --porcelain 2>/dev/null || echo "")
            if [ -n "$git_status" ]; then
                echo -e "${YELLOW}⚠️  Agent $agent_num has uncommitted work${NC}"
                echo "   Uncommitted files:"
                echo "$git_status" | head -3 | sed 's/^/   /'
                echo ""
                echo "   Options:"
                echo "   1. Wait for agent to commit and create PR"
                echo "   2. Use 'force-unlock $agent_num' to unlock anyway"
                return 1
            fi
        fi
    fi

    # Remove lock file
    rm "$lock_file"
    echo -e "${GREEN}🔓 Agent $agent_num unlocked${NC}"
}

force_unlock_agent() {
    local agent_num=$1
    echo -e "${YELLOW}⚠️  Force unlocking Agent $agent_num${NC}"
    unlock_agent "$agent_num" true
}

get_agent_status() {
    local agent_num=$1
    local agent_dir="agents/$agent_num"
    local lock_file="$LOCK_DIR/agent-$agent_num.lock"

    if [ ! -d "$agent_dir" ]; then
        echo -e "${RED}❌ Agent $agent_num: Worktree not found${NC}"
        return 3
    fi

    # Check lock file
    local is_locked=false
    local lock_task=""
    local lock_time=""

    if [ -f "$lock_file" ]; then
        is_locked=true
        lock_task=$(grep "^task:" "$lock_file" | cut -d' ' -f2- || echo "Unknown")
        lock_time=$(grep "^locked_at:" "$lock_file" | cut -d' ' -f2- || echo "Unknown")
    fi

    # Check git status
    local git_status=$(git -C "$agent_dir" status --porcelain 2>/dev/null)
    local branch=$(git -C "$agent_dir" branch --show-current 2>/dev/null)
    local last_commit=$(git -C "$agent_dir" log -1 --format="%cr" 2>/dev/null || echo "No commits")

    # Determine overall status
    local has_work=false
    if [ -n "$git_status" ]; then
        has_work=true
    fi

    # Check for conflicts
    if git -C "$agent_dir" ls-files -u 2>/dev/null | grep -q .; then
        echo -e "${RED}🔴 Agent $agent_num: CONFLICT${NC}"
        echo "   Branch: $branch"
        echo "   Lock: $([ "$is_locked" = true ] && echo "🔒 Locked" || echo "🔓 Unlocked")"
        echo "   Has merge conflicts - needs resolution"
        return 2
    fi

    # Status determination
    if [ "$is_locked" = true ] && [ "$has_work" = true ]; then
        echo -e "${BLUE}🔵 Agent $agent_num: LOCKED + WORKING${NC}"
        echo "   Branch: $branch"
        echo "   Lock: 🔒 Locked"
        echo "   Task: $lock_task"
        echo "   Locked since: $lock_time"
        echo "   Uncommitted changes:"
        echo "$git_status" | head -5 | sed 's/^/   /'
        echo "   Last commit: $last_commit"
        return 1
    elif [ "$is_locked" = true ] && [ "$has_work" = false ]; then
        echo -e "${YELLOW}🟡 Agent $agent_num: LOCKED (idle)${NC}"
        echo "   Branch: $branch"
        echo "   Lock: 🔒 Locked"
        echo "   Task: $lock_task"
        echo "   Locked since: $lock_time"
        echo "   Clean worktree - possibly finished?"
        echo "   Last commit: $last_commit"
        return 0
    elif [ "$is_locked" = false ] && [ "$has_work" = true ]; then
        echo -e "${YELLOW}🟡 Agent $agent_num: WORKING (unlocked)${NC}"
        echo "   Branch: $branch"
        echo "   Lock: 🔓 Unlocked"
        echo "   ⚠️  Has uncommitted work but not locked!"
        echo "   Uncommitted changes:"
        echo "$git_status" | head -5 | sed 's/^/   /'
        echo "   Last commit: $last_commit"
        return 1
    else
        echo -e "${GREEN}🟢 Agent $agent_num: IDLE${NC}"
        echo "   Branch: $branch"
        echo "   Lock: 🔓 Unlocked"
        echo "   Clean worktree - ready for tasks"
        echo "   Last commit: $last_commit"
        return 0
    fi
}

check_all_agents() {
    echo "📊 Multi-Agent Lock Status"
    echo ""

    init_lock_dir

    local idle_count=0
    local working_count=0
    local locked_count=0
    local conflict_count=0

    for agent_dir in agents/*; do
        if [ -d "$agent_dir" ]; then
            agent_num=$(basename "$agent_dir")
            get_agent_status "$agent_num"
            status=$?
            echo ""

            case $status in
                0)
                    if [ -f "$LOCK_DIR/agent-$agent_num.lock" ]; then
                        locked_count=$((locked_count + 1))
                    else
                        idle_count=$((idle_count + 1))
                    fi
                    ;;
                1) working_count=$((working_count + 1)) ;;
                2) conflict_count=$((conflict_count + 1)) ;;
            esac
        fi
    done

    echo "════════════════════════════════════"
    echo "Summary:"
    echo "  🟢 $idle_count idle (ready)"
    echo "  🔵 $locked_count locked"
    echo "  🟡 $working_count working"
    echo "  🔴 $conflict_count conflicts"
}

# Main
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

command=$1

case "$command" in
    lock)
        if [ $# -lt 3 ]; then
            echo "Error: lock requires agent number and task description"
            echo "Usage: agent-lock.sh lock <N> <task>"
            exit 1
        fi
        lock_agent "$2" "${*:3}"
        ;;
    unlock)
        if [ $# -lt 2 ]; then
            echo "Error: unlock requires agent number"
            echo "Usage: agent-lock.sh unlock <N>"
            exit 1
        fi
        unlock_agent "$2"
        ;;
    force-unlock)
        if [ $# -lt 2 ]; then
            echo "Error: force-unlock requires agent number"
            echo "Usage: agent-lock.sh force-unlock <N>"
            exit 1
        fi
        force_unlock_agent "$2"
        ;;
    status)
        if [ $# -eq 1 ]; then
            check_all_agents
        else
            get_agent_status "$2"
        fi
        ;;
    -h|--help)
        show_usage
        ;;
    *)
        echo "Unknown command: $command"
        show_usage
        exit 1
        ;;
esac
