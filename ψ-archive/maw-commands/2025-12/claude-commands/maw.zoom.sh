#!/bin/bash
set -euo pipefail

# Wrapper script for Claude slash command /maw.zoom
# Calls the core zoom.sh implementation (fire and forget)

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
AGENT_ROOT="$SCRIPT_DIR/../../.agents"
ZOOM_SCRIPT="$AGENT_ROOT/scripts/zoom.sh"

if [[ ! -f "$ZOOM_SCRIPT" ]]; then
    echo "❌ Error: zoom.sh script not found at $ZOOM_SCRIPT"
    exit 1
fi

# Fire and forget - run in background and exit immediately
"$ZOOM_SCRIPT" "$@" >/dev/null 2>&1 &
echo "🔍 Zooming pane..."
