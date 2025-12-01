#!/bin/bash
# Agent Status Checker
# Check if agents are idle or busy before assigning tasks

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_usage() {
    cat <<'USAGE'
Usage: agent-status.sh [agent-number]

Check agent status before assigning tasks.

Examples:
  agent-status.sh         # Check all agents
  agent-status.sh 2       # Check only Agent 2

Status Indicators:
  🟢 IDLE      - No uncommitted work, ready for tasks
  🟡 WORKING   - Has uncommitted changes (busy)
  🔴 CONFLICT  - Has merge conflicts or issues
USAGE
}

check_agent_status() {
    local agent_num=$1
    local agent_dir="agents/$agent_num"

    if [ ! -d "$agent_dir" ]; then
        echo -e "${RED}❌ Agent $agent_num: Worktree not found${NC}"
        return 1
    fi

    # Check git status
    local status=$(git -C "$agent_dir" status --porcelain 2>/dev/null)
    local branch=$(git -C "$agent_dir" branch --show-current 2>/dev/null)

    # Check for merge conflicts
    if git -C "$agent_dir" ls-files -u 2>/dev/null | grep -q .; then
        echo -e "${RED}🔴 Agent $agent_num: CONFLICT${NC}"
        echo "   Branch: $branch"
        echo "   Has merge conflicts - needs resolution"
        return 2
    fi

    # Check for uncommitted work
    if [ -n "$status" ]; then
        echo -e "${YELLOW}🟡 Agent $agent_num: WORKING${NC}"
        echo "   Branch: $branch"
        echo "   Uncommitted changes:"
        echo "$status" | head -5 | sed 's/^/   /'
        if [ $(echo "$status" | wc -l) -gt 5 ]; then
            echo "   ... and $(($(echo "$status" | wc -l) - 5)) more"
        fi

        # Check last commit time
        local last_commit=$(git -C "$agent_dir" log -1 --format="%cr" 2>/dev/null)
        echo "   Last commit: $last_commit"
        return 1
    else
        echo -e "${GREEN}🟢 Agent $agent_num: IDLE${NC}"
        echo "   Branch: $branch"
        echo "   Clean worktree - ready for tasks"

        # Show last activity
        local last_commit=$(git -C "$agent_dir" log -1 --format="%cr - %s" 2>/dev/null)
        echo "   Last commit: $last_commit"
        return 0
    fi
}

# Main
if [ $# -eq 0 ]; then
    # Check all agents
    echo "📊 Multi-Agent Status Report"
    echo ""

    idle_count=0
    working_count=0
    conflict_count=0

    for agent_dir in agents/*; do
        if [ -d "$agent_dir" ]; then
            agent_num=$(basename "$agent_dir")
            check_agent_status "$agent_num"
            status=$?
            echo ""

            case $status in
                0) idle_count=$((idle_count + 1)) ;;
                1) working_count=$((working_count + 1)) ;;
                2) conflict_count=$((conflict_count + 1)) ;;
            esac
        fi
    done

    echo "════════════════════════════════════"
    echo "Summary: $idle_count idle, $working_count working, $conflict_count conflicts"
    echo ""

    if [ $idle_count -gt 0 ]; then
        echo "✅ $idle_count agent(s) ready for new tasks"
    fi

    if [ $working_count -gt 0 ]; then
        echo "⚠️  $working_count agent(s) currently working"
    fi

    if [ $conflict_count -gt 0 ]; then
        echo "🚨 $conflict_count agent(s) need attention (conflicts)"
    fi

elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
else
    # Check specific agent
    check_agent_status "$1"
fi
