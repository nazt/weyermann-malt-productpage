# CLAUDE_lessons.md - Lessons Learned

> **Navigation**: [Main](CLAUDE.md) | [Safety](CLAUDE_safety.md) | [Workflows](CLAUDE_workflows.md) | [Subagents](CLAUDE_subagents.md) | **Lessons** | [Templates](CLAUDE_templates.md)

*(This section should be continuously updated with project-specific findings)*

> **See also**: `psi-learnings/` directory for distilled meta-summaries of "what we did vs what we wanted"

---

## Key Learnings (2025-12-06)
-   **001-force-push**: Safety rules are infrastructure, not guidelines - internalize them
-   **002-golden-rule**: Distill complexity into memorable principles (complete, memorable, actionable)
-   **003-upstream-first**: Create upstream issues instead of local patches
-   **004-detect-before-act**: Always observe state before sending commands - "think first, see first, then decide"

---

## Tmux & Multi-Agent Infrastructure (2025-12-08)
-   **Pattern: Pane numbering per-window** - Tmux numbers panes per-window (0-2, then 0-2 in second window), not globally. Broke auto-warp logic until refactored to parse `window_index:pane_index` format.
-   **Pattern: Output suppression at source** - Suppress direnv logging with `DIRENV_LOG_FORMAT=""`, powerlevel10k warnings with `POWERLEVEL9K_INSTANT_PROMPT=quiet`. Better than downstream masking with `sleep` and `clear`.
-   **Discovery: Flags have hidden semantics** - `-a` in `tmux list-panes -a` means "all sessions", not "all windows". Was corrupting pane counts by including logger and streamlit sessions.
-   **Pattern: Semantic layout separation** - Organizing agents by tier (execution vs. specialists) across windows improves cognitive load and workflow clarity. Tested in profile8, profile14.
-   **Lesson: Test multi-scenario early** - Building auto-warp for single-window first, then refactoring for multi-window cost ~30 minutes. Test with full complexity from start.
-   **Co-creation insight**: User specificity ("1 2 3 / 4 5 6") shaped better decisions than hypothetical planning. Iterative feedback loop prevented over-engineering.
-   **Issue #38**: Context snapshot documenting 8 layout profiles with technical implementation details

---

## Shell Compatibility & Tmux Automation (2025-12-08 - Warp Agent Fixes)
-   **Anti-Pattern: Shell-specific functions in tmux** - Bash functions from `.envrc` don't load in ZSH shells reliably. Use direct commands instead: `cd /path && echo 'ready'` instead of function calls
-   **Discovery: Nested .envrc override gotcha** - Agent subdirectories have their own .envrc files that redefine parent variables (e.g., `repo_root=$PWD`). Can cause path corruption like `/agents/5/agents/5`
-   **Pattern: Use git over variables for paths** - `git rev-parse --show-toplevel` is more reliable than relying on `$repo_root` which can be overridden by nested configs
-   **Best Practice: Test in target shells** - Always test tmux automation in all target shells (bash, zsh). Behavior differs significantly; assume nothing
-   **Lesson: Simplicity beats abstraction** - Direct `cd` commands more robust than wrapped functions. Follows Unix principle: do one thing well
-   **Pattern: Shell compatibility checklist** - Document which shells are used, test functions in each, prefer simple commands over abstractions
-   **Related docs**: psi-retrospectives/2025-12/08/08.15_warp-agent-fixes.md (best practices, DO/DON'T examples)

---

## PocketBase Multi-Agent Orchestration (2025-12-08)
-   **Pattern: Claude for design, Codex for implementation** - Claude completes design tasks in ~30s, Codex takes ~2-3min for code. Natural division of labor by model strength.
-   **Pattern: Signal files for completion detection** - `.tmp/agent{N}-done` pattern works reliably across tmux windows. All agent worktrees share the same `.tmp/` directory.
-   **Pattern: 4-phase architecture** - Breaking work into Registration -> Task Queue -> Dashboard -> Orchestration provides clear progress tracking and allows partial completion.
-   **Anti-Pattern: No retry for Codex disconnects** - "stream disconnected before completion" errors can kill multiple agents simultaneously. Need automatic retry wrapper.
-   **Discovery: Claude agents need "push"** - Claude agents sometimes wait at permission prompt after task injection. Send Enter key via `tmux send-keys` to trigger execution.
-   **Pattern: Upsert for idempotent operations** - `FindFirstRecordByFilter` + `NewRecord` fallback ensures registration is safe to call multiple times.
-   **Lesson: 85% completion acceptable** - When Codex disconnects, proceed with partial results rather than blocking. Demo value over perfection.
-   **Related docs**: psi-retrospectives/2025-12/08/14.00_pocketbase-5agent-orchestration.md, agents/5/contributions/DEMO-REPORT.md

---

## Planning & Architecture Patterns (2025-08-26)
-   **Pattern**: Use parallel agents for analyzing different aspects of complex systems
-   **Anti-Pattern**: Creating monolithic plans that try to implement everything at once
-   **Pattern**: Ask "what's the minimum viable first step?" before comprehensive implementation
-   **Pattern**: 1-hour implementation chunks are optimal for maintaining focus and seeing progress

---

## Common Mistakes to Avoid
-   **Creating overly comprehensive initial plans** - Break complex projects into 1-hour phases instead
-   **Trying to implement everything at once** - Start with minimum viable implementation, test, then expand
-   **Skipping AI Diary and Honest Feedback in retrospectives** - These sections provide crucial context and self-reflection that technical documentation alone cannot capture
-   *Example: Forgetting to update a lockfile after changing dependencies.*
-   *Example: Not checking build logs for warnings that could become errors.*
-   *Example: Making assumptions about API responses instead of checking the spec.*

---

## Useful Tricks Discovered
-   **Parallel agents for analysis** - Using multiple agents to analyze different aspects speeds up planning significantly
-   **ccc -> nnn workflow** - Context capture followed by focused planning creates better structured issues
-   **Phase markers in issues** - Using "Phase 1:", "Phase 2:" helps track incremental progress
-   *Example: Using a specific library feature to simplify complex state.*
-   *Example: A shell command alias that speeds up a common task.*
-   *Example: A design pattern that solved a recurring problem in the codebase.*

---

## Project-Specific Patterns
-   *Example: The standard way we handle authentication state.*
-   *Example: The required structure for a new API endpoint.*
-   *Example: The component composition pattern used for UI elements.*

---

## User Preferences (Observed)
-   **Prefers manageable scope** - "i love this - Can be completed in under 1 hour" shows preference for achievable tasks
-   **Values phased approaches** - Recognizes when plans are "too huge" and appreciates splitting work
-   **Appreciates workflow patterns** - Likes using established patterns like "ccc nnn gh flow"
-   *Example: Prefers simple, direct solutions over complex abstractions.*
-   *Example: Values quick iteration and seeing visual progress.*
-   *Example: Appreciates clear, actionable feedback and well-defined tasks.*
-   **Time zone preference: GMT+7 (Bangkok/Asia)**

---

**See also**: [CLAUDE.md](CLAUDE.md) for quick reference, [CLAUDE_workflows.md](CLAUDE_workflows.md) for workflow patterns
