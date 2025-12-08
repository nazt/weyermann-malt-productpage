#!/bin/bash
set -euo pipefail

PROMPT="$*"

if [ -z "$PROMPT" ]; then
    echo "Usage: maw.codex.sh <prompt>"
    exit 1
fi

DIR_NAME=$(basename "$(pwd)")
BASE_PREFIX=${SESSION_PREFIX:-ai}

# Try to find the session - check for both patterns
# Pattern 1: ${BASE_PREFIX}-${DIR_NAME}
# Pattern 2: ${BASE_PREFIX}-${DIR_NAME}-* (with custom suffix)
SESSION_NAME=""

# First try exact match
if tmux has-session -t "${BASE_PREFIX}-${DIR_NAME}" 2>/dev/null; then
    SESSION_NAME="${BASE_PREFIX}-${DIR_NAME}"
else
    # Look for sessions with custom prefix
    MATCHING_SESSIONS=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | grep "^${BASE_PREFIX}-${DIR_NAME}" || true)
    SESSION_COUNT=$(echo "$MATCHING_SESSIONS" | grep -c . || echo 0)

    if [ "$SESSION_COUNT" -eq 1 ]; then
        SESSION_NAME="$MATCHING_SESSIONS"
    elif [ "$SESSION_COUNT" -gt 1 ]; then
        echo "❌ Error: Multiple matching sessions found:"
        echo "$MATCHING_SESSIONS" | sed 's/^/  - /'
        echo ""
        echo "Please specify which session by setting SESSION_PREFIX or using only one session"
        exit 1
    fi
fi

if [ -z "$SESSION_NAME" ]; then
    echo "❌ Error: No tmux session found matching '${BASE_PREFIX}-${DIR_NAME}*'"
    echo ""
    echo "Expected session name patterns:"
    echo "  - ${BASE_PREFIX}-${DIR_NAME}"
    echo "  - ${BASE_PREFIX}-${DIR_NAME}-<suffix>"
    echo ""
    echo "Make sure the tmux session is running (use .agents/start-agents.sh)"
    exit 1
fi

WINDOW_INDEX=$(tmux list-windows -t "$SESSION_NAME" -F "#{window_index}" | head -1)
TARGET_PANE="$SESSION_NAME:${WINDOW_INDEX}.1"

ENTER_KEYS=(
    Enter   # standard Enter key name recognised by tmux
    C-m     # carriage return (Enter)
    C-j     # line feed
    $'\r'   # raw carriage return byte
    $'\n'   # raw newline byte
)


echo "📤 Sending to codex in session '$SESSION_NAME': $PROMPT"
tmux send-keys -t "$TARGET_PANE" "$PROMPT"

for enter_key in "${ENTER_KEYS[@]}"; do
    tmux send-keys -t "$TARGET_PANE" "$enter_key"
    sleep 0.05
done

echo "✅ Sent successfully"
