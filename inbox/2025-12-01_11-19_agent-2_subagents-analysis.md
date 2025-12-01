# Subagents vs Multi-Agent Worktree (MAW) – Research (Dec 1, 2025)

## 1) What are subagents in Claude Code
- Pre-configured AI assistants with their own system prompt, tool allow-list, model choice, and a separate context window that Claude can delegate tasks to. citeturn0search0
- Stored as Markdown with YAML frontmatter; project agents live in `.claude/agents/`, user agents in `~/.claude/agents/`; project entries take precedence on name conflicts. citeturn0search0turn0search1
- Session-only agents can be passed via the CLI `--agents` flag or SDK `agents` parameter and are prioritized between project and user agents. citeturn0search0turn0search1
- Default subagent model is Sonnet unless overridden; specifying `tools` limits access, otherwise agents inherit all main-thread (and MCP) tools. citeturn0search0

## 2) How subagents work
- Invocation: Claude auto-selects a subagent when a request matches its `description`, or you can call one explicitly (“Use the code-reviewer subagent…”). citeturn0search0
- Each subagent runs with an independent context window but shares the main session’s workspace; tool access is restricted to the allow-list you define (or all tools if omitted). citeturn0search0turn0search1
- Definition shape: YAML frontmatter with `name`, `description`, optional `tools`, optional `model`, followed by the prompt body. citeturn0search1

## 3) How this differs from our Multi-Agent Worktree (MAW) workflow
- MAW tools (e.g., `claude-worktree`, Conductor) create separate git worktrees and a dedicated Claude session per branch, giving each agent its own directory plus preserved chat history. citeturn0search6turn1search1
- Subagents share the same working tree as the main session, so isolation is conversational (separate contexts) and via tool gating—not filesystem-level. citeturn0search0
- Concurrency: subagents run sequentially inside one session; MAW allows multiple Claude Code agents truly in parallel on separate worktrees/branches. citeturn0search6turn1search1
- Change safety: subagents write to the active checkout (edits can interleave); MAW quarantines changes per worktree until you merge, reducing conflict risk. citeturn0search6

## 4) Use cases
- Subagents: reusable specialist roles (code review, read-only exploration, targeted debugging) where quick delegation and tool gating matter and writing into the current branch is acceptable. citeturn0search0
- MAW: parallel feature spikes, competing design ideas, or risky refactors where each agent needs isolated filesystem and conversation with merge/discard control. citeturn0search6turn1search1

## 5) Practical guidance
- Combine approaches: spawn multiple worktrees for parallel tracks, then equip each with project-checked-in subagents for consistent roles.
- Version control: keep `.claude/agents/*.md` in each worktree so role definitions travel with branches; gate powerful tools to only the agents that require them.
