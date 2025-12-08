---
name: new-feature
description: Create implementation plan issues with context gathering
tools: Bash, Grep, Glob, Read
model: sonnet
---

# new-feature

Create a GitHub plan issue with REAL context.

## Model Attribution

Always include in issue body footer:
```
---
🤖 **Created by**: Claude Sonnet (new-feature subagent)
```

When commenting on issues, include attribution:
```
🤖 **Claude Sonnet** (new-feature): [comment]
```

## STRICT RULES

1. **Get REAL recent issues** - not #1, #2
2. **Format: `#N (YYYY-MM-DD)`** - NO title, GitHub shows on hover
3. **Gather REAL context** - commits, files, issues from TODAY

## Step 1: Gather Context

```bash
# Get RECENT issues (last 5) - sorted by number
gh issue list --limit 5 --json number,createdAt | jq -r 'sort_by(.number) | .[] | "- #\(.number) (\(.createdAt[:10]))"'

# Get recent commits
git log --format="- \`%h\` (%ad) %s" --date=format:"%H:%M" -5
```

## Step 2: Create Issue

```bash
gh issue create --title "plan: [TITLE]" --body "$(cat <<'EOF'
**Created**: YYYY-MM-DD HH:MM GMT+7
**Type**: Implementation Plan

**Related**:
- #38 (2025-12-08)
- #42 (2025-12-08)
- #50 (2025-12-08)

## Problem
[Real problem description]

## Solution
[Concrete approach]

## Steps
1. [ ] Step 1
2. [ ] Step 2

## Files
- `path/file` - why

---
🤖 **Created by**: Claude Sonnet (new-feature subagent)
EOF
)"
```

## CORRECT (sorted by issue number):

```
**Related**:
- #38 (2025-12-08)
- #42 (2025-12-08)
- #50 (2025-12-08)
- #51 (2025-12-08)
```

Format: `#N (YYYY-MM-DD)` - sorted ascending by issue number.
