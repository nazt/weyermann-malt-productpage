# Upstream First

**Date**: 2025-12-01
**Source**: retrospectives/2025-12-01_13-20_retrospective.md, narrative-maw-notifications.md

## Intent
Fix an OSC escape sequence bug in the MAW `hey.sh` script that was corrupting tmux commands.

## Outcome
Instead of patching locally, created issue #26 on the upstream MAW repository with comprehensive details. Used a workaround until the fix merges.

## Gap Analysis
- **Initial instinct**: Fix it locally, move on
- **Better approach**: Document upstream, benefit the community
- **Trade-off**: Slightly slower immediate fix, but better long-term maintenance

## Key Learning
**Create upstream issues instead of local patches. This documents problems for the community, avoids maintenance burden, and keeps dependencies clean.**

## Why This Matters

| Local Patch | Upstream Issue |
|-------------|----------------|
| Quick fix | Documented for all users |
| Creates maintenance debt | Community benefits |
| May diverge from upstream | Stays in sync |
| Knowledge stays local | Knowledge is shared |

## The Bug
```bash
# Line 77 in hey.sh
tmux send-keys -t "$pane" "$text"  # Missing -l flag

# Result: OSC escape sequences mixed into commands
> 10;rgb:cccc/cccc/cccc\11;rgb:1e1e/1e1e/1e1eclaude...
```

## Applied In
- Created MAW issue #26 with reproduction steps
- Used workaround locally while waiting for fix
- Established pattern for future dependency bugs

## User Guidance
> "can you help me prevent implement test if we found a solution just create an issue"

Clear direction: document, don't patch.
