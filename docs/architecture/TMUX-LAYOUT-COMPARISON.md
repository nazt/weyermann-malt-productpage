# TMux Layout Comparison - Profile6, Profile8, Profile9

**Session Date**: 2025-12-08
**Created**: After exploring layout options with user

---

## Quick Comparison

| Layout | Type | Windows | Panes | Visibility | Width | Best For |
|--------|------|---------|-------|-----------|-------|----------|
| **Profile6** | 3x2 Grid | 1 | 5 (+ space) | Agents 1-5 | 33% | Expansion room |
| **Profile7** | 3x2 Grid | 1 | 6 | All 6 agents | 33% | Full system view |
| **Profile8** | 2 Windows | 2 | 3 each | One tier at a time | 100% | Semantic focus |
| **Profile9** | 3x2 Grid | 1 | 6 | All 6 agents | 33% | Classic layout |

---

## Profile6: 3x2 Grid with Expansion Space

```
┌─────────────┬─────────────┬─────────────┐
│ Agent 1     │ Agent 2     │ Agent 3     │
├─────────────┼─────────────┼─────────────┤
│ Agent 4     │ Agent 5     │ (Monitor)   │
└─────────────┴─────────────┴─────────────┘
```

**Use**: When you want room to add more agents later
```bash
.agents/scripts/start-agents.sh profile6
```

---

## Profile7: 3x2 Grid with Active Monitor

```
┌─────────────┬─────────────┬─────────────┐
│ Agent 1     │ Agent 2     │ Agent 3     │
├─────────────┼─────────────┼─────────────┤
│ Agent 4     │ Agent 5     │ Monitor     │
│             │             │ (watching)  │
└─────────────┴─────────────┴─────────────┘
```

**Features**:
- Pane 6 auto-starts `maw status watch`
- Real-time agent status visible
- All 6 positions filled

**Use**: When you want live monitoring of all agents
```bash
.agents/scripts/start-agents.sh profile7
```

---

## Profile8: 2 Windows (Semantic Separation)

### Window 1: Execution Layer
```
┌──────────────────────────────┐
│ Agent 1 (Shadow Claude)      │
├──────────────────────────────┤
│ Agent 2 (Executor)           │
├──────────────────────────────┤
│ Agent 3 (Executor)           │
└──────────────────────────────┘
```

### Window 2: Specialization + Monitor
```
┌──────────────────────────────┐
│ Agent 4 (PocketBase)         │
├──────────────────────────────┤
│ Agent 5 (Research)           │
├──────────────────────────────┤
│ Monitor (maw status watch)   │
└──────────────────────────────┘
```

**Navigation**:
- `Ctrl+b n` = Next window (Execution → Specialists)
- `Ctrl+b p` = Previous window (Specialists → Execution)

**Use**: When you prefer semantic grouping and wider text
```bash
.agents/scripts/start-agents.sh profile8
```

**Width**: ~100% per pane (vs 33% in grid layouts)

---

## Profile9: Classic 3x2 Grid (1 2 3 / 4 5 6)

```
┌─────────────┬─────────────┬─────────────┐
│ 1: Shadow   │ 2: Executor │ 3: Executor │
│ Claude      │             │             │
├─────────────┼─────────────┼─────────────┤
│ 4: Pocket   │ 5: Research │ 6: Monitor  │
│ Base        │             │ (watching)  │
└─────────────┴─────────────┴─────────────┘
```

**Features**:
- All 6 agents visible simultaneously
- Equal 3x2 grid layout
- Pane 6 auto-starts monitoring
- Numbered layout (1-6 natural reading order)

**Navigation**:
- `Ctrl+b ←` = Move left
- `Ctrl+b →` = Move right
- `Ctrl+b ↑` = Move up
- `Ctrl+b ↓` = Move down
- `Ctrl+b z` = Zoom current pane

**Use**: When you want all 6 agents visible at once
```bash
.agents/scripts/start-agents.sh profile9
```

---

## Choosing Your Layout

### Use Profile6 If:
- You plan to add more agents (7+)
- You want flexibility for future growth
- You don't need all 5 agents active simultaneously

### Use Profile7 If:
- You want to see all 6 agents + live monitoring
- You like the 3x2 grid layout
- You want auto-starting monitor pane

### Use Profile8 If:
- You prefer semantic grouping (Execution vs Support)
- You want wider text (100% width per pane)
- You work on one tier at a time
- You value clear separation of concerns

### Use Profile9 If:
- You want a classic "1 2 3 / 4 5 6" layout
- You need all 6 agents visible simultaneously
- You like natural numbering order
- You want live monitoring (auto-starts in pane 6)

---

## Width Comparison

| Layout | Pane Width | Text Readability |
|--------|-----------|------------------|
| Profile6 | ~61 chars | Moderate (3 panes per row) |
| Profile7 | ~61 chars | Moderate (3 panes per row) |
| **Profile8** | **~100 chars** | **Excellent (1 pane per window)** |
| Profile9 | ~61 chars | Moderate (3 panes per row) |

---

## Quick Start

### View Available Profiles
```bash
ls .agents/profiles/profile*.sh
```

### Start a Layout
```bash
# Start profile8 (semantic, 2 windows)
.agents/scripts/start-agents.sh profile8

# Start profile9 (classic 1-6 grid)
.agents/scripts/start-agents.sh profile9

# Start profile7 (monitored grid)
.agents/scripts/start-agents.sh profile7

# Detach mode (don't attach automatically)
.agents/scripts/start-agents.sh profile8 -d

# Kill existing session first
tmux kill-session -t ai-000-workshop-product-page
.agents/scripts/start-agents.sh profile8
```

### Navigate (All Layouts)
```bash
# Window/Pane Navigation
Ctrl+b n          # Next window (profile8 only)
Ctrl+b p          # Previous window (profile8 only)
Ctrl+b ←  ↑  →  ↓ # Move between panes

# Zoom
Ctrl+b z          # Zoom/unzoom current pane

# Resize
Ctrl+b :          # Enter command mode
> resize-pane -U 5  # Shrink up by 5 lines
> resize-pane -R 5  # Grow right by 5 chars

# List panes
Ctrl+b :
> list-panes      # Show all panes
```

---

## Agent Descriptions

| # | Name | Role | Specialty |
|---|------|------|-----------|
| 1 | Shadow Claude | Tactical executor | Runs your `/` commands (speckit, rrr, etc) |
| 2 | Executor | General execution | Runs assigned tasks |
| 3 | Executor | General execution | Runs assigned tasks |
| 4 | PocketBase Specialist | Database operations | Collections, CRUD, schema, API testing |
| 5 | Research Specialist | Knowledge gathering | Web search, documentation, analysis |
| 6 | Monitor | Status tracking | Real-time agent status display |

---

## Related Documentation

- Issue #36: TMux Layout Testing (original layout preview)
- Issue #37: 6-Agent TMux Layout Implementation (grid layouts)
- 6-AGENTS-QUICKSTART.md: Quick reference for 6-agent system
- AGENTS.md: Agent responsibilities and communication patterns

---

**Last Updated**: 2025-12-08
**Layouts Available**: 4 (Profile6, Profile7, Profile8, Profile9)
**Status**: ✅ All tested and working
