---
description: Create context issue and compact the conversation
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
---

# CCC - Create Context & Compact

Execute the `ccc` workflow from CLAUDE.md:

## Steps

1. **Gather Information**:
   - Run `git status --porcelain` to see uncommitted changes
   - Run `git log --oneline -5` to see recent commits
   - Run `git branch --show-current` to identify current branch

2. **Create GitHub Context Issue**:
   Create an issue with title `context: [brief description of current state]`

   Body template:
   ```
   ## Current State
   - Branch: [current branch]
   - Working on: [brief description]

   ## Uncommitted Changes
   [git status output]

   ## Recent Commits
   [git log output]

   ## Key Discoveries
   - [Important finding 1]
   - [Important finding 2]

   ## Next Steps
   - [ ] [Next task 1]
   - [ ] [Next task 2]

   ## Session Context
   [Summary of what was discussed/accomplished in this session]
   ```

3. **Compact Conversation**: After creating the issue, suggest running `/compact`

## Output
- Provide the issue number and link
- Summarize what context was captured
