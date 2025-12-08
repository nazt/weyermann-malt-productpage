# Related Format Standard

**Created**: 2025-12-08
**Source**: Iterating on issue reference format across 8 commits
**Tags**: `format` `issues` `related` `standard` `subagent`

---

## 🔗 Context Links
- **Issues**: #58, #59
- **Commits**: `75eebbd`, `b9d7b01`, `f247623`, `8383a4f`
- **Raw Logs**: ψ-logs/2025-12/08/10.19_subagents-and-formats.md
- **Related**: ψ-learnings/subagent-prompt-engineering.md

---

## Key Insight

> **Issue references should be `#N (YYYY-MM-DD)` sorted by issue number - GitHub shows title on hover, no need to repeat it.**

---

## The Problem

| What We Tried | What Happened |
|---------------|---------------|
| `#42 (2025-12-08) Auto-start Codex` | Too long, title redundant |
| `(2025-12-08) #42` | Date first confusing |
| `#42, #50, #38` | No dates, hard to trace |
| `🎯 #42 (2025-12-08)` | Emoji clutter |

---

## The Solution

### Pattern: Related Format
```markdown
**Related**:
- #38 (2025-12-08)
- #42 (2025-12-08)
- #50 (2025-12-08)
- #51 (2025-12-08)
```

**When to use**: Any issue/plan referencing other issues
**Why it works**:
- GitHub auto-links #N and shows title on hover
- Date provides timeline context
- Sorting by number makes it scannable
- No clutter from repeated titles

---

## Anti-Patterns

| Don't Do This | Do This Instead |
|---------------|-----------------|
| `#42 (2025-12-08) Auto-start Codex` | `#42 (2025-12-08)` |
| `(2025-12-08) #42` | `#42 (2025-12-08)` |
| `#42, #50, #38` (no dates) | Add dates |
| `🎯 #42 📋 #50` (emoji) | No emoji needed |
| Unsorted list | Sort by issue number |

---

## Summary

| Concept | Details |
|---------|---------|
| Format | `#N (YYYY-MM-DD)` |
| Order | Ascending by issue number |
| Titles | Never (hover shows them) |
| Emoji | Never |
| Dates | Always (YYYY-MM-DD) |

---

## Apply When

- Writing **Related** section in plan issues
- Creating GitHub issues via subagents
- Referencing issues in documentation
- Any cross-linking between issues
