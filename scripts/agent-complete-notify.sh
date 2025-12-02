#!/bin/bash
# Agent Completion Notification Hook
# Called by Stop (MAW agents) and SubagentStop (Claude subagents) hooks

set -euo pipefail

# Get script directory for sourcing config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOML_FILE="$SCRIPT_DIR/agent-voices.toml"

# Parse TOML value using yq (primary) or stoml (fallback)
get_toml_value() {
    local key="$1"
    local default="$2"

    if [ ! -f "$TOML_FILE" ]; then
        echo "$default"
        return
    fi

    local value=""
    # Try yq first (already installed)
    if command -v yq &> /dev/null; then
        value=$(yq -p toml -oy ".voices.${key}" "$TOML_FILE" 2>/dev/null | grep -v "null")
    # Fallback to stoml
    elif command -v stoml &> /dev/null; then
        value=$(stoml "$TOML_FILE" "voices.${key}" 2>/dev/null)
    fi

    echo "${value:-$default}"
}

# Get voice for agent
get_voice() {
    local agent_name="$1"
    case "$agent_name" in
        "Main") get_toml_value "main" "Samantha" ;;
        "Agent 1") get_toml_value "agent_1" "Daniel" ;;
        "Agent 2") get_toml_value "agent_2" "Karen" ;;
        "Agent 3") get_toml_value "agent_3" "Rishi" ;;
        "Subagent") get_toml_value "subagent" "Fred" ;;
        *) get_toml_value "default" "Samantha" ;;
    esac
}

# Read JSON input from stdin
INPUT=$(cat)

# Debug: log raw input to see what we receive
DEBUG_LOG="${CLAUDE_PROJECT_DIR:-.}/.agent-locks/debug.log"
mkdir -p "$(dirname "$DEBUG_LOG")"
echo "---" >> "$DEBUG_LOG"
echo "$INPUT" >> "$DEBUG_LOG"

# Parse relevant fields
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // ""')
AGENT_TRANSCRIPT=$(echo "$INPUT" | jq -r '.agent_transcript_path // ""')

# Determine if this is a subagent (SubagentStop) or MAW agent (Stop)
IS_SUBAGENT=false
if [ "$HOOK_EVENT" = "SubagentStop" ]; then
    IS_SUBAGENT=true
fi

# Try to get last message from transcript
LAST_MESSAGE=""
TRANSCRIPT_TO_READ="$TRANSCRIPT_PATH"
if [ "$IS_SUBAGENT" = true ] && [ -n "$AGENT_TRANSCRIPT" ] && [ -f "$AGENT_TRANSCRIPT" ]; then
    TRANSCRIPT_TO_READ="$AGENT_TRANSCRIPT"
fi

if [ -n "$TRANSCRIPT_TO_READ" ] && [ -f "$TRANSCRIPT_TO_READ" ]; then
    # Get last text content, take first 100 chars
    LAST_MESSAGE=$(tail -20 "$TRANSCRIPT_TO_READ" | grep -o '"text":"[^"]*"' | tail -1 | sed 's/"text":"//;s/"$//' | head -c 100)
fi

# Determine agent identifier from worktree/directory path
AGENT_NAME=""
if [ "$IS_SUBAGENT" = true ]; then
    # For Claude subagents, just say "Subagent" (no counter needed)
    AGENT_NAME="Subagent"
else
    # For MAW agents, detect from worktree path (agents/1, agents/2, agents/3)
    if [[ "$CWD" =~ agents/([0-9]+) ]]; then
        AGENT_NAME="Agent ${BASH_REMATCH[1]}"
    else
        AGENT_NAME="Main"
    fi
fi

# Get timestamp
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Log completion
LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.agent-locks/completions.log"
mkdir -p "$(dirname "$LOG_FILE")"

echo "[$TIMESTAMP] $AGENT_NAME completed - Session: $SESSION_ID" >> "$LOG_FILE"

# Optional: Send desktop notification (macOS)
if command -v osascript &> /dev/null; then
    osascript -e "display notification \"$AGENT_NAME completed\" with title \"Claude Code\" sound name \"Glass\""
fi

# Optional: Speak completion (macOS) with queue
if command -v say &> /dev/null; then
    SPEECH_QUEUE="${CLAUDE_PROJECT_DIR:-.}/.agent-locks/speech_queue"
    mkdir -p "$(dirname "$SPEECH_QUEUE")"

    # Get voice for this agent
    VOICE=$(get_voice "$AGENT_NAME")

    # Build message
    if [ -n "$LAST_MESSAGE" ]; then
        MESSAGE="$AGENT_NAME says: $LAST_MESSAGE"
    else
        MESSAGE="$AGENT_NAME completed"
    fi

    # Queue the speech (run in background with lock)
    (
        # Wait for any running say process to finish
        while pgrep -x "say" > /dev/null; do
            sleep 0.5
        done
        say -v "$VOICE" "$MESSAGE"
    ) &
fi

# Optional: Send to tmux status line
if command -v tmux &> /dev/null && [ -n "${TMUX:-}" ]; then
    tmux display-message "🤖 $AGENT_NAME completed"
fi

# Output JSON for Claude Code
cat << EOF
{
  "decision": "approve",
  "reason": "$AGENT_NAME completion logged"
}
EOF

exit 0
