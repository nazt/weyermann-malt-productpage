# Subagents vs Multi-Agent Worktree (MAW) – Research (Dec 1, 2025)

## 1) What are subagents in Claude Code
- Subagents are pre-configured AI assistants with their own system prompt, tool allow-list, model choice, and a separate context window that Claude Code can delegate to when a request matches their description. citeturn0search0
- They are defined as Markdown files with YAML frontmatter (`name`, `description`, optional `tools`, optional `model`) and live at project scope `.claude/agents/` or user scope `~/.claude/agents/`, with project agents taking precedence. citeturn0search0turn0search11
- You can also inject session-only agents via CLI/SDK `--agents` or `agents` option; these sit between project and user agents in priority. citeturn0search0turn0search1

## 2) How subagents work
- Claude auto-selects a subagent based on its `description`, or you can invoke one explicitly (e.g., “Use the code-reviewer subagent”). citeturn0search0
- Each subagent runs with an independent context window but shares the same working directory; tool access inherits from the main session unless restricted in its `tools` list. citeturn0search0turn0search1
- Default subagent model is Sonnet unless overridden with `model` (`opus`, `haiku`, or `inherit`). citeturn0search0

## 3) How this differs from our Multi-Agent Worktree (MAW) workflow
- MAW tooling such as `agentree` and VibeTree spins up new git worktrees and dedicated AI sessions per branch, giving each agent its own directory and preserved conversation state. citeturn0search4turn0search8
- Subagents share the same working tree as the main session—only their conversational context is isolated—so edits land directly in the current checkout. citeturn0search0
- Concurrency: subagents run sequentially inside one Claude session; MAW supports true parallel agents running simultaneously in separate worktrees/branches. citeturn0search4turn0search8
- Change safety: subagent edits can interleave; MAW quarantines changes per worktree until you merge, reducing conflict risk. citeturn0search4

## 4) Use cases
- Subagents: reusable specialist roles (code reviewer, read-only explorer, debugger) where quick delegation, tool gating, and shared branch edits are acceptable. citeturn0search0
- MAW: parallel feature spikes, competing designs, or risky refactors requiring filesystem isolation and the option to merge/discard whole worktrees. citeturn0search4turn0search8

## 5) Practical guidance
- Combine both: spin up multiple worktrees for parallel tracks, then keep shared subagent definitions in each `.claude/agents/` so role behaviors stay consistent. citeturn0search0turn0search4
- Governance: limit powerful tools to the agents that need them; store project agents in version control; use explicit subagent calls for high-risk operations to avoid unintended edits. citeturn0search0
