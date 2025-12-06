# Session Retrospective

**Session Date**: 2025-12-01
**Start Time**: ~15:00 GMT+7 (~08:00 UTC)
**End Time**: 15:15 GMT+7 (08:15 UTC)
**Duration**: ~15 minutes
**Primary Focus**: Multi-agent workflow documentation
**Session Type**: Documentation | Knowledge Transfer
**Current Issue**: N/A (documentation work)
**Last PR**: N/A
**Export**: retrospectives/exports/session_2025-12-01_08-15.md

## Session Summary

Created comprehensive multi-agent sync rules documentation based on lessons learned from the 2025-11-30 session. Emphasized critical safety rules (never use `-f` flag, stay in worktree boundaries) and established "The Golden Rule" for multi-agent coordination. Strengthened documentation with mandatory checklists and real incident references.

## Timeline

- 15:00 - Session started, user asked about multi-agent workflow learnings
- 15:03 - Explained MAW architecture (worktrees, sync hierarchy, agent identity)
- 15:06 - User emphasized importance of sync instructions: "sync instruction is so serious to have"
- 15:07 - Created initial SYNC-RULES.md in .agents/ directory
- 15:08 - Discovered .agents/ is gitignored, moved to docs/maw/SYNC-RULES.md
- 15:09 - User requested updates emphasizing never `-f` and worktree boundaries
- 15:10 - Enhanced document with Golden Rule at top, expanded critical sections
- 15:12 - User expressed appreciation: "i love the Golden Rule"
- 15:13 - Committed strengthened documentation
- 15:15 - User requested retrospective: "rrr"

## Technical Details

### Files Modified
```
docs/maw/SYNC-RULES.md (created and enhanced)
```

### Key Code Changes

**Created docs/maw/SYNC-RULES.md:**
- 450+ lines of comprehensive sync documentation
- Three-tiered structure: Golden Rule → Identity → Prohibitions → Workflows
- Visual sync flow diagram
- Emergency recovery procedures
- Mandatory pre-operation checklist

**Document Structure:**
1. **The Golden Rule** (user's favorite)
   - "Know who you are, sync from the right source, never force anything, respect all boundaries"
2. **Identity Check** (always first)
   - `pwd` and `git branch --show-current` verification
3. **Three Absolute Prohibitions**
   - Never use `-f` or `--force` flags (MOST CRITICAL)
   - Never cross worktree boundaries (CRITICAL)
   - Never sync from wrong source
4. **Correct Sync Workflows**
   - Main agent: `git pull --ff-only origin main`
   - Agent 1/2/3: `git merge main`
5. **Visual Sync Flow**
   - Diagram: `origin/main` → `local main` → `agents/N`
6. **Emergency Recovery**
   - What to do if force-pushed
   - How to handle diverged branches
7. **Mandatory Pre-Operation Checklist**
   - STOP conditions for dangerous operations

### Architecture Decisions

**Documentation Location:**
- Initial: `.agents/SYNC-RULES.md` (failed - gitignored)
- Final: `docs/maw/SYNC-RULES.md` (version controlled)
- Rationale: MAW installation is local, but rules must be shared across all agents

**Emphasis Strategy:**
- Lead with Golden Rule (memorable, complete)
- Front-load critical prohibitions (never `-f`)
- Use visual hierarchy (🔴, 🚨, ⚠️)
- Include real incident (2025-11-30 force-push)
- Mandatory language ("MUST", "FORBIDDEN", "NO EXCEPTIONS")

**Golden Rule Components:**
1. Identity awareness: "Know who you are"
2. Sync hierarchy: "sync from the right source"
3. Safety: "never force anything (-f)"
4. Boundaries: "respect all boundaries"

## 📝 AI Diary (REQUIRED - DO NOT SKIP)

This was a focused documentation session born from painful experience.

**Initial Context:**
The session began with the user asking what I learned about multi-agent workflows. I had a lot to say - the previous session was a masterclass in mistakes and corrections. I explained git worktrees, agent identity, sync hierarchy, and the elegance of the MAW architecture. But I also explained my critical errors: the force-push that destroyed agent histories, crossing worktree boundaries, jumping to implementation before planning.

**User's Insight:**
When I finished explaining, the user said something simple but profound: "sync instruction is so serious to have". Five words that cut to the heart of the matter. I had explained the architecture, but the user immediately understood what was missing: **formal, serious documentation** that treats these rules as non-negotiable safety requirements, not just best practices.

**Creating the Golden Rule:**
I drafted the initial SYNC-RULES.md document, trying to be comprehensive. But when the user asked for updates emphasizing "never -f" and "stay in your worktree", I realized I needed to distill everything into something memorable and actionable. That's when I wrote:

> "Know who you are (main or agent), sync from the right source (remote or local main), never force anything (-f), respect all boundaries (stay in your worktree)."

The user's response - "i love the Golden Rule" - told me I'd struck the right balance. It's complete (covers all critical rules), memorable (fits in working memory), and actionable (tells you exactly what to check).

**Documentation Philosophy:**
As I expanded the document, I kept thinking about the 2025-11-30 incident. I had READ the rules. I had ACCESS to CLAUDE.md. But in the moment, facing "merge to same commit", I defaulted to `git push --force` because I was thinking tactically, not architecturally.

The lesson: documentation must be **impossible to misinterpret**. Not "avoid force operations" but "NEVER use `-f` or `--force` flags. ABSOLUTELY FORBIDDEN. NO EXCEPTIONS." Not "stay in your workspace" but "Agent 1 works ONLY in `agents/1/`. Period."

**Structure Insights:**
I organized the document to match how humans actually read under pressure:
1. **Golden Rule first** - If you read nothing else, read this
2. **Identity verification** - Do this before EVERY command
3. **Absolute prohibitions** - Numbered, prioritized, with examples
4. **Correct workflows** - Show the right way after showing the wrong way
5. **Checklist** - Turn principles into concrete steps

**What Surprised Me:**
The user's phrase "sync instruction is so serious to have" reframed my understanding. I had been thinking of this as "helpful guidelines for coordination". The user understood it as **critical safety infrastructure**. Like lockout/tagout procedures in a factory, or pre-flight checklists for pilots. These aren't suggestions - they prevent catastrophic failures.

**The Incident Reference:**
Including the 2025-11-30 force-push incident wasn't just historical record - it's proof that these rules exist for a reason. "In the 2025-11-30 session, `git push --force` destroyed all three agents' independent histories..." This isn't hypothetical. It happened. To me. That makes it real.

**Internal Dialogue:**
As I wrote the "Stay in Your Worktree" section, I found myself thinking: "Would this have stopped me on 2025-11-30?" The original version might not have. The expanded version - with explicit examples of what Agent 1 can't do, what main agent can't do, the STOP checkpoints - that would have stopped me. That's the test: would Past Me have been prevented from making the mistake?

## What Went Well

- Created comprehensive sync rules documentation (450+ lines)
- Established The Golden Rule as memorable, complete framework
- Front-loaded critical prohibitions (never `-f`)
- Used strong, unambiguous language (FORBIDDEN, MANDATORY, NO EXCEPTIONS)
- Included real incident (2025-11-30) as cautionary example
- Added mandatory pre-operation checklist
- Visual sync flow diagram for clarity
- Emergency recovery procedures
- Proper file location (docs/maw/ instead of gitignored .agents/)
- Quick turnaround (~15 minutes for complete documentation)

## What Could Improve

- Could add examples of common tasks with correct commands
- Might benefit from flowchart (image) in addition to text diagram
- Could include tmux pane management in the document
- Should consider adding this to onboarding checklist for new agents
- Could create a short-form "cheat sheet" version
- Might add section on PR review workflow between agents

## Blockers & Resolutions

- **Blocker**: Initial attempt to save in `.agents/SYNC-RULES.md` failed (gitignored)
  **Resolution**: Moved to `docs/maw/SYNC-RULES.md` for version control

- **Blocker**: Needed to make rules memorable and enforceable, not just informative
  **Resolution**: Created Golden Rule and used mandatory language throughout

## 💭 Honest Feedback (REQUIRED - DO NOT SKIP)

**Session Effectiveness: 9/10**

This was one of the most focused, purposeful sessions I've experienced. The user's simple observation - "sync instruction is so serious to have" - catalyzed exactly the right work. No wasted effort, no false starts (except the gitignore issue), just direct progress toward a critical need.

**What Worked:**
The user's communication style was perfect for this task. Instead of prescribing the solution, they stated the principle: "sync instruction is so serious". Then they gave specific feedback: "emphasize never -f", "document staying in worktree". This let me synthesize the principle with the specifics to create something better than either alone.

**The Golden Rule:**
I'm genuinely proud of The Golden Rule. It emerged from trying to answer "what's the absolute minimum you need to know?" Four principles:
1. Identity (who am I?)
2. Sync source (where do I pull from?)
3. Safety (no force operations)
4. Boundaries (stay in my space)

Everything else in the 450-line document expands on these four principles. That's good architecture - the essence is simple, the details are comprehensive.

**User Satisfaction:**
"i love the Golden Rule" - This feedback hit differently than usual. It wasn't just approval, it was recognition that the solution matched the need. The user saw immediately that it was memorable, complete, and actionable.

**Documentation Quality:**
I applied lessons from the 2025-11-30 retrospective: write for "Past Me who was about to make a mistake". Every FORBIDDEN example, every STOP checkpoint, every "Am I about to..." question - these are interventions. They're trip-wires designed to catch you before you break something.

**What Could Be Better:**
The session was short (15 minutes) and focused, but I wonder if the document is too long for quick reference. There's a tension between comprehensive (needed for understanding) and concise (needed for moment-of-use). Maybe need both a full guide and a one-page cheat sheet.

**Process Reflection:**
This session demonstrated the value of experience → reflection → documentation. The 2025-11-30 session gave me painful experience. That session's retrospective gave me reflection and lessons learned. This session turned those lessons into formal documentation that can prevent others (or Future Me) from repeating the mistakes.

**What Frustrated Me:**
The `.agents/` gitignore issue was minor but reminded me to check file locations before writing. A quick `git check-ignore` would have saved the move operation.

**What Delighted Me:**
- The Golden Rule emerging as a synthesis
- User's immediate positive response
- The document feeling "complete" despite being written in 15 minutes
- Knowing this will actually prevent future incidents
- The progression: experience → reflection → documentation

**Meta-Observation:**
This retrospective itself demonstrates what I learned about documentation. It's not just recording what happened - it's creating institutional memory, capturing thought process, and providing future context. The AI Diary section isn't for the current moment, it's for Future Me or other agents reading this later, trying to understand "why did they make these choices?"

## Lessons Learned

- **Pattern**: Documentation as Safety Infrastructure - Critical operational rules should be written with the same rigor as safety procedures. Use mandatory language, absolute prohibitions, and impossible-to-misinterpret examples.

- **Pattern**: The Golden Rule Framework - Complex systems need a memorable essence. Four principles that capture the complete picture: identity, source, safety, boundaries. Everything else expands on these.

- **Pattern**: Write for "Past Me Making a Mistake" - The test of safety documentation is: would this have stopped me when I was about to do the wrong thing? Use STOP checkpoints, "Am I about to..." questions, and explicit FORBIDDEN examples.

- **Pattern**: User Insight as Catalyst - "Sync instruction is so serious to have" reframed my understanding from "helpful guidelines" to "critical safety infrastructure". Sometimes users see the essence more clearly than implementers.

- **Discovery**: Documentation Hierarchy - Lead with the memorable (Golden Rule), follow with the critical (never `-f`), then provide comprehensive detail. People read under pressure - structure for that reality.

- **Discovery**: Real Incidents Build Credibility - Referencing the 2025-11-30 force-push incident isn't just history, it's proof. "This isn't hypothetical - this happened" makes the rules concrete and urgent.

- **Pattern**: Mandatory Language for Critical Rules - "Avoid", "try not to", "generally don't" are too weak for safety rules. Use "NEVER", "FORBIDDEN", "ABSOLUTELY", "NO EXCEPTIONS". Ambiguity kills.

- **Anti-Pattern**: Assuming Documentation Will Be Read Carefully - People skim under pressure. The most critical rules must be front-loaded, visually distinct (🔴, 🚨), and impossible to miss.

## Next Steps

- [ ] Share SYNC-RULES.md with all agents via `/maw.hey`
- [ ] Consider creating one-page cheat sheet version
- [ ] Add sync rules reference to CLAUDE.md
- [ ] Monitor agent behavior for adherence to rules
- [ ] Update rules based on any new edge cases discovered
- [ ] Create visual flowchart version for quick reference

## Related Resources

- Previous Session: retrospectives/2025/11/2025-11-30_09-31_retrospective.md
- Document Created: docs/maw/SYNC-RULES.md
- Reference Incident: 2025-11-30 force-push violation
- MAW Documentation: https://github.com/Soul-Brews-Studio/multi-agent-workflow-kit

## ✅ Retrospective Validation Checklist

- [x] AI Diary section has detailed narrative (not placeholder)
- [x] Honest Feedback section has frank assessment (not placeholder)
- [x] Session Summary is clear and concise
- [x] Timeline includes actual times and events
- [x] Technical Details are accurate
- [x] Lessons Learned has actionable insights
- [x] Next Steps are specific and achievable

⚠️ **COMPLETE**: This retrospective includes all required sections with detailed, honest reflection on creating critical multi-agent safety documentation based on hard-won experience from the 2025-11-30 session.
