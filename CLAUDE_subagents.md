# CLAUDE_subagents.md - Available Subagents

> **Navigation**: [Main](CLAUDE.md) | [Safety](CLAUDE_safety.md) | [Workflows](CLAUDE_workflows.md) | **Subagents** | [Lessons](CLAUDE_lessons.md) | [Templates](CLAUDE_templates.md)

## Overview

Subagents are specialized AI assistants that can be invoked for specific tasks. Each has a defined purpose, model, and output format.

---

## marie-kondo
**Lean file placement consultant - ASK BEFORE creating files!**

- **Usage**: Task tool with subagent_type='marie-kondo'
- **MUST consult before**: Creating any new file, especially in root
- **Philosophy**: "Does this file spark joy? Does it have a home?"
- **Output**: Verdict (APPROVED / REJECTED / REDIRECT) + recommended path

---

## executor
**Execute plans from GitHub issues (simple tasks)**

- **Usage**: Task tool with subagent_type='executor' with prompt "Execute issue #70"
- **Model**: **haiku** (fast) - for delete, move, git commands
- **Behavior**: Reads bash blocks from issue, runs commands sequentially
- **Safety**: Whitelist commands, blocks rm -rf/--force/sudo

---

## coder
**Create code files from GitHub issue specs**

- **Usage**: Task tool with subagent_type='coder' with prompt "Implement issue #73"
- **Model**: **opus** (quality) - for creating new code
- **Behavior**: Writes files, follows repo patterns, documents decisions
- **Use when**: Quality > speed

---

## context-finder
**Fast search through git history, retrospectives, issues, and codebase**

- **Usage**: Task tool with subagent_type='context-finder'
- **Returns**: File paths + excerpts for main agent to read
- **Model**: haiku (fast)

---

## archiver
**Carefully search, find unused items, group by topic, prepare archive plan**

- **Usage**: Task tool with subagent_type='archiver'
- **Topics**: retrospectives, issues, docs, agents, profiles
- **Output**: Archive report with recommendations (never auto-deletes)

---

## maw
**Unified Multi-Agent Workflow controller**

- **Usage**: Task tool with subagent_type='maw' with prompt "maw start|status|send|stop"
- **Commands**: start (spawn agents), status (monitor), send (communicate), stop (cleanup)
- **Output**: Unified interface for all MAW operations

---

## thai-translator
**Translate retrospectives EN -> TH with natural Thai**

- **Usage**: Task tool with subagent_type='thai-translator' or run from `.claude/agents/thai-translator.md`
- **Behavior**: Preserves technical terms and formatting
- **Output**: Creates `_th.md` suffix version in same directory

---

## issues-cleanup
**Analyze GitHub issues, find stale/duplicate/orphaned, create cleanup plan**

- **Usage**: Task tool with subagent_type='issues-cleanup'
- **Finds**: duplicates, test issues, stale closed, completed plans
- **Output**: Cleanup plan issue (never auto-closes)

---

## new-feature
**Create implementation plan issues with context gathering**

- **Usage**: Task tool with subagent_type='new-feature'
- **Format**: `#N (YYYY-MM-DD)` sorted by issue number
- **Output**: GitHub plan issue with related context

---

**See also**: [CLAUDE.md](CLAUDE.md) for quick reference, [CLAUDE_workflows.md](CLAUDE_workflows.md) for how subagents fit into workflows
