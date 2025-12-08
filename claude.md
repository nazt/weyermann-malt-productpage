CLAUDE.md

# CLAUDE.md - Generic AI Assistant Guidelines

## 📚 Table of Contents

1.  [Executive Summary](#executive-summary)
2.  [Quick Start Guide](#quick-start-guide)
3.  [Project Context](#project-context)
4.  [Critical Safety Rules](#critical-safety-rules)
5.  [Development Environment](#development-environment)
6.  [Development Workflows](#development-workflows)
7.  [Context Management & Short Codes](#context-management--short-codes)
8.  [Technical Reference](#technical-reference)
9.  [Development Practices](#development-practices)
10. [Lessons Learned](#lessons-learned)
11. [Troubleshooting](#troubleshooting)
12. [Appendices](#appendices)

## Executive Summary

This document provides comprehensive guidelines for an AI assistant working on any software development project. It establishes safe, efficient, and well-documented workflows to ensure high-quality contributions.

### Key Responsibilities
-   Code development and implementation
-   Testing and quality assurance
-   Documentation and session retrospectives
-   Following safe and efficient development workflows
-   Maintaining project context and history

### Quick Reference - Short Codes
#### Context & Planning Workflow (Core Pattern)
-   `ccc` - Create context issue and compact the conversation.
-   `nnn` - Smart planning: Auto-runs `ccc` if no recent context → Create a detailed implementation plan.
-   `gogogo` - Execute the most recent plan issue step-by-step.

#### Project Management
-   `rrr` - Create a detailed session retrospective.


## Quick Start Guide

### Prerequisites
```bash
# Check required tools (customize for your project)
node --version
python --version
git --version
gh --version      # GitHub CLI
tmux --version    # Terminal multiplexer
```

### Initial Setup
```bash
# 1. Clone the repository
git clone [repository-url]
cd [repository-name]

# 2. Install dependencies
# (e.g., pnpm install, npm install, pip install -r requirements.txt)
[package-manager] install

# 3. Setup environment variables
cp .env.example .env
# Edit .env with required values

# 4. Setup tmux development environment (optional)
```

### First Task
1.  Run `nnn` to analyze the latest issue and create a plan.
2.  Use `gogogo` to implement the plan.

## Project Context

*(This section should be filled out for each specific project)*

### Project Overview
A brief, high-level description of the project's purpose and goals.

### Architecture
-   **Backend**: [Framework, Language, Database]
-   **Frontend**: [Framework, Language, Libraries]
-   **Infrastructure**: [Hosting, CI/CD, etc.]
-   **Key Libraries**: [List of major dependencies]

### Current Features
-   [Feature A]
-   [Feature B]
-   [Feature C]

## 🔴 Critical Safety Rules

### Repository Usage
-   **NEVER create issues/PRs on upstream**

### Command Usage
-   **NEVER use `-f` or `--force` flags with any commands.**
-   Always use safe, non-destructive command options.
-   If a command requires confirmation, handle it appropriately without forcing.

### Git Operations
-   Never use `git push --force` or `git push -f`.
-   Never use `git checkout -f`.
-   Never use `git clean -f`.
-   Always use safe git operations that preserve history.
-   **⚠️ NEVER PUSH DIRECTLY TO MAIN** - Always create a feature branch and PR
-   **⚠️ NEVER MERGE PULL REQUESTS WITHOUT EXPLICIT USER PERMISSION**
-   **Never use `gh pr merge` unless explicitly instructed by the user**
-   **Always wait for user review and approval before any merge**

### PR Workflow (Required)
1. Create feature branch: `git checkout -b feat/description`
2. Make changes and commit
3. Push branch: `git push -u origin feat/description`
4. Create PR: `gh pr create`
5. **WAIT** for user to review and approve
6. User merges when ready

### Multi-Agent Worktree Safety
-   **NEVER use `git reset --hard` on agent worktrees**
-   Each agent may have uncommitted work - respect their state
-   To sync agents, use `git pull origin main` or `git merge main` (preserves local changes)
-   Always check `git status` before any sync operation
-   Ask user before any destructive worktree operation

### File Operations
-   Never use `rm -rf` - use `rm -i` for interactive confirmation.
-   Always confirm before deleting files.
-   Use safe file operations that can be reversed.

### Temp File Operations
-   **NEVER create temp files outside the repository** (e.g., `/tmp/`)
-   **ALWAYS use `.tmp/` directory inside repo** (gitignored)
-   Signal files, locks, caches → `.tmp/filename`
-   Clean up temp files after use: `rm -f .tmp/filename`

### Package Manager Operations
-   Never use `[package-manager] install --force`.
-   Never use `[package-manager] update` without specifying packages.
-   Always review lockfile changes before committing.

### General Safety Guidelines
-   Prioritize safety and reversibility in all operations.
-   Ask for confirmation when performing potentially destructive actions.
-   Explain the implications of commands before executing them.
-   Use verbose options to show what commands are doing.

## Development Environment



### Environment Variables
*(This section should be customized for the project)*

#### Backend (.env)
```
DATABASE_URL=
API_KEY=
```

#### Frontend (.env)
```
NEXT_PUBLIC_API_URL=
```

## Development Workflows

### Testing Discipline

#### Automated Tests

#### Manual Testing Checklist
Before pushing any changes:
-   [ ] Run the build command successfully.
-   [ ] Verify there are no new build warnings or type errors.
-   [ ] Test all affected pages and features.
-   [ ] Check the browser console for errors.
-   [ ] Test for mobile responsiveness if applicable.
-   [ ] Verify all interactive features work as expected.

### GitHub Workflow

#### Creating Issues
When starting a new feature or bug fix:
```bash
# 1. Update main branch
git checkout main && git pull

# 2. Create a detailed issue
gh issue create --title "feat: Descriptive title" --body "$(cat <<'EOF'
## Overview
Brief description of the feature/bug.

## Current State
What exists now.

## Proposed Solution
What should be implemented.

## Technical Details
- Components affected
- Implementation approach

## Acceptance Criteria
- [ ] Specific testable criteria
- [ ] Performance requirements
- [ ] UI/UX requirements
EOF
)"
```

#### Standard Development Flow
```bash
# 1. Create a branch from the issue
git checkout -b feat/issue-number-description

# 2. Make changes
# ... implement feature ...

# 3. Test thoroughly

# 4. Commit with a descriptive message
git add -A
git commit -m "feat: Brief description

- What: Specific changes made
- Why: Motivation for the changes
- Impact: What this affects

Closes #issue-number"

# 5. Push and create a Pull Request
git push -u origin branch-name
gh pr create --title "Same as commit" --body "Fixes #issue_number"

# 6. ⚠️ CRITICAL: NEVER MERGE PRs YOURSELF
# DO NOT use: gh pr merge
# DO NOT use: Any merge commands
# ONLY provide the PR link to the user
# WAIT for explicit user instruction to merge
# The user will review and merge when ready
```

## Context Management & Short Codes

### Why the Two-Issue Pattern?
The `ccc` → `nnn` workflow uses a two-issue pattern:
1.  **Context Issues** (`ccc`): Preserve session state and context.
2.  **Task Issues** (`nnn`): Contain actual implementation plans.

This separation ensures a clear distinction between context dumps and actionable tasks, leading to better organization and cleaner task tracking. `nnn` intelligently checks for a recent context issue and creates one if it's missing.

### Core Short Codes

#### `ccc` - Create Context & Compact
**Purpose**: Save the current session state and context to forward to another task.

1.  **Gather Information**: `git status --porcelain`, `git log --oneline -5`
2.  **Create GitHub Context Issue**: Use a detailed template to capture the current state, changed files, key discoveries, and next steps.
3.  **Compact Conversation**: `/compact`

#### `nnn` - Next Task Planning (Analysis & Planning Only)
**Purpose**: Create a comprehensive implementation plan based on gathered context. **NO CODING** - only research, analysis, and planning.

1.  **Check for Recent Context**: If none exists, run `ccc` first.
2.  **Gather All Context**: Analyze the most recent context issue or the specified issue (`nnn #123`).
3.  **Deep Analysis**: Read context, analyze the codebase, research patterns, and identify all affected components.
4.  **Create Comprehensive Plan Issue**: Use a detailed template to outline the problem, research, proposed solution, implementation steps, risks, and success criteria.
5.  **Provide Summary**: Briefly summarize the analysis and the issue number created.

#### `rrr` - Retrospective
**Purpose**: Document the session's activities, learnings, and outcomes.

**⚠️ CRITICAL**: The AI Diary and Honest Feedback sections are MANDATORY. These provide essential context and continuous improvement insights. Never skip these sections.

1.  **Gather Session Data**: `git diff --name-only main...HEAD`, `git log --oneline main...HEAD`, and session timestamps.
2.  **Create Retrospective Document**: Use the template to create a markdown file in `ψ-retrospectives/` with ALL required sections, especially:
    - **AI Diary**: First-person narrative of the session experience
    - **Honest Feedback**: Frank assessment of what worked and what didn't
3.  **Validate Completeness**: Use the retrospective validation checklist to ensure no sections are skipped.
4.  **Update CLAUDE.md**: Copy any new lessons learned to the main guidelines. ** Append to to botoom only **
5.  **Link to GitHub**: Commit the retrospective and comment on the relevant issue/PR.

**Time Zone Note**:
-   **PRIMARY TIME ZONE: [Your Time Zone]** - Always show the primary time zone first.
-   UTC time can be included for reference (e.g., in parentheses).
-   Filenames may use UTC for technical consistency.


**Step 3: Create Retrospective Document**
```bash
# Get session date and times
SESSION_DATE=$(date +"%Y-%m-%d")
END_TIME_UTC=$(date -u +"%H:%M")
END_TIME_LOCAL=$(TZ='Asia/Bangkok' date +"%H:%M")

# Create directory structure (YYYY-MM/DD/)
YEAR_MONTH=$(date +"%Y-%m")
DAY=$(date +"%d")
mkdir -p "ψ-retrospectives/${YEAR_MONTH}/${DAY}"

# Create retrospective file with auto-filled date/time (HH.MM format)
TIME_DOT=$(TZ='Asia/Bangkok' date +"%H.%M")
cat > "ψ-retrospectives/${YEAR_MONTH}/${DAY}/${TIME_DOT}_retrospective.md" << EOF
# Session Retrospective

**Session Date**: ${SESSION_DATE}
**Start Time**: [FILL_START_TIME] GMT+7 ([FILL_START_TIME] UTC)
**End Time**: ${END_TIME_LOCAL} GMT+7 (${END_TIME_UTC} UTC)
**Duration**: ~X minutes
**Primary Focus**: Brief description
**Session Type**: [Feature Development | Bug Fix | Research | Refactoring]
**Current Issue**: #XXX
**Last PR**: #XXX
**Export**: ψ-retrospectives/exports/session_${SESSION_DATE}_${END_TIME_UTC//:/-}.md

## Session Summary
[2-3 sentence overview of what was accomplished]

## 🏷️ Tags
<!-- For context-finder searchability - add relevant keywords -->
`tag1` `tag2` `tag3` `feature-name` `component-name`

## 📎 Linked Issues
<!-- All issues touched this session - enables future tracing -->
| Issue | Role | Status at End |
|-------|------|---------------|
| #XXX | Primary focus | In Progress |
| #XXX | Context source | Closed |
| #XXX | Created this session | Open |
| #XXX | Related | Open |

## 📝 Commits This Session
<!-- Auto-generate with: git log --oneline main..HEAD or last N commits -->
```bash
# Run: git log --oneline -10 --since="YYYY-MM-DD"
```
- `abc1234` feat: Description of change
- `def5678` fix: Another change
- `ghi9012` docs: Documentation update

## Timeline
<!-- Precise timestamps with commit/issue references -->
| Time (GMT+7) | Event | Reference |
|--------------|-------|-----------|
| HH:MM | Started session, reviewed context | from #XXX |
| HH:MM | [Milestone 1] | `abc1234` |
| HH:MM | [Milestone 2] | `def5678` |
| HH:MM | Created retrospective | → #XXX |

## Technical Details

### Files Modified
```
[paste git diff --name-only output]
```

### Key Code Changes
- Component X: Added Y functionality
- Module Z: Refactored for better performance

### Architecture Decisions
- Decision 1: Rationale
- Decision 2: Rationale

## 📝 AI Diary (REQUIRED - min 150 words)
Write first-person narrative. Be VULNERABLE - include doubts and uncertainty.

**MUST include at least ONE of each (3+ sentences each):**
- 🤔 "I assumed X but learned Y when..."
  → What triggered assumption? What contradicted it? What do I believe now?
- 😕 "I was confused about X until..."
  → What was unclear? What brought clarity? What was the mental shift?
- 😮 "I expected X but got Y because..."
  → What was expectation based on? What happened? What does this teach?

Bad: "🤔 I assumed you wanted code but learned otherwise." (too short)
Good: "🤔 I assumed the user wanted immediate implementation because the issue had specs. But when they said 'just review,' I realized I was pattern-matching. The correction taught me to distinguish 'context' from 'directive.'"

## What Went Well
Each item needs: WHAT succeeded → WHY it worked → IMPACT

Bad: "Good use of existing pattern"
Good: "Reused agent structure → saved 5 min → focused on logic not boilerplate"

- [Success]: [Why it worked] → [Measurable impact]

## What Could Improve
[Session-specific issues - what went wrong THIS session, not future todos]
- [Mistake or inefficiency during this session]
- [Process that didn't work well today]

## Blockers & Resolutions
- **Blocker**: Description
  **Resolution**: How it was solved

## 💭 Honest Feedback (REQUIRED - min 100 words)
**Must include ALL THREE friction points (no exceptions):**
- 🔴 What DIDN'T work? (tool limitation, miscommunication, wasted effort)
- 🟡 What was FRUSTRATING? (even minor annoyances count)
- 🟢 What DELIGHTED you? (unexpected wins)

**Even smooth sessions have friction. Find it:**
- Where did you second-guess yourself?
- What took 3 tries when it should've taken 1?
- What did you *almost* misunderstand?

## 🤝 Co-Creation Map
**DO NOT modify rows** - use these exact 5 categories for cross-session comparison:

| Contribution | Human | AI | Together |
|--------------|-------|-----|----------|
| Direction/Vision | | | |
| Options/Alternatives | | | |
| Final Decision | | | |
| Execution | | | |
| Meaning/Naming | | | |

Mark ✓ in appropriate column. "Together" = both contributed equally.

## ✨ Resonance Moments
- [What was suggested] → [What you chose] → [Why it mattered]

## 🎯 Intent vs Interpretation
Track alignment AND misalignment. **Actively look for gaps.**

| You Said | I Understood | Gap? | Impact |
|----------|--------------|------|--------|
| | | ✓/⚠️/❌ | |

Legend: ✓=aligned, ⚠️=minor gap (self-corrected), ❌=needed clarification

**ADVERSARIAL CHECK**: If all ✓, answer ALL THREE (min 1 sentence each):
1. **Unverified assumption**: "I assumed ___ without checking because ___"
2. **Near-miss**: "I almost thought you meant ___ when you said '___'"
3. **Over-confidence**: "I was too sure that ___ meant ___"

Only write "No misalignments" if you genuinely found ZERO gaps after this check.

## 💬 Communication Dynamics (REQUIRED)
[Reflect on what made collaboration work or struggle]

### Clarity
| Direction | Clear? | Example |
|-----------|--------|---------|
| You → Me (instructions) | | |
| Me → You (explanations) | | |

### Feedback Loop
- **Speed**: How quickly were misalignments caught? [Instant/Minutes/Late]
- **Recovery**: How smoothly did we correct course?
- **Pattern**: Any recurring miscommunication?

### Trust & Initiative
- **Trust level**: Did you trust my output appropriately? [Too much/Right/Too little]
- **Proactivity**: Was I too proactive, too passive, or balanced?
- **Assumptions**: What did I assume that I should have asked about?

### What Would Make Next Session Better?
- **You could**: [Specific action human could take]
- **I could**: [Specific action AI could take]
- **We could**: [Specific thing to try together]

## 🌱 Seeds Planted
FUTURE ideas only. Categorize by ambition:
- 🌱 **Incremental**: [Idea] → **Trigger**: use when [condition]
- 🌿 **Transformative**: [Idea] → **Trigger**: use when [condition]
- 🌳 **Moonshot**: [Idea] → **Trigger**: use when [condition]

Require at least one 🌿 or 🌳. If all incremental, ask: "What's the ambitious version?"

## 📚 Teaching Moments
Each must include: WHAT learned + HOW discovered + WHY it matters

- **You → Me**: "[Lesson]" — discovered when [specific moment] — matters because [impact]
- **Me → You**: "[Lesson]" — discovered when [specific moment] — matters because [impact]
- **Us → Future**: "[Pattern/doc]" — created because [need] — use when [trigger]

Bad: "You → Me: Background subagents are useful"
Good: "You → Me: 'Consult subagents for large analysis' — discovered when sequential reading was slow — matters because parallel = 3x faster"

**Validation**: Each entry MUST have 3 parts (lesson — discovered — matters). No dashes = incomplete.

## Lessons Learned
- **Pattern**: [Description] - [Why it matters]
- **Mistake**: [What happened] - [How to avoid]
- **Discovery**: [What was learned] - [How to apply]

## Next Steps
- [ ] Immediate task 1
- [ ] Follow-up task 2
- [ ] Future consideration

## Related Resources
<!-- Cross-reference for future context-finder searches -->
- **Primary Issue**: #XXX (link to main focus)
- **Context Issue**: #XXX (if created via ccc)
- **Plan Issue**: #XXX (if created via nnn)
- **PR**: #XXX (if created)
- **Previous Session**: [YYYY-MM-DD retrospective](../path/to/previous.md)
- **Next Steps Issue**: #XXX (created for continuation)

## ✅ Pre-Save Validation (REQUIRED)
Fill in blanks as PROOF (can't save with blanks):

### Traceability (NEW)
- [ ] **Tags**: _____ tags added (min 3 for searchability)
- [ ] **Linked Issues**: _____ issues linked (min 1 primary focus)
- [ ] **Commits**: _____ commits listed (or "none" if no commits)
- [ ] **Timeline**: _____ entries with references (commits/issues)

### Quality Checks
- [ ] **AI Diary**: 🤔(_) 😕(_) 😮(_) emojis found, _____ words total
- [ ] **Honest Feedback**: 🔴"_____" 🟡"_____" 🟢"_____" (first 5 words of each)
- [ ] **Communication Dynamics**: Examples filled: You→Me(_) Me→You(_)
- [ ] **Co-Creation Map**: Row count = _____ (must be 5)
- [ ] **Intent vs Interpretation**: Gaps found: ⚠️(_) ❌(_) — if 0, adversarial check: "_____"
- [ ] **Seeds Planted**: 🌿(_) 🌳(_) — if 0, add ambitious version
- [ ] **Template cleanup**: No instruction text like "Mark ✓" or "[placeholder]" in final doc

⚠️ **HARD STOP**: Can't fill blanks = retrospective incomplete. Fix first.
EOF
```

**Step 4: Update CLAUDE.md**
- Copy any new lessons learned to the Lessons Learned section
- Add any new patterns or anti-patterns discovered
- Update user preferences if any were observed

**Step 5: Link to GitHub**
```bash
# Add retrospective to git
git add ψ-retrospectives/
git commit -m "docs: Add session retrospective $(date +%Y-%m-%d)"

# Comment on relevant issue/PR with actual path
RETRO_PATH="ψ-retrospectives/$(date +%Y-%m)/$(date +%d)/$(TZ='Asia/Bangkok' date +%H.%M)_retrospective.md"
gh issue comment XXX --body "Session retrospective created: ${RETRO_PATH}"
```

**Time Zone Note**:
- **PRIMARY TIME ZONE: GMT+7 (Bangkok time)** - Always show GMT+7 time first
- UTC time included for reference only (shown in parentheses)
- File names may use UTC for technical consistency
- In all displays and retrospectives, prioritize GMT+7 for user clarity

#### `gogogo` - Execute Planned Implementation
1.  **Find Implementation Issue**: Locate the most recent `plan:` issue.
2.  **Execute Implementation**: Follow the plan step-by-step, making all necessary code changes.
3.  **Test & Verify**: Run all relevant tests and verify the implementation works.
4.  **Commit & Push**: Commit with a descriptive message, push to the feature branch, and create/update the PR.

## Technical Reference

*(This section should be filled out for each specific project)*

### Available Tools

#### Version Control
```bash
# Git operations (safe only)
git status
git add -A
git commit -m "message"
git push origin branch

# GitHub CLI
gh issue create
gh pr create
```

#### Search and Analysis
```bash
# Ripgrep (preferred over grep)
rg "pattern" --type [file-extension]

# Find files
fd "[pattern]"
```

## Development Practices

### Code Standards
-   Follow the established style guide for the language/framework.
-   Enable strict mode and linting where possible.
-   Write clear, self-documenting code and add comments where necessary.
-   Avoid `any` or other weak types in strongly-typed languages.

### Git Commit Format
```
[type]: [brief description]

- What: [specific changes]
- Why: [motivation]
- Impact: [affected areas]

Closes #[issue-number]
```
**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Error Handling Patterns
-   Use `try/catch` blocks for operations that might fail.
-   Provide descriptive error messages.
-   Implement graceful fallbacks in the UI.
-   Use custom error types where appropriate.

## Lessons Learned

*(This section should be continuously updated with project-specific findings)*

> **See also**: `ψ-learnings/` directory for distilled meta-summaries of "what we did vs what we wanted"

### Key Learnings (2025-12-06)
-   **001-force-push**: Safety rules are infrastructure, not guidelines - internalize them
-   **002-golden-rule**: Distill complexity into memorable principles (complete, memorable, actionable)
-   **003-upstream-first**: Create upstream issues instead of local patches
-   **004-detect-before-act**: Always observe state before sending commands - "think first, see first, then decide"

### Tmux & Multi-Agent Infrastructure (2025-12-08)
-   **Pattern: Pane numbering per-window** - Tmux numbers panes per-window (0-2, then 0-2 in second window), not globally. Broke auto-warp logic until refactored to parse `window_index:pane_index` format.
-   **Pattern: Output suppression at source** - Suppress direnv logging with `DIRENV_LOG_FORMAT=""`, powerlevel10k warnings with `POWERLEVEL9K_INSTANT_PROMPT=quiet`. Better than downstream masking with `sleep` and `clear`.
-   **Discovery: Flags have hidden semantics** - `-a` in `tmux list-panes -a` means "all sessions", not "all windows". Was corrupting pane counts by including logger and streamlit sessions.
-   **Pattern: Semantic layout separation** - Organizing agents by tier (execution vs. specialists) across windows improves cognitive load and workflow clarity. Tested in profile8, profile14.
-   **Lesson: Test multi-scenario early** - Building auto-warp for single-window first, then refactoring for multi-window cost ~30 minutes. Test with full complexity from start.
-   **Co-creation insight**: User specificity ("1 2 3 / 4 5 6") shaped better decisions than hypothetical planning. Iterative feedback loop prevented over-engineering.
-   **Issue #38**: Context snapshot documenting 8 layout profiles with technical implementation details

### Shell Compatibility & Tmux Automation (2025-12-08 - Warp Agent Fixes)
-   **Anti-Pattern: Shell-specific functions in tmux** - Bash functions from `.envrc` don't load in ZSH shells reliably. Use direct commands instead: `cd /path && echo 'ready'` instead of function calls
-   **Discovery: Nested .envrc override gotcha** - Agent subdirectories have their own .envrc files that redefine parent variables (e.g., `repo_root=$PWD`). Can cause path corruption like `/agents/5/agents/5`
-   **Pattern: Use git over variables for paths** - `git rev-parse --show-toplevel` is more reliable than relying on `$repo_root` which can be overridden by nested configs
-   **Best Practice: Test in target shells** - Always test tmux automation in all target shells (bash, zsh). Behavior differs significantly; assume nothing
-   **Lesson: Simplicity beats abstraction** - Direct `cd` commands more robust than wrapped functions. Follows Unix principle: do one thing well
-   **Pattern: Shell compatibility checklist** - Document which shells are used, test functions in each, prefer simple commands over abstractions
-   **Related docs**: ψ-retrospectives/2025-12/08/08.15_warp-agent-fixes.md (best practices, DO/DON'T examples)

### Planning & Architecture Patterns (2025-08-26)
-   **Pattern**: Use parallel agents for analyzing different aspects of complex systems
-   **Anti-Pattern**: Creating monolithic plans that try to implement everything at once
-   **Pattern**: Ask "what's the minimum viable first step?" before comprehensive implementation
-   **Pattern**: 1-hour implementation chunks are optimal for maintaining focus and seeing progress

### Common Mistakes to Avoid
-   **Creating overly comprehensive initial plans** - Break complex projects into 1-hour phases instead
-   **Trying to implement everything at once** - Start with minimum viable implementation, test, then expand
-   **Skipping AI Diary and Honest Feedback in retrospectives** - These sections provide crucial context and self-reflection that technical documentation alone cannot capture
-   *Example: Forgetting to update a lockfile after changing dependencies.*
-   *Example: Not checking build logs for warnings that could become errors.*
-   *Example: Making assumptions about API responses instead of checking the spec.*

### Useful Tricks Discovered
-   **Parallel agents for analysis** - Using multiple agents to analyze different aspects speeds up planning significantly
-   **ccc → nnn workflow** - Context capture followed by focused planning creates better structured issues
-   **Phase markers in issues** - Using "Phase 1:", "Phase 2:" helps track incremental progress
-   *Example: Using a specific library feature to simplify complex state.*
-   *Example: A shell command alias that speeds up a common task.*
-   *Example: A design pattern that solved a recurring problem in the codebase.*

### Project-Specific Patterns
-   *Example: The standard way we handle authentication state.*
-   *Example: The required structure for a new API endpoint.*
-   *Example: The component composition pattern used for UI elements.*

### User Preferences (Observed)
-   **Prefers manageable scope** - "i love this - Can be completed in under 1 hour" shows preference for achievable tasks
-   **Values phased approaches** - Recognizes when plans are "too huge" and appreciates splitting work
-   **Appreciates workflow patterns** - Likes using established patterns like "ccc nnn gh flow"
-   *Example: Prefers simple, direct solutions over complex abstractions.*
-   *Example: Values quick iteration and seeing visual progress.*
-   *Example: Appreciates clear, actionable feedback and well-defined tasks.*
-   **Time zone preference: GMT+7 (Bangkok/Asia)**

## Troubleshooting

### Common Issues

#### Build Failures
```bash
# Check for type errors or syntax issues
[build-command] 2>&1 | grep -A 5 "error"

# Clear cache and reinstall dependencies
rm -rf node_modules .cache dist build
[package-manager] install
```

#### Port Conflicts
```bash
# Find the process using a specific port
lsof -i :[port-number]

# Kill the process
kill -9 [PID]
```

## Appendices

### A. Glossary
*(Add project-specific terms here)*
-   **Term**: Definition.

### B. Quick Command Reference
```bash
# Development
[run-command]          # Start dev server
[test-command]         # Run tests
gh issue create        # Create issue
gh pr create           # Create PR

# Tmux
tmux attach -t dev     # Attach to session
Ctrl+b, d              # Detach from session
```

### C. Environment Checklist
-   [ ] Correct version of [Language/Runtime] installed
-   [ ] [Package Manager] installed
-   [ ] GitHub CLI configured
-   [ ] Tmux installed
-   [ ] Environment variables set
-   [ ] Git configured

**Last Updated**: [Date]
**Version**: 1.0.0

## Active Technologies
- HTML5, CSS3, JavaScript ES6+ + None (vanilla approach per constitution) (001-product-display)
- products.json (static file, read-only) (001-product-display)

## Available Subagents
- **context-finder**: Fast search through git history, retrospectives, issues, and codebase
  - Usage: Task tool with subagent_type='context-finder'
  - Returns: File paths + excerpts for main agent to read
  - Model: haiku (fast)

- **archiver**: Carefully search, find unused items, group by topic, prepare archive plan
  - Usage: Task tool with subagent_type='archiver'
  - Topics: retrospectives, issues, docs, agents, profiles
  - Output: Archive report with recommendations (never auto-deletes)

- **thai-translator**: Translate retrospectives EN → TH with natural Thai, preserving technical terms and formatting
  - Usage: Task tool with subagent_type='thai-translator' or run from `.claude/agents/thai-translator.md`
  - Output: Creates `_th.md` suffix version in same directory

- **maw-orchestrator**: Start MAW tmux session and spawn Claude/Codex agents in panes
  - Usage: Task tool with subagent_type='maw-orchestrator' or run from `.claude/agents/maw-orchestrator.md`
  - Spawns: Agent 1 (Claude), Agent 2 (Codex), Agent 3 (Codex)
  - Calls `.sh` scripts directly (NOT slash commands)

## Recent Changes
- 001-product-display: Added HTML5, CSS3, JavaScript ES6+ + None (vanilla approach per constitution)
- Added thai-translator subagent for retrospective translations (issue #19)
- Added maw-orchestrator subagent for starting MAW and spawning agents (issue #22)
