# The Golden Rule

**Date**: 2025-12-01
**Source**: docs/maw/SYNC-RULES.md, narrative-maw-notifications.md

## Intent
Create memorable, actionable safety guidelines for multi-agent coordination.

## Outcome
Distilled 450 lines of documentation into four principles that fit in working memory:

> **"Know who you are, sync from the right source, never force anything, respect all boundaries."**

## Gap Analysis
No gap—intent matched outcome. The Golden Rule emerged as a natural distillation after the force-push incident created urgency for clear, memorable safety guidance.

## Key Learning
**Complex safety rules become effective when distilled into memorable principles. The best rules are complete (cover all cases), memorable (fit in working memory), and actionable (tell you exactly what to check).**

## The Four Principles

| Principle | Meaning | Check |
|-----------|---------|-------|
| Know who you are | Agent identity awareness | `pwd`, `git branch --show-current` |
| Sync from the right source | Hierarchy awareness | Main → origin, Agents → local main |
| Never force anything | No `-f` flags ever | Review all commands for force flags |
| Respect all boundaries | Stay in your worktree | Use `git -C`, tmux commands |

## Applied In
- SYNC-RULES.md header
- MAW-AGENTS.md guidelines
- Every sync operation checklist
- Agent hook notifications

## User Feedback
> "i love the Golden Rule"

The simplicity resonated. Everything else in the documentation expands on these four foundations.
