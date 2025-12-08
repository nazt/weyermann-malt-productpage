#!/bin/bash
set -euo pipefail

# Wrapper script for Claude slash command /maw.issue
# Delegates to the core .agents/scripts/issue.sh implementation.

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
AGENT_ROOT="$SCRIPT_DIR/../../.agents"
ISSUE_SCRIPT="$AGENT_ROOT/scripts/issue.sh"

if [[ ! -f "$ISSUE_SCRIPT" ]]; then
    echo "❌ Error: issue.sh script not found at $ISSUE_SCRIPT"
    exit 1
fi

exec "$ISSUE_SCRIPT" "$@"
