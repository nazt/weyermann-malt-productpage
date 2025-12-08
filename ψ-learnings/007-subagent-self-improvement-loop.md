# Subagent Self-Improvement Loop

**Created**: 2025-12-08
**Source**: MAW subagent was slow (49s) and wrong (1 window instead of 2)
**Tags**: `subagent` `self-improvement` `delegation` `iteration` `maw`

---

## Context Links

- **Issues**: #78 (MAW cleanup)
- **Commits**: `b715b01` (maw.md update)
- **Raw Logs**: ψ-logs/2025-12/08/19.33_maw-subagent-self-improvement.md
- **Retrospective**: ψ-retrospectives/2025-12/08/19.35_maw-self-improvement-session.md

---

## Key Insight

> **When a subagent underperforms, the main agent can self-improve it through: research → update → test → iterate.**

---

## The Problem

| What We Tried | What Happened |
|---------------|---------------|
| maw start (default) | 49s, 16.7k tokens, wrong layout (1 window) |
| Read code directly | User corrected: "use context-finder" |
| Complex pane detection | Over-engineered, slow, unnecessary |

---

## The Solution

### Pattern: Self-Improvement Loop

```
Main Agent (Opus)
    ↓ "find profile config"
context-finder (Haiku)
    ↓ returns findings
Main Agent
    ↓ updates .claude/agents/[agent].md
Subagent (Haiku)
    ↓ tests new behavior
Main Agent
    ↓ verifies, iterates if needed
```

**When to use**: Any subagent taking >30s for simple task, or producing wrong output
**Why it works**: Main agent has context + authority to modify; subagents are cheap to spawn for testing

### Implementation Steps

1. **Identify problem**: Measure time, tokens, output correctness
2. **Research with context-finder**: Don't read code directly - delegate
3. **Update agent definition**: Edit `.claude/agents/[name].md`
4. **Test immediately**: Spawn the subagent with same task
5. **Verify output**: Check results match requirements
6. **Iterate if needed**: Repeat steps 3-5

---

## Anti-Patterns

| Don't Do This | Do This Instead |
|---------------|-----------------|
| Read code directly as main agent | Use context-finder to research |
| Accept slow subagent performance | Investigate and fix the definition |
| Complex state detection | Simple kill → start → verify |
| Assume existing definitions are correct | Validate against requirements |

---

## Summary

| Concept | Details |
|---------|---------|
| Pattern | Self-improvement loop |
| Trigger | Subagent >30s or wrong output |
| Tools | context-finder for research, direct edit for update |
| Validation | Spawn and test immediately |
| Result | maw.md: 200 → 100 lines, correct output |

---

## Apply When

- Subagent takes >30 seconds for simple task
- Subagent produces wrong output
- Subagent uses wrong defaults (like profile0 vs profile14)
- Token cost seems excessive for the task
- User feedback indicates subagent behavior is wrong
