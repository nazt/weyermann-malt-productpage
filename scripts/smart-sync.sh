#!/bin/bash
# Smart Sync Workflow for Main Agent
# Checks agent worktree status before syncing

set -e

echo "🔍 Smart Sync Starting..."
echo ""

# Step 1: Verify we're main agent
echo "Step 1: Verifying identity..."
current_dir=$(pwd)
current_branch=$(git branch --show-current)

echo "  Location: $current_dir"
echo "  Branch: $current_branch"

if [ "$current_branch" != "main" ]; then
  echo ""
  echo "❌ ERROR: smart-sync must run from main branch"
  echo "Current branch: $current_branch"
  echo "Expected: main"
  exit 1
fi

echo "  ✅ Confirmed: Main agent"
echo ""

# Step 2: Pull latest from remote
echo "Step 2: Pulling from origin/main..."
if git pull --ff-only origin main; then
  echo "  ✅ Main branch updated"
else
  echo "  ⚠️  Pull failed or conflicts"
  exit 1
fi
echo ""

# Step 3: Check if agents directory exists
echo "Step 3: Looking for agent worktrees..."
if [ ! -d "agents" ]; then
  echo "  ⚠️  No agents/ directory found"
  echo "  Nothing to sync"
  exit 0
fi

agent_count=$(find agents -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
echo "  Found $agent_count agent worktree(s)"
echo ""

# Step 4: Smart sync each agent
echo "Step 4: Smart syncing agents..."
echo ""

synced_count=0
dirty_count=0
error_count=0

for agent_dir in agents/*; do
  if [ ! -d "$agent_dir" ]; then
    continue
  fi

  agent_name=$(basename "$agent_dir")
  echo "─────────────────────────────────────────"
  echo "Agent: $agent_name"
  echo "Path: $agent_dir"

  # Check if it's a valid git worktree
  if ! git -C "$agent_dir" rev-parse --git-dir > /dev/null 2>&1; then
    echo "Status: ❌ Not a valid git worktree"
    error_count=$((error_count + 1))
    echo ""
    continue
  fi

  # Check current branch
  agent_branch=$(git -C "$agent_dir" branch --show-current)
  echo "Branch: $agent_branch"

  # Check worktree status
  status=$(git -C "$agent_dir" status --porcelain 2>/dev/null)

  if [ -z "$status" ]; then
    # Clean worktree - safe to sync
    echo "Status: ✅ Clean worktree"
    echo "Action: Auto-syncing..."

    # Try to merge main
    if git -C "$agent_dir" merge main --no-edit > /dev/null 2>&1; then
      echo "Result: ✅ Synced successfully"
      synced_count=$((synced_count + 1))
    else
      echo "Result: ❌ Merge failed (conflicts detected)"
      echo ""
      echo "Conflict details:"
      git -C "$agent_dir" status --short | sed 's/^/  /'
      echo ""
      echo "📢 Would send to agent: 'Auto-sync failed due to conflicts. Please resolve: git merge main'"
      error_count=$((error_count + 1))
    fi
  else
    # Dirty worktree - notify agent
    echo "Status: ⚠️  Has uncommitted work"
    echo "Files changed:"
    echo "$status" | sed 's/^/  /'
    echo ""
    echo "Action: Notification required"
    echo "📢 Would send to agent: 'Main branch updated. You have uncommitted work. Please sync when ready: /maw.sync'"
    dirty_count=$((dirty_count + 1))
  fi

  echo ""
done

# Summary
echo "═════════════════════════════════════════"
echo "SUMMARY"
echo "═════════════════════════════════════════"
echo "Total agents checked: $agent_count"
echo "✅ Auto-synced: $synced_count"
echo "⚠️  Needs manual sync: $dirty_count"
echo "❌ Errors: $error_count"
echo ""

if [ $synced_count -gt 0 ]; then
  echo "Auto-synced agents are now up to date with main."
fi

if [ $dirty_count -gt 0 ]; then
  echo "Agents with uncommitted work need to sync manually when ready."
fi

if [ $error_count -gt 0 ]; then
  echo "Some agents encountered errors. Review output above."
fi

echo ""
echo "✅ Smart sync complete"
