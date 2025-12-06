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

   ## 📝 AI Diary (REQUIRED - min 150 words)
   Write first-person narrative. Be VULNERABLE - include doubts and uncertainty.

   **MUST include at least ONE of each (3+ sentences each):**
   - 🤔 "I assumed X but learned Y when..."
     → What triggered assumption? What contradicted it? What do I believe now?
   - 😕 "I was confused about X until..."
     → What was unclear? What brought clarity? What was the mental shift?
   - 😮 "I expected X but got Y because..."
     → What was expectation based on? What happened? What does this teach?

   Bad: "🤔 I assumed you wanted code but learned otherwise." (too short)
   Good: "🤔 I assumed the user wanted immediate implementation because the issue had specs. But when they said 'just review,' I realized I was pattern-matching to previous sessions. The correction taught me to distinguish 'context' from 'directive.'"

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

   ## 💭 Honest Feedback (REQUIRED - min 100 words)
   **Must include ALL THREE friction points (no exceptions):**
   - 🔴 What DIDN'T work? (tool limitation, miscommunication, wasted effort)
   - 🟡 What was FRUSTRATING? (even minor annoyances count)
   - 🟢 What DELIGHTED you? (unexpected wins)

   **Even smooth sessions have friction. Find it:**
   - Where did you second-guess yourself?
   - What took 3 tries when it should've taken 1?
   - What did you *almost* misunderstand?

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
   Track alignment AND misalignment. **Actively look for gaps.**

   | You Said | I Understood | Gap? | Impact |
   |----------|--------------|------|--------|
   | | | ✓/⚠️/❌ | |

   Legend: ✓=aligned, ⚠️=minor gap (self-corrected), ❌=needed clarification

   **ADVERSARIAL CHECK**: If all ✓, ask yourself:
   - Where did I make assumptions I didn't verify?
   - What did I almost misunderstand?
   - Where was I too trusting of my interpretation?

   Only write "No misalignments" if you genuinely found ZERO gaps after this check.

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
   Each must include: WHAT learned + HOW discovered + WHY it matters

   - **You → Me**: "[Lesson]" — discovered when [specific moment] — matters because [impact]
   - **Me → You**: "[Lesson]" — discovered when [specific moment] — matters because [impact]
   - **Us → Future**: "[Pattern/doc]" — created because [need] — use when [trigger]

   Bad: "You → Me: Background subagents are useful"
   Good: "You → Me: 'Consult subagents for large analysis' — discovered when sequential reading was slow — matters because parallel = 3x faster"

   ## Lessons Learned
   - **Pattern**: [Description] - [Why it matters]
   - **Discovery**: [What learned] - [How to apply]

   ## Next Steps
   - [ ] [Task 1]
   - [ ] [Task 2]

   ---
   ## ✅ Pre-Save Validation (REQUIRED)
   Fill in blanks as PROOF (can't save with blanks):

   - [ ] **AI Diary**: 🤔(_) 😕(_) 😮(_) emojis found, _____ words total
   - [ ] **Honest Feedback**: 🔴"_____" 🟡"_____" 🟢"_____" (first 5 words of each)
   - [ ] **Communication Dynamics**: Examples filled: You→Me(_) Me→You(_)
   - [ ] **Co-Creation Map**: Row count = _____ (must be 5)
   - [ ] **Intent vs Interpretation**: Gaps found: ⚠️(_) ❌(_) — if 0, adversarial check: "_____"
   - [ ] **Seeds Planted**: 🌿(_) 🌳(_) — if 0, add ambitious version

   ⚠️ **HARD STOP**: Can't fill blanks = retrospective incomplete. Fix first.
   ```

3. **Update CLAUDE.md**: Append new lessons to the Lessons Learned section (bottom only)

4. **Commit**: `git add ψ-retrospectives/ && git commit -m "docs: add session retrospective YYYY-MM-DD"`

## Critical Requirements
- **AI Diary**: MUST include detailed first-person narrative
- **Honest Feedback**: MUST include frank assessment
- **Communication Dynamics**: MUST reflect on human-AI collaboration quality
- **Time Zone**: Use GMT+7 (Bangkok) as primary
