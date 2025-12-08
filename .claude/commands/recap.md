# /recap - Fresh Start Context Summary

Quick catch-up for when you're starting a fresh session. Prioritizes what changed most recently with importance scoring.

## Usage

```
/recap    # Get caught up on recent context
```

## What You Get (Tiered & Scored)

### Tier 1: File Changes (Most Valuable)
- Recently modified files with timestamps
- **Score** based on importance (type + recency + impact)
- Uncommitted working state

### Tier 2: Context & Planning
- Recent commits with messages
- Active plan issues
- Latest retrospectives

## Scoring System

| Factor | Weight | Description |
|--------|--------|-------------|
| Recency | +3 | < 1 hour ago |
| Recency | +2 | < 4 hours ago |
| Recency | +1 | < 24 hours ago |
| Type | +3 | Code files (.ts, .js, .go, .py) |
| Type | +2 | Agent/command files (.claude/) |
| Type | +1 | Docs (.md outside ψ-*) |
| Type | +0 | Logs/retros (ψ-*/) |
| Impact | +2 | Core files (CLAUDE.md, package.json) |
| Impact | +1 | Config files |

**Score interpretation**: 6+ = Critical, 4-5 = Important, 2-3 = Notable, 0-1 = Background

## Action

Use the Task tool with:
```
subagent_type: context-finder
model: haiku
prompt: |
  Run DEFAULT MODE with TIERED + SCORED OUTPUT.

  Run these commands:
  1. git log --since="24 hours ago" --format="COMMIT:%h|%ar|%s" --name-only
  2. git status --short
  3. git log --format="%h (%ad) %s" --date=format:"%Y-%m-%d %H:%M" -10
  4. gh issue list --limit 10 --state all --json number,title,createdAt --jq '.[] | select(.title | test("plan:")) | "#\(.number) (\(.createdAt | split("T")[0])) \(.title)"' | head -5
  5. ls -t ψ-retrospectives/**/*.md 2>/dev/null | head -3

  SCORING RULES (calculate for each file):
  - Recency: <1h = +3, <4h = +2, <24h = +1
  - Type: .ts/.js/.go/.py = +3, .claude/* = +2, .md (not ψ-) = +1, ψ-* = +0
  - Impact: CLAUDE.md/package.json = +2, config = +1
  - Score 6+ = 🔴, 4-5 = 🟠, 2-3 = 🟡, 0-1 = ⚪

  Output EXACTLY like this (compact, no extra words):

  ## 🔴 TIER 1: Files Changed

  | | When | File | What |
  |-|------|------|------|
  | 🔴 | 5m | src/index.ts | feat: New feature |
  | 🟠 | 1h | .claude/agents/foo.md | fix: Agent |
  | 🟡 | 3h | README.md | docs: Update |
  | ⚪ | 6h | ψ-retro/... | docs: Retro |

  **Working**: [M file.md, A new.md] or "Clean"

  ---

  ## 🟡 TIER 2: Context

  **Commits**
  | Time | Hash | Message |
  |------|------|---------|
  | 14:30 | 5c1786f | feat: Thing |

  **Plans**
  | # | Title |
  |---|-------|
  | #66 | plan: /recap |

  **Retros**
  | Time | Focus |
  |------|-------|
  | 14:00 | PocketBase 5-agent |

  ---

  **Now**: [What's hot based on 🔴 scores]
```
