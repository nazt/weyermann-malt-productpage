#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
HEY_SCRIPT="$SCRIPT_DIR/maw.hey.sh"

# Optional argument: agent to sync
AGENT_TARGET="${1:-}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Not inside a Git repository."
    exit 1
fi

branch=$(git rev-parse --abbrev-ref HEAD)
status_output=$(git status --porcelain)

# If on main branch
if [[ "$branch" == "main" ]]; then
    # If no agent specified, sync main and broadcast to all
    if [[ -z "$AGENT_TARGET" ]]; then
        if [[ -n "$status_output" ]]; then
            echo "❌ Working tree has uncommitted changes. Commit, stash, or clean them before syncing."
            exit 1
        fi

        echo "📍 On main branch. Pulling latest from origin/main (fast-forward only)..."
        git pull --ff-only origin main
        echo "✅ main is up to date with origin/main."

        # Broadcast sync to all agents
        if [[ -f "$HEY_SCRIPT" ]]; then
            echo "📢 Broadcasting sync to all agents..."
            "$HEY_SCRIPT" all "/maw.sync"
            echo "✅ All agents notified to sync."
        else
            echo "⚠️  hey.sh not found. Agents not notified. They should run /maw.sync manually."
        fi
    else
        # Sync specific agent
        if [[ -f "$HEY_SCRIPT" ]]; then
            echo "📤 Telling agent '$AGENT_TARGET' to sync..."
            "$HEY_SCRIPT" "$AGENT_TARGET" "/maw.sync"
            echo "✅ Agent '$AGENT_TARGET' notified to sync."
        else
            echo "❌ hey.sh not found. Cannot send sync command to agent."
            exit 1
        fi
    fi

elif [[ "$branch" == agents/* ]]; then
    # Agent branch: merge from main
    if [[ -n "$status_output" ]]; then
        echo "❌ Working tree has uncommitted changes. Commit, stash, or clean them before syncing."
        exit 1
    fi

    if ! git show-ref --verify --quiet refs/heads/main; then
        echo "❌ Local main branch not found. Sync main worktree first."
        exit 1
    fi

    echo "📍 On agent branch '$branch'. Merging local main into this worktree..."
    git merge main
    echo "✅ Agent branch '$branch' now includes the latest local main."

else
    echo "⚠️ Branch '$branch' is not 'main' or an 'agents/*' worktree branch. No sync performed."
    echo "   Run this command from the main worktree or an agents/<name> worktree."
    exit 1
fi
