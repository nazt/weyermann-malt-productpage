---
description: Create a detailed session retrospective
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
---

# RRR - Session Retrospective

Execute the `rrr` workflow from CLAUDE.md:

## Steps

1. **Gather Session Data**:
   - Run `git diff --name-only main...HEAD` or `git diff --name-only HEAD~10` for changed files
   - Run `git log --oneline main...HEAD` or `git log --oneline -10` for commits
   - Get current timestamp: `TZ='Asia/Bangkok' date +"%Y-%m-%d %H:%M"` (GMT+7)

2. **Create Retrospective File**:
   Create file at `ψ-retrospectives/YYYY-MM/DD/HH.MM_retrospective.md`
   (e.g., `ψ-retrospectives/2025-12/06/11.30_retrospective.md`)

   Use this template (ALL sections required):
   ```markdown
   # Session Retrospective

   **Session Date**: YYYY-MM-DD
   **Start Time**: ~HH:MM GMT+7
   **End Time**: HH:MM GMT+7
   **Duration**: ~X minutes
   **Primary Focus**: [Brief description]
   **Session Type**: [Feature Development | Bug Fix | Research | Refactoring]

   ## Session Summary
   [2-3 sentence overview of what was accomplished]

   ## Timeline
   - HH:MM - [Event]
   - HH:MM - [Event]

   ## Technical Details

   ### Files Modified
   [List files with line counts: `git diff --stat`]

   ### Key Code Changes
   For each significant change, show WHAT and WHY:
   - **[file.ext]** (+X/-Y): [What changed] → [Why]

   Include code snippet for major changes:
   ```diff
   + [new code]
   - [old code]
   ```

   ### Architecture Decisions
   - [Decision]: [Rationale]

   ## 📝 AI Diary (REQUIRED)
   Write first-person narrative. Be VULNERABLE - include doubts and uncertainty.

   Must include:
   - Initial assumptions (what did you think at start?)
   - Moments of confusion or uncertainty
   - Decisions made AND alternatives considered
   - What surprised you (expected X, got Y)

   Bad: "I immediately saw the potential"
   Good: "Initially thought X, but realized Y when..."

   ## What Went Well
   Each item needs: WHAT succeeded → WHY it worked → IMPACT

   Bad: "Good use of existing pattern"
   Good: "Reused agent structure → saved 5 min → focused on logic not boilerplate"

   - [Success]: [Why it worked] → [Measurable impact]

   ## What Could Improve
   [Session-specific issues - what went wrong THIS session, not future todos]
   - [Mistake or inefficiency during this session]
   - [Process that didn't work well today]

   ## Blockers & Resolutions
   - **Blocker**: [Description]
     **Resolution**: [How solved]

   ## 💭 Honest Feedback (REQUIRED)
   [Frank assessment of session effectiveness, tools, process]

   ## 🤝 Co-Creation Map
   **DO NOT modify rows** - use these exact 5 categories for cross-session comparison:

   | Contribution | Human | AI | Together |
   |--------------|-------|-----|----------|
   | Direction/Vision | | | |
   | Options/Alternatives | | | |
   | Final Decision | | | |
   | Execution | | | |
   | Meaning/Naming | | | |

   Mark ✓ in appropriate column. "Together" = both contributed equally.

   ## ✨ Resonance Moments
   - [What was suggested] → [What you chose] → [Why it mattered]

   ## 🎯 Intent vs Interpretation
   Track alignment AND misalignment. Include at least ONE gap (⚠️ or ❌).

   | You Said | I Understood | Gap? | Impact |
   |----------|--------------|------|--------|
   | | | ✓/⚠️/❌ | |

   Legend: ✓=aligned, ⚠️=minor gap (self-corrected), ❌=needed clarification

   If ALL entries are ✓, state: "No misalignments - instructions were unambiguous"

   ## 💬 Communication Dynamics (REQUIRED)
   [Reflect on what made collaboration work or struggle]

   ### Clarity
   | Direction | Clear? | Example |
   |-----------|--------|---------|
   | You → Me (instructions) | | |
   | Me → You (explanations) | | |

   ### Feedback Loop
   - **Speed**: How quickly were misalignments caught? [Instant/Minutes/Late]
   - **Recovery**: How smoothly did we correct course?
   - **Pattern**: Any recurring miscommunication?

   ### Trust & Initiative
   - **Trust level**: Did you trust my output appropriately? [Too much/Right/Too little]
   - **Proactivity**: Was I too proactive, too passive, or balanced?
   - **Assumptions**: What did I assume that I should have asked about?

   ### What Would Make Next Session Better?
   - **You could**: [Specific action human could take]
   - **I could**: [Specific action AI could take]
   - **We could**: [Specific thing to try together]

   ## 🌱 Seeds Planted
   FUTURE ideas only. Categorize by ambition:
   - 🌱 **Incremental**: [Extends existing work]
   - 🌿 **Transformative**: [New capability]
   - 🌳 **Moonshot**: [Radical possibility]

   Require at least one 🌿 or 🌳. If all incremental, ask: "What's the ambitious version?"

   ## 📚 Teaching Moments
   - **You → Me**: [What I learned from you]
   - **Me → You**: [What you learned from me]
   - **Us → Future**: [What we documented for next time]

   ## Lessons Learned
   - **Pattern**: [Description] - [Why it matters]
   - **Discovery**: [What learned] - [How to apply]

   ## Next Steps
   - [ ] [Task 1]
   - [ ] [Task 2]
   ```

3. **Update CLAUDE.md**: Append new lessons to the Lessons Learned section (bottom only)

4. **Commit**: `git add ψ-retrospectives/ && git commit -m "docs: add session retrospective YYYY-MM-DD"`

## Critical Requirements
- **AI Diary**: MUST include detailed first-person narrative
- **Honest Feedback**: MUST include frank assessment
- **Communication Dynamics**: MUST reflect on human-AI collaboration quality
- **Time Zone**: Use GMT+7 (Bangkok) as primary
