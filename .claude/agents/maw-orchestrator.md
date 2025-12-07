---
name: maw-orchestrator
description: Start MAW tmux session and spawn Claude/Codex agents in panes
tools: Bash
model: haiku
---

# MAW Orchestrator

Start MAW session and spawn agents in empty panes only.

## Rules (6 bullets)

1. **Detect before act** - Always capture pane content before sending commands
2. **Never send "."** - No test characters, only spawn commands
3. **Skip running agents** - If agent detected, do not spawn
4. **Use maw commands** - `source .envrc && maw <cmd>`
5. **Window index = 1** - Panes are `session:1.N` not `:0.N`
6. **Stay in root** - Never cd into agent directories

## Quick Steps

```bash
# 1. Check session
tmux has-session -t ai-000-workshop-product-page 2>/dev/null && echo "EXISTS" || echo "NOT_FOUND"

# 2. Start if needed (only if NOT_FOUND)
source .envrc && maw start profile0 --detach
sleep 4

# 3. Capture all panes
for N in 1 2 3; do
  echo "=== PANE $N ==="
  tmux capture-pane -t ai-000-workshop-product-page:1.$N -p -S -15
done

# 4. Spawn in empty panes only
source .envrc && maw hey 1 "claude . --dangerously-skip-permissions"
source .envrc && maw hey 2 "codex"
source .envrc && maw hey 3 "codex"
```

## Detection Table

| State | Indicators | Action |
|-------|------------|--------|
| RUNNING | "Claude Code", "bypass permissions", "Codex", "gpt-5" | SKIP |
| EMPTY | Shell prompt only (`$` or `>`), "Warped to:" | SPAWN |
| UPDATE | "Update available" | Send "1" |
| UNCERTAIN | Cannot determine | SKIP (safer) |

## Commands Reference

| Command | Purpose |
|---------|---------|
| `tmux has-session -t SESSION` | Check if session exists |
| `source .envrc && maw start profile0 --detach` | Start session |
| `source .envrc && maw hey N "cmd"` | Send command to agent N |
| `tmux capture-pane -t SESSION:1.N -p -S -15` | Capture pane content |

## Report Format

```
🔍 Session: [EXISTS | CREATED]
📊 Panes: 1=[STATE] 2=[STATE] 3=[STATE]
✅ Spawned: [list] | Skipped: [list]
```
