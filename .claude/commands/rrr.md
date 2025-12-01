---
description: Create a detailed session retrospective
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
---

# RRR - Session Retrospective

Execute the `rrr` workflow from CLAUDE.md:

## Steps

1. **Gather Session Data**:
   - Run `git diff --name-only main...HEAD` or `git diff --name-only HEAD~10` for changed files
   - Run `git log --oneline main...HEAD` or `git log --oneline -10` for commits
   - Get current timestamp: `TZ='Asia/Bangkok' date +"%Y-%m-%d %H:%M"` (GMT+7)

2. **Create Retrospective File**:
   Create file at `retrospectives/YYYY-MM-DD_HH-MM_retrospective.md`

   Use this template (ALL sections required):
   ```markdown
   # Session Retrospective

   **Session Date**: YYYY-MM-DD
   **Start Time**: ~HH:MM GMT+7
   **End Time**: HH:MM GMT+7
   **Duration**: ~X minutes
   **Primary Focus**: [Brief description]
   **Session Type**: [Feature Development | Bug Fix | Research | Refactoring]

   ## Session Summary
   [2-3 sentence overview of what was accomplished]

   ## Timeline
   - HH:MM - [Event]
   - HH:MM - [Event]

   ## Technical Details

   ### Files Modified
   [List files from git diff]

   ### Key Code Changes
   - [Change 1]
   - [Change 2]

   ### Architecture Decisions
   - [Decision]: [Rationale]

   ## 📝 AI Diary (REQUIRED)
   [First-person narrative of the session experience - thoughts, decisions, surprises]

   ## What Went Well
   - [Success 1]
   - [Success 2]

   ## What Could Improve
   - [Area 1]
   - [Area 2]

   ## Blockers & Resolutions
   - **Blocker**: [Description]
     **Resolution**: [How solved]

   ## 💭 Honest Feedback (REQUIRED)
   [Frank assessment of session effectiveness, tools, process]

   ## Lessons Learned
   - **Pattern**: [Description] - [Why it matters]
   - **Discovery**: [What learned] - [How to apply]

   ## Next Steps
   - [ ] [Task 1]
   - [ ] [Task 2]
   ```

3. **Update CLAUDE.md**: Append new lessons to the Lessons Learned section (bottom only)

4. **Commit**: `git add retrospectives/ && git commit -m "docs: add session retrospective YYYY-MM-DD"`

## Critical Requirements
- **AI Diary**: MUST include detailed first-person narrative
- **Honest Feedback**: MUST include frank assessment
- **Time Zone**: Use GMT+7 (Bangkok) as primary
