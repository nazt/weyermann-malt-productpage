# Archive Report: MAW Commands

**Scanned**: 2025-12-08 10:45 GMT+7
**Scope**: All MAW slash command files in `.claude/commands/` and `.codex/prompts/` directories

## Summary Overview

These 18 files represent an early-stage MAW (Multi-Agent Workflow) slash command system created during initial exploration (2025-12-01 to 2025-12-08). Architecture evolved from slash commands to direct `.sh` script calls. **STATUS: Ready for archiving** - All files are deprecated and replaced by direct script implementations.

### Timeline
- **Created**: 2025-12-01 through 2025-12-08
- **Last Used**: 2025-12-07 (MAW infrastructure session)
- **Replaced By**: Direct script calls (`.agents/scripts/*.sh`) per issue #21 and #22
- **Current Status**: All 18 files still in active directories, ready to move to archive

## 📦 Recommended for Archive

### High Confidence (Safe to Archive)
| File | Type | Size | Reason | Move To |
|------|------|------|--------|---------|
| .claude/commands/maw.sync.md | Docs | 4.7KB | Defines agent sync workflow; replaced by direct .sh calls | 🗄️ |
| .claude/commands/maw.sync.sh | Script | 2.4KB | Slash command handler; superseded by `.agents/scripts/sync.sh` | 🗄️ |
| .claude/commands/maw.hey.md | Docs | 1.3KB | Agent messaging interface; integrated into `.agents/scripts/hey.sh` | 🗄️ |
| .claude/commands/maw.hey.sh | Script | 393B | Slash command handler; replaced by direct script in issue #21 | 🗄️ |
| .claude/commands/maw.zoom.md | Docs | 1.1KB | Pane zoom command; functionality integrated into active agents | 🗄️ |
| .claude/commands/maw.zoom.sh | Script | 519B | Slash command handler; not used after architecture pivot | 🗄️ |
| .claude/commands/maw.codex.md | Docs | 987B | Codex CLI docs reference; info now in AGENTS.md | 🗄️ |
| .claude/commands/maw.codex.sh | Script | 2.1KB | Slash command handler; direct codex calls preferred | 🗄️ |
| .claude/commands/maw.issue.md | Docs | 922B | GitHub issue template; not referenced in recent sessions | 🗄️ |
| .claude/commands/maw.issue.sh | Script | 433B | Slash command handler; gh CLI used directly | 🗄️ |
| .claude/commands/maw.agents-create.md | Docs | 1.1KB | Agent creation guide; superseded by agent framework | 🗄️ |
| .codex/prompts/maw.codex.md | Docs | 987B | Duplicate; Codex reads AGENTS.md instead | 🗄️ |
| .codex/prompts/maw.sync.md | Docs | 4.7KB | Duplicate; reference info now in shared docs | 🗄️ |
| .codex/prompts/maw.zoom.md | Docs | 1.1KB | Duplicate; feature integrated into agents | 🗄️ |
| .codex/prompts/maw.hey.md | Docs | 1.3KB | Duplicate; Codex uses `.agents/scripts/hey.sh` directly | 🗄️ |
| .codex/prompts/maw.issue.md | Docs | 922B | Duplicate; not used post-pivot | 🗄️ |
| .codex/prompts/maw.agents-create.md | Docs | 1.1KB | Duplicate; framework evolved | 🗄️ |

## 🏷️ Topic Groups

### Slash Command System (Deprecated - All 11 Files)
Original command interface, fully replaced by direct scripts:
- **Agent messaging**: maw.hey.md/sh → replaced by `.agents/scripts/hey.sh`
- **Worktree sync**: maw.sync.md/sh → replaced by `.agents/scripts/sync.sh`
- **Pane control**: maw.zoom.md/sh → integrated into active agents
- **CI integration**: maw.codex.md/sh → direct codex calls preferred
- **Issue creation**: maw.issue.md/sh → gh CLI used directly
- **Agent bootstrap**: maw.agents-create.md → agent framework evolved

### Documentation Duplicates (6 Files)
Codex prompt files that mirror Claude command docs:
- `.codex/prompts/maw.*.md` (6 files total)
- All replaced by AGENTS.md (shared instruction file)
- Zero references in recent sessions (2025-12-01 through 2025-12-08)

## 📊 Summary
- **Total scanned**: 18 files
- **Archive candidates**: 18 (100% - all safe to archive)
- **Keep in active**: 0 (all deprecated)
- **Already archived**: 0 (ready to move)
- **Confidence level**: High - Architecture pivot documented in issue #21, #22, and 2025-12-07 retrospective

## 🚫 Do Not Archive (Keep in Active Project)

**These items should definitely be kept:**

1. **.agents/maw.env.sh** - Active environment setup
   - Used during MAW session initialization
   - Referenced in CLAUDE.md and active agent workflows
   - Modified 2025-12-07

2. **.agents/maw.completion.zsh** & **.agents/maw.completion.bash**
   - Shell completion helpers for maw commands (still active)
   - Enables command-line workflows

3. **.agents/scripts/sync.sh** - Current sync implementation
   - Direct replacement for deprecated maw.sync.sh
   - Used in active PocketBase work (issue #30)
   - Created 2025-12-07

4. **.agents/scripts/hey.sh** - Current agent messaging
   - Direct replacement for deprecated maw.hey.sh
   - Essential for multi-agent coordination
   - Contains timing fixes for Claude Code/Codex (sleep 0.05 pattern)

5. **.agents/scripts/start-agents.sh** - MAW session startup
   - Creates tmux layout for multi-agent execution
   - Actively used in daily workflows
   - Modified 2025-12-07

6. **AGENTS.md** - Codex styling guide
   - Created 2025-12-07 to teach Codex communication style
   - Replacement for .codex/prompts/maw.*.md files
   - Referenced by all active Codex agent sessions

7. **Issue #21** - Comprehensive MAW context documentation
   - Single source of truth for MAW system knowledge
   - Used in future sessions to onboard new work
   - Contains architecture decisions and The Golden Rule

8. **Issue #22** - MAW orchestrator plan
   - Implementation plan for `.claude/agents/maw-orchestrator.md`
   - Documents decision to use direct `.sh` calls instead of slash commands
   - Still in implementation phase

## Archive Plan

**Recommended Action**: Move all 18 files from active directories to archive

```bash
# Create archive directories (if not exist)
mkdir -p ψ-archive/maw-commands/2025-12/claude-commands
mkdir -p ψ-archive/maw-commands/2025-12/codex-prompts

# Move .claude/commands files (11 files)
mv .claude/commands/maw.*.md .claude/commands/maw.*.sh \
   ψ-archive/maw-commands/2025-12/claude-commands/ 2>/dev/null

# Move .codex/prompts files (6 files)
mv .codex/prompts/maw.*.md \
   ψ-archive/maw-commands/2025-12/codex-prompts/ 2>/dev/null

# Verify all 18 files are archived
find ψ-archive/maw-commands/2025-12 -name "maw.*" -type f | wc -l
# Expected output: 18
```

## Verification Commands

After archiving, verify with these commands:

```bash
# Check no active maw slash commands remain
ls -la .claude/commands/maw.* .codex/prompts/maw.* 2>&1 | wc -l
# Expected output: 0 (or "cannot access" errors for each)

# Verify archive contains all 18 files
find ψ-archive/maw-commands/2025-12 -name "maw.*" -type f | wc -l
# Expected output: 18

# Check active MAW scripts are still present
ls -la .agents/scripts/{sync,hey,start-agents}.sh
# Should show 3 active scripts - these are the replacements
```

## Context & Rationale

**Why these files are safe to archive:**

1. **Architecture pivot documented** (Issue #21)
   - User explicitly requested direct `.sh` script calls instead of slash commands
   - Stated in retrospective 2025-12-06: "i dont want slash command to be called"

2. **Replacement implementations in place** (Issue #22)
   - `.agents/scripts/sync.sh` (created 2025-12-07)
   - `.agents/scripts/hey.sh` (created 2025-12-07)
   - `.agents/scripts/start-agents.sh` (modified 2025-12-07)

3. **Zero references in recent work**
   - No slash commands used in sessions after 2025-12-07
   - All references are in archived documentation or historical issues
   - MAW infrastructure session (2025-12-07) explicitly moved away from this pattern

4. **Codex documentation consolidated**
   - All `.codex/prompts/maw.*.md` duplicates are now represented in `AGENTS.md`
   - AGENTS.md teaches Codex the same patterns without slash command layer

## Related Resources

- **Session**: ψ-retrospectives/2025-12/07/20.11_maw-infrastructure-session.md - Architecture pivot documented
- **Planning Session**: ψ-retrospectives/2025-12/06/21.24_retrospective.md - User clarification on preferences
- **Issue #21**: MAW comprehensive context (pivot decision, The Golden Rule, architecture)
- **Issue #22**: MAW orchestrator plan (direct script calls decision)
- **CLAUDE.md**: Updated with maw-orchestrator subagent documentation
- **Replacement Scripts**: `.agents/scripts/{sync,hey,start-agents}.sh`
- **Replacement Docs**: `AGENTS.md`, `CLAUDE.md`

