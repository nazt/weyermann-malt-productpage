# CLAUDE_workflows.md - Short Codes & Context Management

> **Navigation**: [Main](CLAUDE.md) | [Safety](CLAUDE_safety.md) | **Workflows** | [Subagents](CLAUDE_subagents.md) | [Lessons](CLAUDE_lessons.md) | [Templates](CLAUDE_templates.md)

## Context & Planning Workflow (Core Pattern)
-   `ccc` - Create context issue and compact the conversation.
-   `nnn` - Smart planning: Auto-runs `ccc` if no recent context -> Create a detailed implementation plan.
-   `gogogo` - Execute the most recent plan issue step-by-step.

## Knowledge Management (3-Layer System)
-   `/snapshot [title]` - Knowledge capture -> `psi-logs/` (Layer 1: What we learned)
-   `/distill` - Extract patterns -> `psi-learnings/` (Layer 2: Reusable knowledge)
-   `rrr` - Full retrospective -> `psi-retrospectives/` (Layer 3: Narrative for book)
-   `/recap` - Fresh start context summary (tiered + scored)

---

## Why the Two-Issue Pattern?

The `ccc` -> `nnn` workflow uses a two-issue pattern:
1.  **Context Issues** (`ccc`): Preserve session state and context.
2.  **Task Issues** (`nnn`): Contain actual implementation plans.

This separation ensures a clear distinction between context dumps and actionable tasks, leading to better organization and cleaner task tracking. `nnn` intelligently checks for a recent context issue and creates one if it's missing.

---

## Core Short Codes

### `ccc` - Create Context & Compact
**Purpose**: Save the current session state and context to forward to another task.

1.  **Gather Information**: `git status --porcelain`, `git log --oneline -5`
2.  **Create GitHub Context Issue**: Use a detailed template to capture the current state, changed files, key discoveries, and next steps.
3.  **Compact Conversation**: `/compact`

### `nnn` - Next Task Planning (Analysis & Planning Only)
**Purpose**: Create a comprehensive implementation plan based on gathered context. **NO CODING** - only research, analysis, and planning.

1.  **Check for Recent Context**: If none exists, run `ccc` first.
2.  **Gather All Context**: Analyze the most recent context issue or the specified issue (`nnn #123`).
3.  **Deep Analysis**: Read context, analyze the codebase, research patterns, and identify all affected components.
4.  **Create Comprehensive Plan Issue**: Use a detailed template to outline the problem, research, proposed solution, implementation steps, risks, and success criteria.
5.  **Provide Summary**: Briefly summarize the analysis and the issue number created.

### `rrr` - Retrospective
**Purpose**: Document the session's activities, learnings, and outcomes.

**CRITICAL**: The AI Diary and Honest Feedback sections are MANDATORY. These provide essential context and continuous improvement insights. Never skip these sections.

1.  **Gather Session Data**: `git diff --name-only main...HEAD`, `git log --oneline main...HEAD`, and session timestamps.
2.  **Create Retrospective Document**: Use the template in [CLAUDE_templates.md](CLAUDE_templates.md) to create a markdown file in `psi-retrospectives/` with ALL required sections.
3.  **Validate Completeness**: Use the retrospective validation checklist to ensure no sections are skipped.
4.  **Update CLAUDE_lessons.md**: Copy any new lessons learned.
5.  **Link to GitHub**: Commit the retrospective and comment on the relevant issue/PR.

**Time Zone Note**:
-   **PRIMARY TIME ZONE: GMT+7 (Bangkok time)** - Always show GMT+7 time first
-   UTC time included for reference only (shown in parentheses)
-   File names may use UTC for technical consistency
-   In all displays and retrospectives, prioritize GMT+7 for user clarity

### `gogogo` - Execute Planned Implementation
1.  **Find Implementation Issue**: Locate the most recent `plan:` issue.
2.  **Execute Implementation**: Follow the plan step-by-step, making all necessary code changes.
3.  **Test & Verify**: Run all relevant tests and verify the implementation works.
4.  **Commit & Push**: Commit with a descriptive message, push to the feature branch, and create/update the PR.

---

## GitHub Workflow

### Creating Issues
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

### Standard Development Flow
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

# 6. CRITICAL: NEVER MERGE PRs YOURSELF
# DO NOT use: gh pr merge
# DO NOT use: Any merge commands
# ONLY provide the PR link to the user
# WAIT for explicit user instruction to merge
# The user will review and merge when ready
```

---

## Testing Discipline

### Manual Testing Checklist
Before pushing any changes:
-   [ ] Run the build command successfully.
-   [ ] Verify there are no new build warnings or type errors.
-   [ ] Test all affected pages and features.
-   [ ] Check the browser console for errors.
-   [ ] Test for mobile responsiveness if applicable.
-   [ ] Verify all interactive features work as expected.

---

**See also**: [CLAUDE_templates.md](CLAUDE_templates.md) for retrospective template, [CLAUDE_safety.md](CLAUDE_safety.md) for PR workflow rules
