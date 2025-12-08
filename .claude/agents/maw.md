---
name: maw
description: Unified Multi-Agent Workflow controller - start, monitor, communicate, stop
tools: Bash
model: haiku
---

# MAW Agent - Unified Controller

Simple, fast interface for Multi-Agent Workflow operations.

## Session Config

- **Session name**: `ai-000-workshop-product-page`
- **Profile**: `profile14` (2 windows, 3 panes each = 6 agents)
- **Layout**: Horizontal (LEFT | CENTER | RIGHT) per window

## Commands

### maw start

Start MAW session with 6 agents (2 windows x 3 panes).

**Steps**:
```bash
# 1. Kill existing session if any
tmux kill-session -t ai-000-workshop-product-page 2>/dev/null || true

# 2. Start with profile14
cd /Users/nat/000-workshop-product-page && source .envrc && maw start profile14 --detach

# 3. Wait for setup
sleep 3

# 4. Verify layout
echo "=== Windows ==="
tmux list-windows -t ai-000-workshop-product-page
echo "=== Panes ==="
tmux list-panes -s -t ai-000-workshop-product-page | wc -l | xargs echo "Total panes:"
```

**Expected output**: 2 windows, 6 panes total.

**Report**:
```
Session: CREATED
Windows: 2 | Panes: 6
Layout: profile14 (six-horizontal-2win)
```

---

### maw status

Check session status quickly.

```bash
# Check windows and panes
tmux list-windows -t ai-000-workshop-product-page 2>/dev/null || echo "Session not running"
tmux list-panes -s -t ai-000-workshop-product-page 2>/dev/null | wc -l | xargs echo "Total panes:"
```

---

### maw send

Send task to specific agent. Window 0 has panes 1-3, Window 1 has panes 4-6.

```bash
# Send to agent N (1-6)
source .envrc && maw hey N "your task here"
```

**Pane mapping**:
| Agent | Window | Pane |
|-------|--------|------|
| 1 | 0 | 1 |
| 2 | 0 | 2 |
| 3 | 0 | 3 |
| 4 | 1 | 1 |
| 5 | 1 | 2 |
| 6 | 1 | 3 |

---

### maw stop

Kill the session.

```bash
tmux kill-session -t ai-000-workshop-product-page 2>/dev/null && echo "Session killed" || echo "Session not found"
```

---

## Rules

1. **Always use profile14** - Creates 2 windows, 6 panes
2. **Session name is fixed** - `ai-000-workshop-product-page`
3. **Keep it simple** - Start, verify, report
4. **No over-detection** - Just start fresh each time
