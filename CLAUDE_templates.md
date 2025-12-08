# CLAUDE_templates.md - Templates & Formats

> **Navigation**: [Main](CLAUDE.md) | [Safety](CLAUDE_safety.md) | [Workflows](CLAUDE_workflows.md) | [Subagents](CLAUDE_subagents.md) | [Lessons](CLAUDE_lessons.md) | **Templates**

---

## Git Commit Format

```
[type]: [brief description]

- What: [specific changes]
- Why: [motivation]
- Impact: [affected areas]

Closes #[issue-number]
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

---

## Issue Creation Template

```bash
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

---

## Retrospective Template

Use this template when running `rrr` to create retrospective documents in `psi-retrospectives/`:

```bash
# Get session date and times
SESSION_DATE=$(date +"%Y-%m-%d")
END_TIME_UTC=$(date -u +"%H:%M")
END_TIME_LOCAL=$(TZ='Asia/Bangkok' date +"%H:%M")

# Create directory structure (YYYY-MM/DD/)
YEAR_MONTH=$(date +"%Y-%m")
DAY=$(date +"%d")
mkdir -p "psi-retrospectives/${YEAR_MONTH}/${DAY}"

# Create retrospective file with auto-filled date/time (HH.MM format)
TIME_DOT=$(TZ='Asia/Bangkok' date +"%H.%M")
```

### Retrospective Document Structure

```markdown
# Session Retrospective

**Session Date**: ${SESSION_DATE}
**Start Time**: [FILL_START_TIME] GMT+7 ([FILL_START_TIME] UTC)
**End Time**: ${END_TIME_LOCAL} GMT+7 (${END_TIME_UTC} UTC)
**Duration**: ~X minutes
**Primary Focus**: Brief description
**Session Type**: [Feature Development | Bug Fix | Research | Refactoring]
**Current Issue**: #XXX
**Last PR**: #XXX

## Session Summary
[2-3 sentence overview of what was accomplished]

## Tags
<!-- For context-finder searchability - add relevant keywords -->
`tag1` `tag2` `tag3` `feature-name` `component-name`

## Linked Issues
<!-- All issues touched this session - enables future tracing -->
| Issue | Role | Status at End |
|-------|------|---------------|
| #XXX | Primary focus | In Progress |
| #XXX | Context source | Closed |
| #XXX | Created this session | Open |
| #XXX | Related | Open |

## Commits This Session
<!-- Auto-generate with: git log --oneline main..HEAD or last N commits -->
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
| HH:MM | Created retrospective | -> #XXX |

## Technical Details

### Files Modified
[paste git diff --name-only output]

### Key Code Changes
- Component X: Added Y functionality
- Module Z: Refactored for better performance

### Architecture Decisions
- Decision 1: Rationale
- Decision 2: Rationale

## AI Diary (REQUIRED - min 150 words)
Write first-person narrative. Be VULNERABLE - include doubts and uncertainty.

**MUST include at least ONE of each (3+ sentences each):**
- "I assumed X but learned Y when..."
  -> What triggered assumption? What contradicted it? What do I believe now?
- "I was confused about X until..."
  -> What was unclear? What brought clarity? What was the mental shift?
- "I expected X but got Y because..."
  -> What was expectation based on? What happened? What does this teach?

## What Went Well
Each item needs: WHAT succeeded -> WHY it worked -> IMPACT

- [Success]: [Why it worked] -> [Measurable impact]

## What Could Improve
[Session-specific issues - what went wrong THIS session, not future todos]
- [Mistake or inefficiency during this session]
- [Process that didn't work well today]

## Blockers & Resolutions
- **Blocker**: Description
  **Resolution**: How it was solved

## Honest Feedback (REQUIRED - min 100 words)
**Must include ALL THREE friction points (no exceptions):**
- What DIDN'T work? (tool limitation, miscommunication, wasted effort)
- What was FRUSTRATING? (even minor annoyances count)
- What DELIGHTED you? (unexpected wins)

## Co-Creation Map
**DO NOT modify rows** - use these exact 5 categories for cross-session comparison:

| Contribution | Human | AI | Together |
|--------------|-------|-----|----------|
| Direction/Vision | | | |
| Options/Alternatives | | | |
| Final Decision | | | |
| Execution | | | |
| Meaning/Naming | | | |

## Resonance Moments
- [What was suggested] -> [What you chose] -> [Why it mattered]

## Intent vs Interpretation
Track alignment AND misalignment. **Actively look for gaps.**

| You Said | I Understood | Gap? | Impact |
|----------|--------------|------|--------|
| | | Y/N | |

**ADVERSARIAL CHECK**: If all aligned, answer ALL THREE (min 1 sentence each):
1. **Unverified assumption**: "I assumed ___ without checking because ___"
2. **Near-miss**: "I almost thought you meant ___ when you said '___'"
3. **Over-confidence**: "I was too sure that ___ meant ___"

## Communication Dynamics (REQUIRED)
[Reflect on what made collaboration work or struggle]

### Clarity
| Direction | Clear? | Example |
|-----------|--------|---------|
| You -> Me (instructions) | | |
| Me -> You (explanations) | | |

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

## Seeds Planted
FUTURE ideas only. Categorize by ambition:
- **Incremental**: [Idea] -> **Trigger**: use when [condition]
- **Transformative**: [Idea] -> **Trigger**: use when [condition]
- **Moonshot**: [Idea] -> **Trigger**: use when [condition]

## Teaching Moments
Each must include: WHAT learned + HOW discovered + WHY it matters

- **You -> Me**: "[Lesson]" -- discovered when [specific moment] -- matters because [impact]
- **Me -> You**: "[Lesson]" -- discovered when [specific moment] -- matters because [impact]
- **Us -> Future**: "[Pattern/doc]" -- created because [need] -- use when [trigger]

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

## Pre-Save Validation (REQUIRED)
Fill in blanks as PROOF (can't save with blanks):

### Traceability
- [ ] **Tags**: _____ tags added (min 3 for searchability)
- [ ] **Linked Issues**: _____ issues linked (min 1 primary focus)
- [ ] **Commits**: _____ commits listed (or "none" if no commits)
- [ ] **Timeline**: _____ entries with references (commits/issues)

### Quality Checks
- [ ] **AI Diary**: Required sections found, _____ words total
- [ ] **Honest Feedback**: All three friction points addressed
- [ ] **Communication Dynamics**: Examples filled
- [ ] **Co-Creation Map**: Row count = 5
- [ ] **Intent vs Interpretation**: Gaps analyzed
- [ ] **Seeds Planted**: At least one transformative/moonshot idea
- [ ] **Template cleanup**: No placeholder text in final doc

**HARD STOP**: Can't fill blanks = retrospective incomplete. Fix first.
```

---

## Error Handling Patterns

-   Use `try/catch` blocks for operations that might fail.
-   Provide descriptive error messages.
-   Implement graceful fallbacks in the UI.
-   Use custom error types where appropriate.

---

## Code Standards

-   Follow the established style guide for the language/framework.
-   Enable strict mode and linting where possible.
-   Write clear, self-documenting code and add comments where necessary.
-   Avoid `any` or other weak types in strongly-typed languages.

---

## Troubleshooting

### Build Failures
```bash
# Check for type errors or syntax issues
[build-command] 2>&1 | grep -A 5 "error"

# Clear cache and reinstall dependencies
rm -rf node_modules .cache dist build
[package-manager] install
```

### Port Conflicts
```bash
# Find the process using a specific port
lsof -i :[port-number]

# Kill the process
kill -9 [PID]
```

---

## Quick Command Reference

```bash
# Development
[run-command]          # Start dev server
[test-command]         # Run tests
gh issue create        # Create issue
gh pr create           # Create PR

# Tmux
tmux attach -t dev     # Attach to session
Ctrl+b, d              # Detach from session

# Search and Analysis
rg "pattern" --type [file-extension]   # Ripgrep (preferred)
fd "[pattern]"                          # Find files
```

---

## Environment Checklist

-   [ ] Correct version of [Language/Runtime] installed
-   [ ] [Package Manager] installed
-   [ ] GitHub CLI configured
-   [ ] Tmux installed
-   [ ] Environment variables set
-   [ ] Git configured

---

**See also**: [CLAUDE_workflows.md](CLAUDE_workflows.md) for how to use these templates, [CLAUDE_lessons.md](CLAUDE_lessons.md) for patterns discovered
