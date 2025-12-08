# Reference-Based Cleanup

**Date**: 2025-12-08
**Source**: Issues cleanup session with context-finder integration

## The Problem

Cleanup agents make bad decisions without context:
- Mark issues as "stale" when they're heavily referenced
- Close valuable context that other docs depend on
- No way to know if an issue is truly orphaned

## The Solution

**Check references before recommending closure.**

```bash
# Count references for issue #N
REFS=$(grep -rl "#N" ψ-retrospectives/ ψ-learnings/ ψ-logs/ 2>/dev/null | wc -l)
COMMITS=$(git log --grep="#N" --oneline | wc -l)
TOTAL=$((REFS + COMMITS))
```

## Decision Matrix

| Total Refs | Decision | Rationale |
|------------|----------|-----------|
| 0 | 🗑️ Safe to close | Nothing depends on it |
| 1-2 | ⚠️ Review first | Has some value, verify |
| 3+ | ✅ Keep | Well-integrated, valuable |

## Evidence

From 2025-12-08 cleanup:

| Issue | Initial Decision | Refs Found | Final Decision |
|-------|------------------|------------|----------------|
| [#3](https://github.com/nazt/weyermann-malt-productpage/issues/3) | Stale | 36 | ✅ Keep |
| [#4](https://github.com/nazt/weyermann-malt-productpage/issues/4) | Stale | 11 | ✅ Keep |
| [#21](https://github.com/nazt/weyermann-malt-productpage/issues/21) | Complete | 29 | ✅ Keep |
| [#31](https://github.com/nazt/weyermann-malt-productpage/issues/31) | Keep | 0 | 🗑️ Close |
| [#39](https://github.com/nazt/weyermann-malt-productpage/issues/39) | Keep | 0 | 🗑️ Close |

**Result**: Prevented 4 bad closes, found 15 truly orphaned issues.

## Pattern: Consult Before Acting

This applies beyond cleanup:

| Action | Consult First |
|--------|---------------|
| Delete file | Check git log, grep for imports |
| Close issue | Check refs in docs, commits |
| Archive code | Check for callers, tests |
| Remove feature | Check usage, analytics |

## Implementation

Embedded in `issues-cleanup` agent as Step 2.5:
1. For each candidate issue
2. Search ψ-retrospectives/, ψ-learnings/, ψ-logs/
3. Search git log
4. Apply decision matrix
5. Add Refs column to output

## Key Insight

> "If nothing references it, it's truly orphaned. If many things reference it, it has value we can't see from the title alone."

## Related
- `.claude/agents/issues-cleanup.md` - Implementation
- `ψ-logs/2025-12/08/events.md` - First use
- [#63](https://github.com/nazt/weyermann-malt-productpage/issues/63) - Cleanup plan issue
