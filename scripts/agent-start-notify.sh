#!/bin/bash
# Agent Start Notification Hook
# Called by PreToolUse (Task) for subagents and SessionStart for MAW agents

set -euo pipefail

# Get script directory for sourcing config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOML_FILE="$SCRIPT_DIR/agent-voices.toml"

# Parse TOML value using yq (primary) or stoml (fallback)
get_toml() {
    local section="$1"
    local key="$2"
    local default="$3"

    if [ ! -f "$TOML_FILE" ]; then
        echo "$default"
        return
    fi

    local value=""
    if command -v yq &> /dev/null; then
        value=$(yq -p toml -oy ".${section}.${key}" "$TOML_FILE" 2>/dev/null | grep -v "null")
    elif command -v stoml &> /dev/null; then
        value=$(stoml "$TOML_FILE" "${section}.${key}" 2>/dev/null)
    fi

    echo "${value:-$default}"
}

# Get voice for agent
get_voice() {
    local agent_name="$1"
    case "$agent_name" in
        *"Main"*) get_toml "voices" "main" "Samantha" ;;
        *"Agent 1"*) get_toml "voices" "agent_1" "Daniel" ;;
        *"Agent 2"*) get_toml "voices" "agent_2" "Karen" ;;
        *"Agent 3"*) get_toml "voices" "agent_3" "Rishi" ;;
        *subagent*|*Subagent*|*Starting*) get_toml "voices" "subagent" "Daniel" ;;
        *) get_toml "voices" "default" "Samantha" ;;
    esac
}

# Get speech rate for agent
get_rate() {
    local agent_name="$1"
    case "$agent_name" in
        *"Main"*) get_toml "rate" "main" "195" ;;
        *"Agent 1"*) get_toml "rate" "agent_1" "220" ;;
        *"Agent 2"*) get_toml "rate" "agent_2" "220" ;;
        *"Agent 3"*) get_toml "rate" "agent_3" "220" ;;
        *subagent*|*Subagent*|*Starting*) get_toml "rate" "subagent" "220" ;;
        *) get_toml "rate" "default" "220" ;;
    esac
}

# Read JSON input from stdin
INPUT=$(cat)

# Debug: log raw input
DEBUG_LOG="${CLAUDE_PROJECT_DIR:-.}/.agent-locks/debug-start.log"
mkdir -p "$(dirname "$DEBUG_LOG")"
echo "---" >> "$DEBUG_LOG"
echo "$INPUT" >> "$DEBUG_LOG"

# Parse relevant fields
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')

# Determine what's starting
AGENT_NAME=""
DESCRIPTION=""

if [ "$HOOK_EVENT" = "PreToolUse" ]; then
    # Check if this is a Task tool call (subagent)
    TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

    if [ "$TOOL_NAME" = "Task" ]; then
        # Extract task details
        DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // "task"')
        SUBAGENT_TYPE=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // "subagent"')
        AGENT_NAME="Starting $SUBAGENT_TYPE"
    fi

elif [ "$HOOK_EVENT" = "SessionStart" ]; then
    # MAW agent or main session starting
    SOURCE=$(echo "$INPUT" | jq -r '.source // "startup"')

    # Only announce for fresh startup, not resume/compact
    if [ "$SOURCE" = "startup" ]; then
        if [[ "$CWD" =~ agents/([0-9]+) ]]; then
            AGENT_NAME="Agent ${BASH_REMATCH[1]} starting"
        else
            # Skip main - user knows they're starting
            AGENT_NAME=""
        fi
    fi
fi

# Exit if nothing to announce
if [ -z "$AGENT_NAME" ]; then
    exit 0
fi

# Log activity
LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.agent-locks/activity.log"
mkdir -p "$(dirname "$LOG_FILE")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

if [ -n "$DESCRIPTION" ]; then
    echo "[$TIMESTAMP] $AGENT_NAME: $DESCRIPTION" >> "$LOG_FILE"
else
    echo "[$TIMESTAMP] $AGENT_NAME" >> "$LOG_FILE"
fi

# Desktop notification (macOS)
if command -v osascript &> /dev/null; then
    if [ -n "$DESCRIPTION" ]; then
        osascript -e "display notification \"$DESCRIPTION\" with title \"$AGENT_NAME\" sound name \"Pop\""
    else
        osascript -e "display notification \"$AGENT_NAME\" with title \"Claude Code\" sound name \"Pop\""
    fi
fi

# Speech queue - wait for any running say to finish
if command -v say &> /dev/null; then
    # Get voice and rate for this agent
    VOICE=$(get_voice "$AGENT_NAME")
    RATE=$(get_rate "$AGENT_NAME")

    MESSAGE="$AGENT_NAME"
    if [ -n "$DESCRIPTION" ]; then
        # Truncate description to keep speech short
        SHORT_DESC=$(echo "$DESCRIPTION" | head -c 50)
        MESSAGE="$AGENT_NAME: $SHORT_DESC"
    fi

    (
        while pgrep -x "say" > /dev/null; do
            sleep 0.5
        done
        say -v "$VOICE" -r "$RATE" "$MESSAGE"
    ) &
fi

# Return success - don't block the tool
exit 0
