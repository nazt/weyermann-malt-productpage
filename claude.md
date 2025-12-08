# CLAUDE.md - AI Assistant Quick Reference

> **Modular Documentation**: This is the lean hub. For details, see the linked files below.

## Navigation

| File | Content |
|------|---------|
| [CLAUDE_safety.md](CLAUDE_safety.md) | Critical safety rules, PR workflow, git operations |
| [CLAUDE_workflows.md](CLAUDE_workflows.md) | Short codes (ccc, nnn, rrr, gogogo), context management |
| [CLAUDE_subagents.md](CLAUDE_subagents.md) | All 9 subagent documentation |
| [CLAUDE_lessons.md](CLAUDE_lessons.md) | Lessons learned, patterns, anti-patterns |
| [CLAUDE_templates.md](CLAUDE_templates.md) | Retrospective template, commit format, issue templates |

---

## Golden Rules

1. **NEVER use `--force` flags** - No force push, force checkout, force clean
2. **NEVER push to main** - Always create feature branch + PR
3. **NEVER merge PRs** - Wait for user approval
4. **NEVER create temp files outside repo** - Use `.tmp/` directory
5. **Safety first** - Ask before destructive actions

---

## Short Codes (Quick Reference)

| Code | Purpose |
|------|---------|
| `ccc` | Create context issue + compact conversation |
| `nnn` | Create implementation plan (no coding) |
| `gogogo` | Execute the most recent plan issue |
| `rrr` | Create session retrospective |
| `/snapshot` | Quick knowledge capture |
| `/distill` | Extract patterns to learnings |
| `/recap` | Fresh start context summary |

**Details**: [CLAUDE_workflows.md](CLAUDE_workflows.md)

---

## Subagents (Quick Reference)

| Agent | Model | Purpose |
|-------|-------|---------|
| **executor** | haiku | Execute bash commands from issues |
| **coder** | opus | Create code files with quality |
| **context-finder** | haiku | Search git/issues/retrospectives |
| **marie-kondo** | - | File placement consultant |
| **maw** | - | Multi-agent workflow controller |
| **archiver** | - | Find unused items, prepare archive |
| **thai-translator** | - | EN->TH translation |
| **issues-cleanup** | - | Find stale/duplicate issues |
| **new-feature** | - | Create plan issues |

**Details**: [CLAUDE_subagents.md](CLAUDE_subagents.md)

---

## Project Context

### Overview
*(Fill out for each specific project)*

### Architecture
- **Backend**: [Framework, Language, Database]
- **Frontend**: [Framework, Language, Libraries]
- **Infrastructure**: [Hosting, CI/CD, etc.]

### Active Technologies
- HTML5, CSS3, JavaScript ES6+ + None (vanilla approach per constitution)
- products.json (static file, read-only)

---

## Quick Start

```bash
# First task
nnn           # Create implementation plan
gogogo        # Execute the plan

# After work session
rrr           # Create retrospective
```

---

## Recent Changes

- 001-product-display: Added HTML5, CSS3, JavaScript ES6+ + None (vanilla approach per constitution)
- Added thai-translator subagent for retrospective translations (issue #19)
- Added maw-orchestrator subagent for starting MAW and spawning agents (issue #22)

---

**Last Updated**: 2025-12-08
**Version**: 2.0.0 (modular structure)
