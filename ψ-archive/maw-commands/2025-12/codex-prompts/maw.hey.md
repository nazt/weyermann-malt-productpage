---
description: Send a message to a specific agent in the tmux session
argument-hint: <agent> <message>
allowed-tools:
  - Bash(.claude/commands/maw.hey.sh:*)
---

Goal: Send a prompt to a specific agent running in a tmux pane.

Inputs:
- $1 → Agent name (e.g., 1, 2, backend-api) or special target (root, all)
- $* → The message to send (all remaining arguments)

Behavior:
1) Discover available agents from agents/ directory
2) Map agent name to correct tmux pane
3) Send message to target pane and press Enter

Shell template:

```bash
.claude/commands/maw.hey.sh "$@"
```

Usage examples:
- `/maw.hey 1 analyse this repository structure`
- `/maw.hey 2 create a plan for the auth feature`
- `/maw.hey backend-api review the database schema`
- `/maw.hey root git status`
- `/maw.hey all git pull`

Special targets:
- **root** - Send to main worktree pane
- **all** - Broadcast to all agent panes (excludes root)

List agents:
- `/maw.hey --list` - Show available agents
- `/maw.hey --map` - Show agent to pane mapping

Notes:
- Requires tmux session to be running (use `maw start` to create it).
- Automatically detects sessions with custom prefixes.
- Works with any agent naming convention (1, 2, backend-api, etc.).
- Set SESSION_PREFIX environment variable if using a non-default base prefix.
