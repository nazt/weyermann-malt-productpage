# Unimplemented Issues Audit - Complete Index

**Audit Date**: 2025-12-08 09:15 UTC  
**Analyst**: Claude Haiku (context-finder)  
**Status**: COMPLETE - Ready for action

---

## Quick Navigation

### For Decision Makers
Start here: **[ACTIONABLE-NEXT-STEPS.md](ACTIONABLE-NEXT-STEPS.md)** (5 min read)
- Quick wins for this week (3-4 hours)
- Copy-paste ready commands
- Decision matrices
- Success criteria

### For Project Managers
Full report: **[UNIMPLEMENTED-ISSUES-AUDIT.md](UNIMPLEMENTED-ISSUES-AUDIT.md)** (15 min read)
- Complete analysis with evidence
- Issue-by-issue breakdown
- Statistics and root causes
- Process improvement recommendations

### This File
Current document: **[AUDIT-INDEX.md](AUDIT-INDEX.md)** (this file)
- Quick reference and navigation
- Summary of key findings
- Links to detailed analysis

---

## Key Findings (TL;DR)

### The Good News
- **13 issues properly implemented** and closed with evidence
- Clear, actionable ideas for improvement
- Repository has strong momentum (60+ commits in recent history)

### The Problem
- **12 high-value ideas closed without implementation** during "clearing backlog" bulk cleanup on 2025-12-08
- **20% false positive rate** on orphan detection (issues marked "0 references" with 5+ commits)
- Mixed status in bulk closures makes it impossible to know: "feature done?" vs "feature shelved?"

### The Opportunity
- **Top 3 issues can be revived in 6-9 hours** with high user value
- **Book-writer (#54)** solves documented problem (retrospectives too long)
- **Archiver fix (#43)** prevents future false positives (tool in daily use)
- **Inbox system (#28)** removes critical blocker for multi-agent work

---

## By The Numbers

| Metric | Value |
|--------|-------|
| Issues Analyzed | 30 |
| Properly Implemented | 13 (43%) |
| Unimplemented/Shelved | 12 (40%) |
| Superseded | 5 (17%) |
| Deprecated | 3 (10%) |
| False Positives | 20% |
| High-Value Shelved | 12 |
| Quick-Win Hours | 6-9 |

---

## Top 3 Unimplemented Ideas Worth Reviving

### #54: book-writer subagent
- **Problem**: Retrospectives average 2000+ words, leaders need 2-minute summaries
- **Solution**: Auto-summarize → bullet-point reviews
- **Effort**: 2-3 hours
- **Value**: HIGH - User need confirmed
- **Status**: Closed 2025-12-08 as "0 references" (WRONG)
- **Action**: See ACTIONABLE-NEXT-STEPS.md line 19

### #43: Improve Archiver Subagent Prompt
- **Problem**: Archiver marks implemented features as orphaned (20% false positive rate)
- **Examples**: #50, #39, #34 all have 5+ commits but marked "0 references"
- **Solution**: Check git log when evaluating orphan status
- **Effort**: 1-2 hours
- **Value**: HIGH - Tool in daily use
- **Status**: Closed 2025-12-08, root cause identified
- **Action**: See ACTIONABLE-NEXT-STEPS.md line 40

### #28: Central Inbox for Multi-Agent Communication
- **Problem**: Agents use slow file signals + fragile tmux for communication
- **Solution**: Unified pubsub system (file-based or PocketBase)
- **Effort**: 3-4 hours
- **Value**: HIGH - Critical blocker
- **Status**: Closed 2025-12-08 as "Clearing backlog"
- **Action**: See ACTIONABLE-NEXT-STEPS.md line 65

---

## Critical Audit Findings

### Finding 1: False Orphaned Marking (20% Error Rate)

**What Happened**:
Issues marked "Cleanup: 0 references found" actually have implementation commits.

**Examples**:
- `#50` context-finder: 5 commits (de1a838, b23bae4, 233f72f, 3ac3980, 71cc1b1)
- `#39` 6-agent tmux: 8 commits (eee5436, 06f6ff4, 527916c, d809e0b, a19c4b9...)
- `#34` Agent tracking: 5 commits (bb3c071, 92b280a, 85163cc, 11a7660...)

**Root Cause**:
Issues-cleanup subagent only checks title mentions, not git commit log.

**Impact**:
4-6 high-value features incorrectly marked unused and closed.

**Solution**:
Update archiver to check: issue mentions + git commits + PR references.

---

### Finding 2: Bulk Backlog Closures Create Confusion

**What Happened**:
6+ issues closed same timestamp with identical vague reason: "Clearing MAW backlog"

**Examples**:
- `#64` (implemented): "Closing: MAW-related"
- `#23` (shelved): "Closing: MAW-related"
- Both have same reason → impossible to know status

**Impact**:
Lost distinction between "feature done" and "feature shelved".

**Solution**:
Use specific close reasons: "Implemented in ABC123" / "Superseded by #X" / "Shelved: will revisit Q1"

---

### Finding 3: Supersession Context Lost

**What Happened**:
When `#2` → `#3` → both deprecated, no trail showing why original abandoned.

**Impact**:
Future developers can't see: "we tried this, learned X, then pivoted to Y"

**Solution**:
Add explicit links in issue body: "Original: #2 | Evolved: #3 | Status: Deprecated"

---

## Process Recommendations

### Immediate (This Week)

- [ ] Reopen #50, #39, #34 (misclassified as orphaned)
- [ ] Start #54 implementation (book-writer)
- [ ] Fix #43 (archiver precision)
- [ ] Create "shelved" GitHub label
- [ ] Update issue close standards documentation

### Medium-term (This Month)

- [ ] Implement #28 (inbox system)
- [ ] Implement #18 (retrospective feedback)
- [ ] Verify archiver false positives eliminated
- [ ] Audit remaining closed issues for accuracy

### Long-term (Standards)

- [ ] Never bulk-close with vague reason
- [ ] Always check git log before declaring "orphaned"
- [ ] Link superseded issues explicitly
- [ ] Create shelved/unimplemented distinction

---

## Document Map

### In This Repository

| File | Purpose | Size | Read Time |
|------|---------|------|-----------|
| **UNIMPLEMENTED-ISSUES-AUDIT.md** | Complete analysis with evidence | 373 lines | 15 min |
| **ACTIONABLE-NEXT-STEPS.md** | Quick reference for implementation | 263 lines | 5 min |
| **AUDIT-INDEX.md** | This file - navigation and summary | ~150 lines | 5 min |

### How to Use These Files

1. **Start with ACTIONABLE-NEXT-STEPS.md** (5 min)
   - Get overview and immediate actions
   - Review decision matrix
   - Copy-paste commands

2. **Read UNIMPLEMENTED-ISSUES-AUDIT.md** (15 min)
   - Understand full context and evidence
   - Learn about process problems
   - See detailed recommendations

3. **Reference AUDIT-INDEX.md** (this file, as needed)
   - Quick navigation
   - Key findings summary
   - Document map

---

## Implementation Checklist

### This Week (6-9 hours commitment)

```
☐ Step 1: Reopen Misclassified Issues (5 min)
  └─ gh issue reopen 50 39 34

☐ Step 2: Review ACTIONABLE-NEXT-STEPS.md (5 min)
  └─ Understand immediate action items

☐ Step 3: Implement #54 book-writer (2-3 hours)
  └─ Auto-summarize retrospectives
  └─ See ACTIONABLE-NEXT-STEPS.md line 19

☐ Step 4: Fix #43 archiver (1-2 hours)
  └─ Add git log reference checking
  └─ See ACTIONABLE-NEXT-STEPS.md line 40

☐ Step 5: Update Standards (1 hour)
  └─ Create "shelved" label
  └─ Document close reason standards
  └─ Add supersession link guidelines
```

### This Month (10-15 hours additional)

```
☐ Implement #28 inbox system (3-4 hours)
☐ Implement #18 retrospective feedback (4-5 hours)
☐ Verify archiver improvements working (1 hour)
☐ Review and audit other closed issues (2-3 hours)
```

---

## FAQ

**Q: Why reopen already-closed issues?**  
A: They were closed incorrectly. #50, #39, #34 have implementation commits but were marked "0 references" due to archiver bug.

**Q: Is #54 really needed?**  
A: Yes. User feedback across 5+ retrospectives shows "too long" problem. 2000+ words → 2-minute summary would be high value.

**Q: How serious is the 20% false positive rate?**  
A: Serious for trust. When archiver marks working features as unused, people stop trusting the tool. Needs immediate fix.

**Q: Should we implement all 12 unimplemented issues?**  
A: No. Focus on top 3 first (6-9 hours). Then assess medium-value ones this month. Aspirational features go to Q1 2025.

**Q: What about the 3 deprecated issues?**  
A: Leave them closed. Project pivoted from product catalog → MAW platform. That was intentional and correct.

---

## Contact & Attribution

**Analysis Performed By**:  
Claude Haiku (context-finder subagent)

**Analysis Date**:  
2025-12-08 09:15 UTC

**Repository**:  
/Users/nat/000-workshop-product-page

**Next Review**:  
After implementing top 3 issues (estimated 2025-12-15)

---

## Quick Links

- **GitHub Issues**: https://github.com/nazt/000-workshop-product-page/issues
- **Commits Referenced**: git log --all --oneline
- **Retrospectives**: `ψ-retrospectives/` directory
- **Learnings**: `ψ-learnings/` directory

---

**Status**: AUDIT COMPLETE - READY FOR ACTION ✓

Next step: Read ACTIONABLE-NEXT-STEPS.md
