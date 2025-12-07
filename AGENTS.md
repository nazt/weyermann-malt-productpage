# AGENTS.md - Multi-Agent Workflow Instructions

## Agent Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│                    MAIN AGENT                           │
│              (Orchestrator - Claude Code)               │
│                   Root repo: main                       │
│         Coordinates all agents, sends tasks             │
└─────────────────────┬───────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
┌───────────┐  ┌───────────┐  ┌───────────┐
│  AGENT 1  │  │  AGENT 2  │  │  AGENT 3  │
│  (Claude) │  │  (Codex)  │  │  (Codex)  │
│  agents/1 │  │  agents/2 │  │  agents/3 │
│   LEFT    │  │  CENTER   │  │   RIGHT   │
└───────────┘  └───────────┘  └───────────┘
```

## Your Identity

Check who you are:
```bash
pwd                        # Your path
git branch --show-current  # Your branch
```

| Path | Branch | You Are |
|------|--------|---------|
| `/repo` | `main` | Main Agent (Orchestrator) |
| `/repo/agents/1` | `agents/1` | Agent 1 (Claude) |
| `/repo/agents/2` | `agents/2` | Agent 2 (Codex) |
| `/repo/agents/3` | `agents/3` | Agent 3 (Codex) |

## Communication Style (Like Claude Code)

**Be direct and concise:**
- No preambles: Skip "Sure!", "I'd be happy to help!", "Certainly!"
- No conclusions: Skip "Let me know if you need anything else"
- Action-focused: Do the task, report the result

**Output format:**
```
[What was done - 1 line]

- File: path/to/file.md
- Command: `executed command`

[Brief result if needed]
```

**Example - Good:**
```
Created haiku file.

- File: contributions/haiku.md
- Signaled: touch .tmp/agent2-done
```

**Example - Bad:**
```
Sure! I'd be happy to help you create a haiku file. Let me do that for you.

I've created the file at contributions/haiku.md with a beautiful haiku about collaboration.

Is there anything else you'd like me to help with?
```

## Task Execution

When you receive a task:

1. **Read** - Understand what's asked
2. **Execute** - Do it without asking clarifying questions
3. **Signal** - Touch the signal file as instructed
4. **Report** - Brief summary of what was done

## Signal Files

Always use absolute paths for signal files:
```bash
touch /Users/nat/000-workshop-product-page/.tmp/agent{N}-done
```

## Collaboration

- You work in parallel with other agents
- Don't wait for other agents unless told
- Focus on your assigned task
- Keep responses minimal

## Git Workflow

Your branch: `agents/{N}`

```bash
# Before work
git status

# After work
git add .
git commit -m "feat: brief description"
git push origin $(git branch --show-current)

# Create PR to main
gh pr create --base main
```

## Short Codes

When you receive these short codes, execute the corresponding action:

### `rrr` - Retrospective
Create a session retrospective in `ψ-retrospectives/YYYY-MM/DD/`:
```markdown
# Session Retrospective - Agent {N}

**Date**: YYYY-MM-DD
**Agent**: Agent {N} (Claude/Codex)

## Session Summary
[What you did today - 2-3 sentences]

## Technical Details
- Files created/modified
- Commands executed
- Key decisions made

## What Went Well
- [Success 1]
- [Success 2]

## What Could Improve
- [Challenge 1]
- [Challenge 2]

## Lessons Learned
- [Key takeaway 1]
- [Key takeaway 2]
```

### `lll` - List Status
Run and report:
```bash
git status --short
git log --oneline -5
ls contributions/
```

### `ccc` - Context
Summarize current work context and save to contributions/context.md

## Sync Rules (IMPORTANT)

### Use `maw sync` - NOT manual git commands

**From Main Agent:**
```bash
maw sync              # Git-based sync (commits, pushes, broadcasts)
maw sync --files      # Quick copy AGENTS.md, CLAUDE.md to all worktrees
```

**From Agent Worktree:**
```bash
maw sync              # Merges main into current agent branch
```

### Sync Flow
1. Main: `maw sync` → commits, pushes, tells agents to sync
2. Agents: receive sync message → merge origin/main automatically

### Rules
- Always commit your work before sync
- Use `maw sync`, not raw git commands
- See `.agents/scripts/sync.sh` for implementation

## Files to Read

- `CLAUDE.md` - Full project guidelines
- `AGENTS.md` - This file (agent-specific rules)
