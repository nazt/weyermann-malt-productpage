# /recap - Fresh Start Context Summary

Quick catch-up for when you're starting a fresh session. Prioritizes what changed most recently.

## Usage

```
/recap    # Get caught up on recent context
```

## What You Get (Tiered by Value)

### Tier 1: File Changes (Most Valuable)
- Recently modified files with timestamps
- What changed in each file (summary)
- Uncommitted working state

### Tier 2: Context & Planning
- Recent commits with messages
- Active plan issues
- Latest retrospectives

## Action

Use the Task tool with:
```
subagent_type: context-finder
model: haiku
prompt: |
  Run DEFAULT MODE with TIERED OUTPUT format.

  Run these commands:
  1. git log --since="24 hours ago" --format="COMMIT:%h|%ar|%s" --name-only
  2. git status --short
  3. git log --format="%h (%ad) %s" --date=format:"%Y-%m-%d %H:%M" -10
  4. gh issue list --limit 10 --state all --json number,title,createdAt --jq '.[] | select(.title | test("plan:")) | "#\(.number) (\(.createdAt | split("T")[0])) \(.title)"' | head -5
  5. ls -t ψ-retrospectives/**/*.md 2>/dev/null | head -3

  Output EXACTLY like this:

  ## 🔴 TIER 1: File Changes (Last 24h)

  | When | Files | Change |
  |------|-------|--------|
  | [from %ar] | [files] | [commit message] |

  ### Working State
  [git status output or "Clean"]

  ---

  ## 🟡 TIER 2: Context

  ### Commits
  [from git log -10]

  ### Plans
  [from gh issue list]

  ### Retrospectives
  [paths with Focus extracted]

  ---

  **Summary**: [1 sentence about current momentum]
```
