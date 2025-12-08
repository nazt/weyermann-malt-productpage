# Delegate, Don't Read Code Directly

**Created**: 2025-12-08
**Source**: User correction during MAW self-improvement session - "why you read the code yourself please use context-finder"
**Tags**: `delegation` `context-finder` `anti-pattern` `opus` `haiku` `cost`

---

## Context Links

- **Commits**: `b715b01`, `1fca390`
- **Raw Logs**: ψ-logs/2025-12/08/19.33_maw-subagent-self-improvement.md
- **Retrospective**: ψ-retrospectives/2025-12/08/19.35_maw-self-improvement-session.md
- **Related**: ψ-learnings/006-gogogo-delegation-workflow.md

---

## Key Insight

> **Main agent (Opus) should NEVER read source code directly. Always delegate to context-finder (Haiku) for research.**

---

## The Problem

| What I Did | What Happened |
|------------|---------------|
| Started running `cat .agents/profiles/profile14.sh` | User stopped me immediately |
| Started running `grep` commands directly | User said "use context-finder" |
| Read 100 lines of start-agents.sh | Wasted expensive Opus tokens |

**Why it's bad**:
- Opus tokens cost ~15x more than Haiku
- Main agent context gets polluted with code
- Breaks the delegation pattern we established
- User had to correct me TWICE in one session

---

## The Solution

### Pattern: Delegate-First Research

```
WRONG:
  Main Agent → cat file.sh → reads 200 lines → answers

RIGHT:
  Main Agent → Task(context-finder, "find X") → gets summary → answers
```

**When to use**: ANY time you need to read code, search files, or gather information
**Why it works**: Haiku is cheap, fast, and returns only what's needed

### The Rule

```
IF task = "understand code" or "find config" or "search for X"
THEN spawn context-finder
NEVER use cat, grep, or Read tool for exploration
```

---

## Anti-Patterns

| Don't Do This | Do This Instead |
|---------------|-----------------|
| `cat file.sh` to understand code | `Task(context-finder, "explain file.sh")` |
| `grep -r "pattern"` to find usage | `Task(context-finder, "find pattern usage")` |
| Read file then summarize | Ask context-finder to summarize |
| "Let me check this file..." | "Let me ask context-finder..." |

---

## Exceptions (When Direct Read is OK)

| Situation | Why OK |
|-----------|--------|
| File you're about to EDIT | Need exact content for Edit tool |
| Single specific line lookup | Faster than spawning agent |
| User explicitly asks to see file | They want the raw content |
| Small config file (<20 lines) | Overhead not worth it |

---

## Summary

| Concept | Details |
|---------|---------|
| Default action | Delegate to context-finder |
| Cost ratio | Opus ~15x more expensive than Haiku |
| User feedback | Corrected me twice in one session |
| Pattern name | Delegate-first research |

---

## Apply When

- Need to understand how code works
- Searching for configuration
- Finding where something is defined
- Exploring unfamiliar parts of codebase
- Gathering context for a task
- ANY research task

## Remember

**"Why are you reading that yourself? Use context-finder."** - User, 2025-12-08

This is not a suggestion. This is the rule.
