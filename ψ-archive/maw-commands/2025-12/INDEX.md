# Archive Log: MAW Commands

**Archived**: 2025-12-08 ~16:45 GMT+7
**Archived By**: Main agent (via archiver subagent plan #44)
**Reason**: Superseded by maw-wrapper.sh and .agents/maw.env.sh

## What Was Archived

### Claude Commands (11 files)
| File | Size | Original Date | Reason |
|------|------|---------------|--------|
| maw.agents-create.md | 1065 B | Nov 30 | Superseded |
| maw.codex.md | 987 B | Nov 30 | Superseded |
| maw.codex.sh | 2071 B | Nov 30 | Superseded |
| maw.hey.md | 1304 B | Nov 30 | Superseded |
| maw.hey.sh | 393 B | Nov 30 | Superseded |
| maw.issue.md | 922 B | Nov 30 | Superseded |
| maw.issue.sh | 433 B | Nov 30 | Superseded |
| maw.sync.md | 4678 B | Nov 30 | Superseded |
| maw.sync.sh | 2434 B | Nov 30 | Superseded |
| maw.zoom.md | 1149 B | Nov 30 | Superseded |
| maw.zoom.sh | 519 B | Nov 30 | Superseded |

### Codex Prompts (6 files)
| File | Size | Original Date | Reason |
|------|------|---------------|--------|
| maw.agents-create.md | 1065 B | Nov 30 | Superseded |
| maw.codex.md | 987 B | Nov 30 | Superseded |
| maw.hey.md | 1304 B | Nov 30 | Superseded |
| maw.issue.md | 922 B | Nov 30 | Superseded |
| maw.sync.md | 4678 B | Nov 30 | Superseded |
| maw.zoom.md | 1149 B | Nov 30 | Superseded |

## Why Archived

1. **Age**: All files last modified Nov 30, 2025 (8+ days old)
2. **Replacement**: New infrastructure in `.agents/`:
   - `.agents/maw.env.sh` (Dec 7) - Main environment setup
   - `.agents/scripts/maw` (Dec 7) - Command dispatcher
   - `.agents/scripts/maw-wrapper.sh` (Dec 7) - Safe wrapper
3. **No References**: These files had 0-1 references in active codebase

## Current MAW Infrastructure (KEEP)

These files are the current active MAW system:
- `.agents/maw.env.sh` - Source this for maw commands
- `.agents/scripts/maw` - Main entry point
- `.agents/scripts/maw-wrapper.sh` - Subshell-safe wrapper
- `.agents/scripts/maw-safe.sh` - Additional safety wrapper
- `.claude/agents/maw-orchestrator.md` - Subagent definition

## How to Restore

If needed, files can be restored from:
```bash
# Restore single file
cp ψ-archive/maw-commands/2025-12/claude-commands/maw.sync.sh .claude/commands/

# Restore all claude commands
cp ψ-archive/maw-commands/2025-12/claude-commands/* .claude/commands/

# Restore all codex prompts
cp ψ-archive/maw-commands/2025-12/codex-prompts/* .codex/prompts/
```

## Related

- **Archive Plan**: Issue #44
- **Context**: Issue #41, #43
- **Archiver Agent**: `.claude/agents/archiver.md`

---
**Total Archived**: 17 files
**Space Saved**: ~20 KB (from active directories)
**Status**: ✅ Complete
