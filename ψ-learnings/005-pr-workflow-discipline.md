# PR Workflow Discipline

**Created**: 2025-12-08
**Source**: Session where we built PR mode but pushed to main anyway
**Tags**: `pr-flow` `github-flow` `discipline` `executor`

---

## Context Links
- **Commits**: `ad996b0`, `b8f5170`
- **Raw Logs**: ψ-logs/2025-12/08/17.00_never-push-main-use-pr.md
- **Agent**: .claude/agents/executor.md

---

## Key Insight

> **Building a tool does NOT mean using the tool. Discipline requires enforcement, not just capability.**

---

## The Problem

| What We Tried | What Happened |
|---------------|---------------|
| Created executor "with PR" mode | Pushed the update directly to main |
| Added `gh pr merge` to blocklist | Still no PR created |
| User asked "where PR?" | None existed |

---

## The Solution

### Pattern: Always Use PR Mode
```
Execute issue #70 with PR    ← ALWAYS USE THIS
```

**NOT:**
```
Execute issue #70            ← DON'T USE THIS
```

**When to use**: Every time you execute an issue
**Why it works**: Forces branch creation, PR review, human approval

---

## Anti-Patterns

| Don't Do This | Do This Instead |
|---------------|-----------------|
| `Execute issue #70` | `Execute issue #70 with PR` |
| Commit directly to main | Create branch first |
| Push without PR | Always create PR for review |

---

## Summary

| Concept | Details |
|---------|---------|
| **Tool** | Executor has PR mode |
| **Problem** | We didn't use it ourselves |
| **Rule** | ALWAYS add "with PR" |
| **Enforcement** | PR mode should be default |

---

## Apply When

- Executing ANY issue via executor
- Making changes that should be reviewed
- Anytime you're about to commit to main
