#!/bin/bash
# Agent Completion Notification Hook
# Called by Stop (MAW agents) and SubagentStop (Claude subagents) hooks

set -euo pipefail

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

# Determine agent identifier
AGENT_NAME=""
if [ "$IS_SUBAGENT" = true ]; then
    # For subagents, use sequential counter
    COUNTER_FILE="${CLAUDE_PROJECT_DIR:-.}/.agent-locks/subagent_counter"
    if [ -f "$COUNTER_FILE" ]; then
        SUBAGENT_NUM=$(cat "$COUNTER_FILE")
        SUBAGENT_NUM=$((SUBAGENT_NUM + 1))
    else
        SUBAGENT_NUM=1
    fi
    echo "$SUBAGENT_NUM" > "$COUNTER_FILE"
    AGENT_NAME="Subagent $SUBAGENT_NUM"
else
    # For MAW agents, detect from worktree path
    if [[ "$CWD" =~ agents/([0-9]+) ]]; then
        AGENT_NAME="Multi-Agent ${BASH_REMATCH[1]}"
    else
        AGENT_NAME="Main agent"
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

# Optional: Speak completion (macOS)
if command -v say &> /dev/null; then
    if [ -n "$LAST_MESSAGE" ]; then
        say "$AGENT_NAME says: $LAST_MESSAGE" &
    else
        say "$AGENT_NAME completed" &
    fi
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
