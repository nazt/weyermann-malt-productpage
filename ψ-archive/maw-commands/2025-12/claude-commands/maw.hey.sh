#!/bin/bash
set -euo pipefail

# Wrapper script for Claude slash command /maw.hey
# Calls the core hey.sh implementation

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
AGENT_ROOT="$SCRIPT_DIR/../../.agents"
HEY_SCRIPT="$AGENT_ROOT/scripts/hey.sh"

if [[ ! -f "$HEY_SCRIPT" ]]; then
    echo "❌ Error: hey.sh script not found at $HEY_SCRIPT"
    exit 1
fi

exec "$HEY_SCRIPT" "$@"
