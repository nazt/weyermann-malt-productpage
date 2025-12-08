# TMux Layout Preview - 6-Agent Profile

**Issue**: #36
**Profile**: profile6 (3x2 grid layout)
**Status**: Ready for testing

---

## Expected Layout Visualization (3x2 Grid)

### Full Screen View (Typical Terminal ~120 chars x 30+ lines)

```
┌────────────────────────────────────┬────────────────────────────────────┬────────────────────────────────────┐
│                                    │                                    │                                    │
│           PANE 0 (1/3)             │           PANE 1 (1/3)             │           PANE 2 (1/3)             │
│                                    │                                    │                                    │
│   Agent 1: Shadow Claude           │   Agent 2: General Executor        │   Agent 3: General Executor        │
│                                    │                                    │                                    │
│   Executes / commands              │   Handles assigned tasks           │   Handles assigned tasks           │
│   /nnn, /plan, /analyze, /rrr      │   Responds via inbox               │   Responds via inbox               │
│                                    │                                    │                                    │
│   $ claude code env                │   $ claude code env                │   $ claude code env                │
│   > Ready for directives           │   > Ready for maw hey              │   > Ready for maw hey              │
│                                    │                                    │                                    │
├────────────────────────────────────┼────────────────────────────────────┼────────────────────────────────────┤
│                                    │                                    │                                    │
│           PANE 3 (2/3)             │           PANE 4 (2/3)             │         PANE 5 (3/3)               │
│                                    │                                    │                                    │
│   Agent 4: PocketBase Specialist   │   Agent 5: Research Specialist     │       Monitor / Logs               │
│                                    │                                    │                                    │
│   Database operations only         │   Web search & documentation       │   Agent status, results            │
│   Collections, CRUD, API testing   │   Analysis, patterns, findings     │   Inbox messages, signals          │
│                                    │                                    │                                    │
│   $ claude code env                │   $ claude code env                │   $ maw status watch               │
│   > Ready for maw hey              │   > Ready for maw hey              │   > Real-time monitoring           │
│                                    │                                    │                                    │
└────────────────────────────────────┴────────────────────────────────────┴────────────────────────────────────┘
```

### Minimal View (Text Only)

```
┌─────────────────────┬─────────────────────┬─────────────────────┐
│    Agent 1 (1)      │    Agent 2 (2)      │    Agent 3 (3)      │
│  Shadow Claude      │  Executor           │  Executor           │
│                     │                     │                     │
├─────────────────────┼─────────────────────┼─────────────────────┤
│    Agent 4 (4)      │    Agent 5 (5)      │  Monitor (6)        │
│  PocketBase         │  Research           │  Status             │
│                     │                     │                     │
└─────────────────────┴─────────────────────┴─────────────────────┘
```

---

## Technical Details

### Profile Configuration
**File**: `.agents/profiles/profile6.sh`

```bash
LAYOUT_TYPE="grid-3x2"    # 3 columns, 2 rows
```

### Tmux Split Commands (Execution Order)

```bash
# 1. Start base session in root directory
tmux new-session -d -s "ai-000-workshop-product-page" -c "$REPO_ROOT"
# Creates: Pane 0 (root)

# TOP ROW: Create 3 columns (Agent 1 | Agent 2 | Agent 3)
# ========================================================

# 2. Split Pane 0 horizontally, 66% left, 34% right
# Pane 0 (33%) | Pane 1 (67% right side)
tmux split-window -h -t "$SESSION:0.0" -p 66
# Now: Pane 0 = 33% | Pane 1 = 67%

# 3. Split Pane 1 horizontally, 50% left, 50% right
# Pane 0 (33%) | Pane 1 (33%) | Pane 2 (33%)
tmux select-pane -t "$SESSION:0.1"
tmux split-window -h -t "$SESSION:0.1" -p 50
# Now: Pane 0 = 33% | Pane 1 = 33% | Pane 2 = 33% (TOP ROW COMPLETE)

# BOTTOM ROW: Create 3 columns below (Agent 4 | Agent 5 | Monitor)
# ================================================================

# 4. Split Pane 0 vertically, 50% top, 50% bottom
# Creates bottom-left pane (Pane 3)
tmux select-pane -t "$SESSION:0.0"
tmux split-window -v -t "$SESSION:0.0" -p 50
# Now:
#   Top-left = Pane 0 (33% width, 50% height)
#   Bottom-left = Pane 3 (33% width, 50% height)

# 5. Split Pane 1 vertically, 50% top, 50% bottom
# Creates bottom-center pane (Pane 4)
tmux select-pane -t "$SESSION:0.1"
tmux split-window -v -t "$SESSION:0.1" -p 50
# Now:
#   Top-center = Pane 1 (33% width, 50% height)
#   Bottom-center = Pane 4 (33% width, 50% height)

# 6. Split Pane 2 vertically, 50% top, 50% bottom
# Creates bottom-right pane (Pane 5)
tmux select-pane -t "$SESSION:0.2"
tmux split-window -v -t "$SESSION:0.2" -p 50
# Now:
#   Top-right = Pane 2 (33% width, 50% height)
#   Bottom-right = Pane 5 (33% width, 50% height)
```

### Resulting Grid Distribution

**Width Distribution (3 columns)**:
- **Column 1**: 33% (Pane 0 top, Pane 3 bottom)
- **Column 2**: 33% (Pane 1 top, Pane 4 bottom)
- **Column 3**: 33% (Pane 2 top, Pane 5 bottom)

**Height Distribution (2 rows)**:
- **Row 1 (Top)**: 50% (Agents 1, 2, 3)
- **Row 2 (Bottom)**: 50% (Agents 4, 5, Monitor)

**Grid Layout**:
```
┌─────────────────┬─────────────────┬─────────────────┐
│  Pane 0 (1)     │  Pane 1 (2)     │  Pane 2 (3)     │ 50%
│  Agent 1        │  Agent 2        │  Agent 3        │
├─────────────────┼─────────────────┼─────────────────┤
│  Pane 3 (4)     │  Pane 4 (5)     │  Pane 5 (6)     │ 50%
│  Agent 4        │  Agent 5        │  Monitor        │
└─────────────────┴─────────────────┴─────────────────┘
  33%               33%               33%
```

---

## Pane Reference Format

```
Session: ai-000-workshop-product-page
Window:  0 (default)
Panes:   0, 1, 2, 3, 4

Tmux Pane Reference Syntax:
  SESSION:WINDOW.PANE

Examples:
  ai-000-workshop-product-page:0.0  → Pane 0 (Agent 1)
  ai-000-workshop-product-page:0.1  → Pane 1 (Agent 2)
  ai-000-workshop-product-page:0.2  → Pane 2 (Agent 3)
  ai-000-workshop-product-page:0.3  → Pane 3 (Agent 4)
  ai-000-workshop-product-page:0.4  → Pane 4 (Agent 5)
```

---

## Navigation in Tmux

### Keyboard Shortcuts

```bash
# Prefix: Ctrl+b (default)

# Navigate between panes (works in grid!)
Ctrl+b ←  → Move to left pane
Ctrl+b →  → Move to right pane
Ctrl+b ↑  → Move to top pane
Ctrl+b ↓  → Move to bottom pane

# Resize panes
Ctrl+b : resize-pane -L 5   → Shrink current pane from right (5 chars)
Ctrl+b : resize-pane -R 5   → Grow current pane to right (5 chars)

# Zoom
Ctrl+b z  → Zoom current pane (full screen)
Ctrl+b z  → Unzoom

# List panes
Ctrl+b :  → Enter command mode
> list-panes  → Show all panes

# Send command to pane
Ctrl+b :
> send-keys -t 0.1 "command here" C-m  → Execute in Pane 1
```

### With Mouse (if enabled)
```
Click pane   → Activate that pane
Drag border  → Resize panes
```

---

## What Happens Next

### Phase 1: Start Session
```bash
.agents/scripts/start-agents.sh profile6
```

**Output**:
```
📋 Using profile: profile6
Adding pane 0 (root)...
Adding pane 1 (Agent 1)...
Adding pane 2 (Agent 2)...
Adding pane 3 (Agent 3)...
Adding pane 4 (Agent 4)...
Adding pane 5 (Agent 5)...
✅ Session 'ai-000-workshop-product-page' created with 5 panes
💡 Attach with: tmux attach-session -t ai-000-workshop-product-page
```

### Phase 2: Verify Layout
```bash
tmux list-panes -t ai-000-workshop-product-page
```

**Expected Output**:
```
ai-000-workshop-product-page:0.0: [120x40] (active)
ai-000-workshop-product-page:0.1: [100x40]
ai-000-workshop-product-page:0.2: [90x40]
ai-000-workshop-product-page:0.3: [85x40]
ai-000-workshop-product-page:0.4: [85x40]
```

(Exact dimensions depend on terminal width)

### Phase 3: Attach
```bash
tmux attach-session -t ai-000-workshop-product-page
```

**What you'll see**:
- 6 panes in a row (left to right)
- Each agent ready for input ($ prompt visible)
- Window title showing: `ai-000-workshop-product-page:0`
- Status bar at bottom (pane numbers, time)

---

## Potential Issues & Solutions

### Issue 1: Panes Too Narrow
**Symptom**: Text wraps weirdly, hard to read
**Solution**:
```bash
# Option 1: Resize terminal wider
# Option 2: Zoom pane
Ctrl+b z  # Zoom current pane
Ctrl+b z  # Unzoom
# Option 3: Use profile6-grid (3x2 layout) instead
.agents/scripts/start-agents.sh profile6-grid
```

### Issue 2: Panes Don't Appear
**Symptom**: Only 1-2 panes visible
**Diagnosis**:
```bash
# Check how many agents exist
.agents/scripts/agents.sh list

# Check tmux pane count
tmux list-panes -t ai-000-workshop-product-page

# Expected: 5 panes (indices 0-4)
```

### Issue 3: Session Already Running
**Symptom**: "Session already exists" message
**Solution**:
```bash
# Option 1: Attach to existing
tmux attach-session -t ai-000-workshop-product-page

# Option 2: Kill and restart
tmux kill-session -t ai-000-workshop-product-page
.agents/scripts/start-agents.sh profile6
```

### Issue 4: Direnv Not Configured
**Symptom**: Warnings about direnv
**Solution**:
```bash
# Skip direnv configuration
SKIP_DIRENV_ALLOW=1 .agents/scripts/start-agents.sh profile6

# Or configure separately
.agents/scripts/direnv-allow.sh
```

---

## Size Recommendations

| Screen Width | Recommendation | Notes |
|--------------|------------------|-------|
| < 100 chars  | ❌ Too narrow | Use grid layout (profile6-grid) |
| 100-120 | ⚠️ Tight | Readable but cramped |
| 120-150 | ✅ Good | Recommended minimum |
| 150+ | ✅ Excellent | Comfortable |
| 200+ | ✅ Perfect | Ideal |

---

## Before You Start

### Checklist
- [ ] Terminal is at least 120 characters wide
- [ ] No existing tmux session (or ready to reuse)
- [ ] All 6 agents created (`git worktree list` shows all)
- [ ] `.agents/agents.yaml` configured
- [ ] `profile6.sh` file exists (`.agents/profiles/profile6.sh`)
- [ ] Ready to see 6 panes in action

### Commands to Run First
```bash
# Verify agents exist
git worktree list | grep agents/

# Verify profile exists
cat .agents/profiles/profile6.sh | grep LAYOUT_TYPE

# Check terminal width
echo $COLUMNS  # Should be >= 120
```

---

## Test Plan (Issue #36)

This preview is part of the comprehensive test plan documented in issue #36.

**Next Steps**:
1. Review this preview
2. Understand expected layout structure
3. Verify width distribution math
4. Proceed to actual tmux startup (issue #36)
5. Capture screenshot of result

---

**Document Status**: Preview Ready
**Date**: 2025-12-08
**Related Issue**: #36 (TMux Layout Testing)
**Profile**: profile6.sh (six-horizontal layout)
