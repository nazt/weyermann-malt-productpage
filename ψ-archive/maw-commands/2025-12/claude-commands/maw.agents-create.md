---
description: Create or list agents using worktrees under agents/; runs the shell script
argument-hint: create <name> [-m <model>] [--branch <branch>] | list
allowed-tools:
  - Bash(chmod:+x .agents/agents.sh)
  - Bash(.agents/agents.sh create:*)
  - Bash(.agents/agents.sh list)
---

Goal: Create/list agents by calling the local shell script. Uses git worktrees directly at `agents/<name>`.

Usage examples:
- `/maw.agents-create create codex2 -m codex --branch agents/codex2`
- `/maw.agents-create list`

Behavior (MVP):
- If `create <name>` and the agent is missing, propose a YAML patch like (for `.agents/agents.yaml`):
  ```yaml
  agents:
    <name>:
      branch: agents/<name>
      worktree_path: agents/<name>
      model: codex
      description: <optional>
  ```
- Then execute the script to create the agent and list results:
  ```bash
  chmod +x .agents/agents.sh
  .agents/agents.sh create <name>
  .agents/agents.sh list
  ```

Notes:
- This command invokes the shell with allowed tools. Ensure `.agents/agents.sh` exists and `yq` is installed.
