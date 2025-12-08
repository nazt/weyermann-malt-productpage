---
description: Sends a prompt to codex running in tmux pane 1
argument-hint: <prompt>
allowed-tools:
  - Bash(.claude/commands/maw.codex.sh:*)
---

Goal: Send a prompt to codex agent running in tmux pane 1 (worktree pane).

Inputs:
- $* → The prompt to send to codex. All arguments are concatenated as the prompt.

Behavior:
1) Call the script with the prompt arguments.
2) The script sends the prompt to tmux pane 1 and presses Enter.

Shell template:

```bash
.claude/commands/maw.codex.sh "$*"
```

Usage examples:
- `/maw.codex explain this function`
- `/maw.codex refactor the authentication logic`
- `/maw.codex what are the performance implications?`

Notes:
- Requires tmux session to be running (use .agents/start-agents.sh to create it).
- Sends to pane 1, which should be the codex worktree pane in profile1 layout.
- Automatically detects sessions with custom prefixes (e.g., ai-repo-suffix).
- Set SESSION_PREFIX environment variable if using a non-default base prefix.
