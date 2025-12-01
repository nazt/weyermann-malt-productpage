# Smart Sync Workflow for Main Agent

**Purpose**: Main agent intelligently syncs other agents by checking their work status first

## The Problem with Simple Sync

The original `/maw.sync` broadcasts to all agents blindly. But what if:
- Agent 1 is in the middle of coding?
- Agent 2 has uncommitted changes?
- Agent 3 is running tests?

Blindly merging could disrupt their work or cause conflicts.

## The Smart Approach

**Main agent should:**
1. Check each agent's worktree status using `git -C`
2. If clean → sync automatically
3. If dirty → ask the agent to sync when ready

## Implementation

### Step 1: Check Agent Worktree Status

```bash
# Main agent checking Agent 1's status
git -C agents/1 status --porcelain

# Returns:
# - Empty string = clean worktree (safe to sync)
# - Non-empty = has changes (agent is working)
```

### Step 2: Smart Sync Logic

```bash
#!/bin/bash
# Smart sync for all agents

for agent_dir in agents/*; do
  agent_name=$(basename "$agent_dir")

  # Check if agent worktree is clean
  status=$(git -C "$agent_dir" status --porcelain)

  if [ -z "$status" ]; then
    # Clean worktree - sync automatically
    echo "✅ Agent $agent_name: clean, syncing..."
    git -C "$agent_dir" merge main
  else
    # Dirty worktree - ask agent to sync when ready
    echo "⚠️  Agent $agent_name: has uncommitted changes"
    /maw.hey "$agent_name" "Main branch has updates. Please sync when ready: /maw.sync"
  fi
done
```

### Step 3: Full Smart Sync Workflow

```bash
#!/bin/bash
# .claude/commands/maw.smart-sync.sh

set -e

# Verify we're main agent
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
  echo "❌ Error: smart-sync must run from main branch"
  echo "Current branch: $current_branch"
  exit 1
fi

# Pull latest from remote
echo "📥 Main agent: pulling from origin/main..."
git pull --ff-only origin main

echo ""
echo "🔄 Checking agent worktrees..."
echo ""

# Smart sync each agent
for agent_dir in agents/*; do
  if [ ! -d "$agent_dir" ]; then
    continue
  fi

  agent_name=$(basename "$agent_dir")

  # Check worktree status
  status=$(git -C "$agent_dir" status --porcelain 2>/dev/null || echo "ERROR")

  if [ "$status" = "ERROR" ]; then
    echo "⚠️  Agent $agent_name: worktree not found or invalid"
    continue
  fi

  if [ -z "$status" ]; then
    # Clean worktree - safe to sync
    echo "✅ Agent $agent_name: clean worktree, auto-syncing..."

    # Sync using git -C
    if git -C "$agent_dir" merge main --no-edit; then
      echo "   ✓ Synced successfully"
    else
      echo "   ✗ Merge failed - conflicts detected"
      /maw.hey "$agent_name" "⚠️ Auto-sync failed due to conflicts. Please resolve: git merge main"
    fi
  else
    # Dirty worktree - notify agent
    echo "⚠️  Agent $agent_name: has uncommitted work"
    echo "   Files changed:"
    git -C "$agent_dir" status --short | sed 's/^/   /'

    # Ask agent to sync when ready
    /maw.hey "$agent_name" "📢 Main branch updated. You have uncommitted work. Please sync when ready: /maw.sync"
  fi

  echo ""
done

echo "✅ Smart sync complete"
```

## Usage

### From Main Agent (Root Worktree)

```bash
# Smart sync all agents
/maw.smart-sync

# Expected output:
# 📥 Main agent: pulling from origin/main...
# Already up to date.
#
# 🔄 Checking agent worktrees...
#
# ✅ Agent 1: clean worktree, auto-syncing...
#    ✓ Synced successfully
#
# ⚠️  Agent 2: has uncommitted work
#    Files changed:
#    M  src/app.js
#    ?? test.txt
#
# ✅ Agent 3: clean worktree, auto-syncing...
#    ✓ Synced successfully
#
# ✅ Smart sync complete
```

## Comparison: Simple vs Smart Sync

### Simple Sync (`/maw.sync`)
```
Main → Pull from remote
Main → Broadcast "/maw.sync" to ALL agents
Agents → Each runs "git merge main" immediately

❌ Problem: Disrupts agents mid-work
❌ Problem: May cause conflicts if agent has changes
```

### Smart Sync (`/maw.smart-sync`)
```
Main → Pull from remote
Main → Check EACH agent's status with git -C
  ├─ Clean? → Auto-sync with git -C merge
  └─ Dirty? → Send notification, let agent decide

✅ Benefit: Respects agent's current work
✅ Benefit: Auto-syncs when safe
✅ Benefit: Notifies when manual action needed
```

## Agent Response Workflow

When an agent receives "Please sync when ready":

```bash
# Agent checks their own status
git status

# If ready to sync
git add .
git commit -m "WIP: save current work"
git merge main

# Or if work is complete
git add .
git commit -m "feat: complete feature X"
git merge main
git push origin agents/N
```

## Safety Rules

### Main Agent Must:
- ✅ Always check worktree status before syncing
- ✅ Use `git -C agents/N` to operate on agent worktrees
- ✅ Handle merge conflicts gracefully
- ✅ Notify agents when auto-sync fails
- ❌ NEVER force-sync dirty worktrees
- ❌ NEVER use `git -C agents/N reset --hard`

### Agents Must:
- ✅ Respond to sync notifications when ready
- ✅ Commit or stash work before syncing
- ✅ Report if sync creates conflicts
- ❌ NEVER ignore sync notifications indefinitely

## Advanced: Conflict Detection

```bash
#!/bin/bash
# Check if agent would have merge conflicts

agent_dir="agents/1"
agent_name=$(basename "$agent_dir")

# Try merge in dry-run mode (requires git 2.20+)
if git -C "$agent_dir" merge main --no-commit --no-ff 2>&1 | grep -q "CONFLICT"; then
  echo "⚠️  Agent $agent_name: would have merge conflicts"
  /maw.hey "$agent_name" "🚨 Sync would cause conflicts. Please review and sync manually."

  # Abort the dry-run merge
  git -C "$agent_dir" merge --abort
else
  echo "✅ Agent $agent_name: can sync cleanly"
  git -C "$agent_dir" merge main --no-edit
fi
```

## Edge Cases

### Case 1: Agent in Middle of Merge
```bash
# Check for ongoing merge
if git -C "$agent_dir" rev-parse MERGE_HEAD 2>/dev/null; then
  echo "⚠️  Agent $agent_name: merge in progress"
  /maw.hey "$agent_name" "Complete your current merge before syncing"
  continue
fi
```

### Case 2: Agent on Wrong Branch
```bash
# Check agent is on their own branch
agent_branch=$(git -C "$agent_dir" branch --show-current)
expected_branch="agents/$agent_name"

if [ "$agent_branch" != "$expected_branch" ]; then
  echo "⚠️  Agent $agent_name: on wrong branch ($agent_branch)"
  /maw.hey "$agent_name" "You're on $agent_branch, expected $expected_branch"
  continue
fi
```

### Case 3: Agent Worktree Doesn't Exist
```bash
if [ ! -d "$agent_dir" ]; then
  echo "⚠️  Agent worktree not found: $agent_dir"
  continue
fi
```

## Visual Workflow

```
┌─────────────────────────────────────────────────────┐
│ MAIN AGENT: /maw.smart-sync                         │
└─────────────────────────────────────────────────────┘
                        │
                        ├─ git pull --ff-only origin/main
                        │
                        ▼
         ┌──────────────────────────────┐
         │ For each agent in agents/*   │
         └──────────────────────────────┘
                        │
         ┌──────────────┴──────────────┐
         │                             │
         ▼                             ▼
    git -C agents/N              git -C agents/N
    status --porcelain           status --porcelain
         │                             │
    Clean worktree               Dirty worktree
         │                             │
         ▼                             ▼
    git -C agents/N              /maw.hey N "Please
    merge main                   sync when ready"
         │                             │
         ▼                             ▼
    ✅ Auto-synced                ⚠️ Notification sent
                                       │
                                       ▼
                                  Agent commits work
                                  Agent runs /maw.sync
                                       │
                                       ▼
                                  ✅ Manual sync
```

## Command Summary

```bash
# Smart sync (recommended)
/maw.smart-sync

# Simple sync (use only if all agents are idle)
/maw.sync

# Check agent status without syncing
/maw.status

# Force sync specific agent (dangerous - use only if agent is stuck)
git -C agents/1 merge main
```

## When to Use Each Approach

**Use Smart Sync When:**
- Regular development workflow
- Multiple agents actively working
- Want to be respectful of agent's work
- Default choice for most situations

**Use Simple Sync When:**
- All agents are idle (you verified with /maw.status)
- Fresh session startup
- Emergency: all agents need immediate update

**Use Manual Sync When:**
- Agent has complex merge conflicts
- Agent needs custom merge strategy
- Testing sync behavior

## Best Practices

1. **Main agent should default to smart-sync**
   - Checks before acting
   - Respectful of agent autonomy

2. **Agents should respond to notifications promptly**
   - Don't ignore sync requests
   - Communicate if blocked

3. **Use git -C for cross-worktree operations**
   - Don't cd into agent directories
   - Maintain identity separation

4. **Handle conflicts gracefully**
   - Don't force-sync on conflict
   - Notify agent and let them resolve

5. **Log all sync operations**
   - Track what was synced when
   - Helps debug sync issues

## Integration with Golden Rule

This smart-sync approach reinforces **The Golden Rule**:

> Know who you are (main or agent),
> sync from the right source (remote or local main),
> never force anything (-f),
> **respect all boundaries** (stay in your worktree).

**Smart-sync adds:**
- ✅ Check before syncing (respect agent's work)
- ✅ Auto-sync when safe (efficiency)
- ✅ Notify when manual action needed (communication)
- ✅ Never disrupt ongoing work (courtesy)

---

**Last Updated**: 2025-12-01
**Replaces**: Simple broadcast sync
**Status**: Recommended for all multi-agent workflows
