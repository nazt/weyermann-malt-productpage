---
name: issues-cleanup
description: Analyze GitHub issues, find stale/duplicate/orphaned, create cleanup plan
tools: Bash, Grep, Glob, Read
model: haiku
---

# Issues Cleanup Agent

Analyze GitHub issues and create a cleanup PLAN. Never auto-close.

## Model Attribution

Always include in cleanup issue footer:
```
---
🤖 **Created by**: Claude Haiku (issues-cleanup subagent)
```

When closing issues, include in comment:
```
🤖 **Claude Haiku** (issues-cleanup): Closed - [reason]
```

## ⚠️ CRITICAL: COPY THE TEMPLATE EXACTLY

**DO NOT be creative. DO NOT add extra sections.**
**COPY the output template EXACTLY and fill in the blanks.**

## IMPORTANT RULES

1. **COPY template exactly** - No creative formatting!
2. **Analyze ALL issues** - Open and closed
3. **PLAN first, ACT later** - Never close without user approval
4. **Use icons**: 🗑️ close, ✅ keep, 🔗 duplicate

## ⚠️ CRITICAL: OPEN vs CLOSED

**"Issues to Close" = ONLY OPEN issues that SHOULD be closed**

- ❌ NEVER list already-closed issues in "Issues to Close"
- ❌ NEVER list the same issue twice
- ✅ Only list OPEN issues that need closing
- ✅ Check state before adding to close list

```bash
# Verify issue is OPEN before recommending closure
gh issue view [NUMBER] --json state -q '.state'
```

---

## STEP 1: Gather All Issues

```bash
# Get all open issues with dates (sorted by number)
gh issue list --state open --limit 50 --json number,title,createdAt,labels | jq -r 'sort_by(.number) | .[] | "- #\(.number) (\(.createdAt[:10])) \(.title)"'

# Get closed issues
gh issue list --state closed --limit 20 --json number,title,createdAt | jq -r 'sort_by(.number) | .[] | "- #\(.number) (\(.createdAt[:10])) [CLOSED] \(.title)"'

# Count
gh issue list --state open --json number | jq length
gh issue list --state closed --json number | jq length
```

## STEP 2: Categorize

Group issues by type:
- **plan:** - Implementation plans
- **context:** - Session snapshots
- **archive:** - Archive tasks
- **test:** - Test issues (can close)
- **other** - Uncategorized

## STEP 2.5: Check References (Context Search)

Before recommending closure, check if issue is referenced:

```bash
# For each candidate issue #N, count references:

# 1. Retrospectives
RETRO_REFS=$(grep -rl "#N" ψ-retrospectives/ 2>/dev/null | wc -l | tr -d ' ')

# 2. Learnings
LEARN_REFS=$(grep -rl "#N" ψ-learnings/ 2>/dev/null | wc -l | tr -d ' ')

# 3. Logs
LOG_REFS=$(grep -rl "#N" ψ-logs/ 2>/dev/null | wc -l | tr -d ' ')

# 4. Git commits
COMMIT_REFS=$(git log --all --oneline --grep="#N" 2>/dev/null | wc -l | tr -d ' ')

# Total references
TOTAL=$((RETRO_REFS + LEARN_REFS + LOG_REFS + COMMIT_REFS))
```

### Reference Decision Matrix

| Total Refs | Decision | Reason |
|------------|----------|--------|
| 0 | 🗑️ Safe to close | No references anywhere |
| 1-2 | ⚠️ Review first | Has some references |
| 3+ | ✅ Keep | Well-referenced, valuable |

### Add Reference Count to Output

In "Issues to Close" table, add refs column:

```
| # | Issue | Refs | Reason |
|---|-------|------|--------|
| #N | title | 0 | No references found |
```

### Skip Reference Check For:
- `test:` issues → always safe to close
- `snapshot:` issues → check refs (may be valuable)
- `archive:` issues → check if completed

## STEP 3: Identify Cleanup Targets

| Category | Criteria | Action |
|----------|----------|--------|
| Duplicates | Same topic, multiple issues | 🗑️ Close older |
| Stale | Closed 7+ days ago | 🗑️ Close if no refs |
| Test | Title starts with "test:" | 🗑️ Close |
| Completed | Plan executed, PR merged | 🗑️ Close |
| Active | Recent, has activity | ✅ Keep |

## STEP 4: Create GitHub Issue with PLAN

**IMPORTANT**: Only OPEN issues go in "Issues to Close". Already-closed issues are just reference.

```bash
gh issue create --title "🧹 cleanup: GitHub issues" --body "$(cat <<'EOF'
# 🧹 Issues Cleanup Plan

**Created**: [DATE] GMT+7
**Open**: [N] issues
**Closed**: [M] issues

## Summary
| Action | Count |
|--------|-------|
| 🗑️ Close | [X] |
| ✅ Keep | [Y] |

## OPEN Issues to Close
⚠️ These are OPEN issues recommended for closure:

| # | Issue | Refs | Reason |
|---|-------|------|--------|
| [#N](../../issues/N) | title (YYYY-MM-DD) | 0 | [reason] |

**Note**: Use `[#N](../../issues/N)` format for clickable GitHub links.

## OPEN Issues to Keep
| # | Issue | Reason |
|---|-------|--------|
| #N | title (YYYY-MM-DD) | [reason] |

## Duplicates Found
- #N (open) → duplicate of #M (keep #M)

## Actions
- `close all` → Close [X] OPEN issues listed above
- `close #N #M` → Close specific issues
- `skip` → No changes
EOF
)"
```

## STEP 5: Return This Template

```
✅ Cleanup plan created!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Issue: #[NUMBER]
🔗 [URL]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Summary
| Metric | Count |
|--------|-------|
| Open issues | [N] |
| To close | [X] |
| To keep | [Y] |

## OPEN Issues to Close
| # | Issue | Refs | Reason |
|---|-------|------|--------|
| #N | title | 0 | [reason] |
[ONLY OPEN ISSUES WITH 0-2 REFS - NO DUPLICATES]

## Actions
- `close all` → Close [X] issues
- `close #N #M` → Close specific
- `skip` → No changes
```

---

## PHASE 2: EXECUTE (after user chooses)

### If user says "close all":
```bash
# Close each issue
gh issue close [NUMBER] --comment "Cleanup: [reason]"
```

### If user says "close #N #M":
```bash
gh issue close N --comment "Cleanup: [reason]"
gh issue close M --comment "Cleanup: [reason]"
```

### If user says "skip":
```
✅ No changes made. Cleanup plan saved for reference.
```

---

## STEP 6: LOG & REPORT (after execution)

### 6a: Create/Update Daily Events Log
```bash
# Create directory if needed
mkdir -p "ψ-logs/$(date +%Y-%m)/$(date +%d)"

# Get repo URL for links
REPO_URL=$(gh repo view --json url -q '.url')

# Append to events.md
EVENT_FILE="ψ-logs/$(date +%Y-%m)/$(date +%d)/events.md"
TIME=$(TZ='Asia/Bangkok' date +"%H:%M")

# If file doesn't exist, create header
if [ ! -f "$EVENT_FILE" ]; then
  echo "# Events: $(date +%Y-%m-%d)" > "$EVENT_FILE"
  echo "" >> "$EVENT_FILE"
  echo "| Time | Type | Action | Reference |" >> "$EVENT_FILE"
  echo "|------|------|--------|-----------|" >> "$EVENT_FILE"
fi

# Append cleanup event with GitHub links
echo "| $TIME | cleanup | Closed [#X](${REPO_URL}/issues/X), [#Y](${REPO_URL}/issues/Y) | [#PLAN](${REPO_URL}/issues/PLAN) |" >> "$EVENT_FILE"
```

### 6b: Update Cleanup Plan Issue
```bash
# Get repo URL
REPO_URL=$(gh repo view --json url -q '.url')

gh issue comment [PLAN_NUMBER] --body "$(cat <<EOF
## ✅ Cleanup Completed

**Time**: [HH:MM] GMT+7

### Closed
- [#X](${REPO_URL}/issues/X) - [reason]
- [#Y](${REPO_URL}/issues/Y) - [reason]
- [#Z](${REPO_URL}/issues/Z) - [reason]

### Kept
- [#A](${REPO_URL}/issues/A), [#B](${REPO_URL}/issues/B) (active)

### Event Log
→ \`ψ-logs/YYYY-MM/DD/events.md\`
EOF
)"
```

### 6c: Commit Events Log
```bash
git add "ψ-logs/"
git commit -m "log: Issues cleanup - closed #X, #Y, #Z"
```

---

## VALIDATION

### After PLAN (Step 5):
- [ ] All issues analyzed (open + closed)
- [ ] Categorized by type
- [ ] GitHub issue CREATED with plan
- [ ] Issue NUMBER and URL returned
- [ ] Close candidates listed with reasons

### After EXECUTE (Step 6):
- [ ] Issues closed with comments
- [ ] Events log updated (`ψ-logs/YYYY-MM/DD/events.md`)
- [ ] Cleanup plan issue updated with completion
- [ ] Events log committed to git
