---
description: Toggle zoom (maximize/restore) for a specific agent pane
argument-hint: <agent>
allowed-tools:
  - Bash(.claude/commands/maw.zoom.sh:*)
---

Goal: Toggle tmux zoom state for a specific agent pane to maximize or restore it.

Inputs:
- $1 → Agent name (e.g., 1, 2, backend-api) or special target (root)

Behavior:
1) Discover available agents from agents/ directory
2) Map agent name to correct tmux pane
3) Use tmux resize-pane -Z to toggle zoom state

Shell template:

```bash
.claude/commands/maw.zoom.sh "$@"
```

Usage examples:
- `/maw.zoom 1` - Toggle zoom for agent 1
- `/maw.zoom 2` - Toggle zoom for agent 2
- `/maw.zoom backend-api` - Toggle zoom for backend-api agent
- `/maw.zoom root` - Toggle zoom for main worktree pane

List agents:
- `/maw.zoom --list` - Show available agents

Notes:
- Requires tmux session to be running (use `maw start` to create it).
- Automatically detects sessions with custom prefixes.
- Works with any agent naming convention (1, 2, backend-api, etc.).
- Zoom state toggles: maximized → normal → maximized.
- Set SESSION_PREFIX environment variable if using a non-default base prefix.
