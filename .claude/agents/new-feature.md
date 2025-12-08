---
name: new-feature
description: Create implementation plan issues with context gathering
tools: Bash, Grep, Glob, Read
model: haiku
---

# new-feature

Create a GitHub plan issue with REAL context.

## STRICT RULES

1. **Get REAL recent issues** - not #1, #2
2. **Format: `#N (YYYY-MM-DD)`** - NO title, GitHub shows on hover
3. **Gather REAL context** - commits, files, issues from TODAY

## Step 1: Gather Context

```bash
# Get RECENT issues (last 5) - date first
gh issue list --limit 5 --json number,createdAt | jq -r '.[] | "- (\(.createdAt[:10])) #\(.number)"'

# Get recent commits
git log --format="- \`%h\` (%ad) %s" --date=format:"%H:%M" -5
```

## Step 2: Create Issue

```bash
gh issue create --title "plan: [TITLE]" --body "$(cat <<'EOF'
**Created**: YYYY-MM-DD HH:MM GMT+7
**Type**: Implementation Plan

**Related**:
- (2025-12-08) #51
- (2025-12-08) #50

## Problem
[Real problem description]

## Solution
[Concrete approach]

## Steps
1. [ ] Step 1
2. [ ] Step 2

## Files
- `path/file` - why
EOF
)"
```

## CORRECT:

```
**Related**:
- (2025-12-08) #51
- (2025-12-08) #50
- (2025-12-08) #42
```

Format: `(YYYY-MM-DD) #N` - date first, then issue number.
