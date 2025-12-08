# Marie Kondo Cleanup Plan - Codebase Organization

**Generated**: 2025-12-08
**Status**: Ready for Review & Execution
**Scope**: Root directory files, docs/, and overall structure

---

## Executive Summary

**Current State**: 18 markdown files in root, creating clutter and confusion
**Goal**: Clean, organized structure where every file has a clear home
**Impact**: Better navigation, clearer purpose, reduced cognitive load

---

## Classification System

### Does it spark joy?
- **KEEP**: Essential, actively used, proper location
- **MOVE**: Useful but in wrong location
- **DELETE**: Outdated, superseded, or test file
- **ARCHIVE**: Historical value but not current

---

## Part 1: Root Directory Files (18 files analyzed)

### 🗑️ DELETE (6 files)

| File | Why Delete | Evidence |
|------|-----------|----------|
| **README-test.md** | Test file (2 words) | Created Dec 1, contains only "# Test Update" |
| **test-main.txt** | Test file (1 line) | Contains "test file from main agent" |
| **MAW-AGENTS.md** | Superseded | Basic notes, replaced by comprehensive docs |
| **TMUX-LAYOUT-PREVIEW.md** | Completed preview | Was for issue #36, now in TMUX-LAYOUT-COMPARISON.md |
| **ACTIONABLE-NEXT-STEPS.md** | Temporary audit report | Created for Dec 8 cleanup, now archived in AUDIT-INDEX.md |
| **UNIMPLEMENTED-ISSUES-AUDIT.md** | Temporary audit report | Created for Dec 8 cleanup, reference in AUDIT-INDEX.md |

**Reason**: These are either test files, temporary working documents, or superseded by better versions.

---

### 📦 ARCHIVE (4 files to ψ-archive/)

Move to `/Users/nat/000-workshop-product-page/ψ-archive/2025-12-expansion/`

| File | New Location | Purpose |
|------|-------------|---------|
| **EXPANSION-SUMMARY.md** | `ψ-archive/2025-12-expansion/` | Historical: 6-agent expansion summary (Dec 7) |
| **AGENT-STATUS-COMPLETE.md** | `ψ-archive/2025-12-expansion/` | Historical: Agent status tracking implementation |
| **IMPLEMENTATION-GUIDE.md** | `ψ-archive/2025-12-expansion/` | Historical: PocketBase setup guide (now stable) |
| **AUDIT-INDEX.md** | `ψ-archive/2025-12-cleanup/` | Historical: Issues audit index (Dec 8 cleanup) |

**Reason**: These document completed work and should be preserved for reference, but not clutter the root.

---

### 📁 MOVE to docs/ (5 files)

Move to `/Users/nat/000-workshop-product-page/docs/architecture/`

| File | New Location | Purpose |
|------|-------------|---------|
| **6-AGENT-ARCHITECTURE.md** | `docs/architecture/` | Current: Complete 6-agent architecture documentation |
| **6-AGENTS-QUICKSTART.md** | `docs/architecture/` | Current: Quick start guide for 6-agent system |
| **AGENT4_ROLE.md** | `docs/architecture/roles/` | Current: Agent 4 role definition |
| **AGENT5_ROLE.md** | `docs/architecture/roles/` | Current: Agent 5 role definition |
| **TMUX-LAYOUT-COMPARISON.md** | `docs/architecture/` | Current: TMux layout comparison (profiles 6-9) |

**Reason**: These are architecture documentation that should be in a dedicated docs folder.

---

### ✅ KEEP in Root (3 files)

| File | Why Keep Here | Purpose |
|------|--------------|---------|
| **CLAUDE.md** | AI instructions (must be root) | Primary AI guidelines, checked into codebase |
| **README.md** | Standard location | Project overview, entry point |
| **AGENTS.md** | Active reference | Multi-agent workflow instructions |

**Reason**: These are essential reference files that agents and developers need quick access to.

---

### 🤔 SPECIAL CASE (2 files)

| File | Current Use | Recommendation |
|------|------------|----------------|
| **spec.md** | Generic "Agent Status Tracking System" spec | MOVE to `docs/architecture/specs/agent-status-spec.md` |
| **products.json** | Original project data (deprecated) | ARCHIVE to `ψ-archive/original-project/` |

**Reason**:
- `spec.md` is too generic a name and relates to archived work
- `products.json` is from the original (deprecated) product catalog project

---

## Part 2: Directory Structure Analysis

### Current Structure Issues

```
Root (18 markdown files) ← TOO MANY FILES
├── docs/ (6 files) ← Good but limited
├── ψ-docs/ (9 files) ← Good organization
├── ψ-learnings/ (many) ← Good
├── ψ-retrospectives/ (many) ← Good
└── agents/ (worktrees) ← Good
```

### Proposed Structure

```
Root (3 essential files only)
├── CLAUDE.md ← AI guidelines
├── README.md ← Project overview
├── AGENTS.md ← Agent instructions
│
├── docs/
│   ├── architecture/
│   │   ├── 6-AGENT-ARCHITECTURE.md
│   │   ├── 6-AGENTS-QUICKSTART.md
│   │   ├── TMUX-LAYOUT-COMPARISON.md
│   │   ├── roles/
│   │   │   ├── AGENT4_ROLE.md
│   │   │   └── AGENT5_ROLE.md
│   │   └── specs/
│   │       └── agent-status-spec.md
│   ├── INBOX-MONITORING.md (already here)
│   ├── MAW-DIRECT-USAGE.md (already here)
│   ├── MAW-SUBSHELL-FIX.md (already here)
│   ├── MAW-WRAPPER.md (already here)
│   ├── MULTI-AGENT-INSTRUCTIONS.md (already here)
│   └── POCKETBASE-INBOX.md (already here)
│
├── ψ-docs/ (unchanged - well organized)
├── ψ-learnings/ (unchanged)
├── ψ-retrospectives/ (unchanged)
│
└── ψ-archive/
    ├── 2025-12-expansion/
    │   ├── EXPANSION-SUMMARY.md
    │   ├── AGENT-STATUS-COMPLETE.md
    │   └── IMPLEMENTATION-GUIDE.md
    ├── 2025-12-cleanup/
    │   └── AUDIT-INDEX.md
    └── original-project/
        └── products.json
```

---

## Part 3: Detailed Action Plan

### Phase 1: Create Directories (SAFE)

```bash
# Create new structure
mkdir -p docs/architecture/roles
mkdir -p docs/architecture/specs
mkdir -p ψ-archive/2025-12-expansion
mkdir -p ψ-archive/2025-12-cleanup
mkdir -p ψ-archive/original-project
```

### Phase 2: Move Files (REVERSIBLE)

```bash
# Move architecture docs
git mv 6-AGENT-ARCHITECTURE.md docs/architecture/
git mv 6-AGENTS-QUICKSTART.md docs/architecture/
git mv TMUX-LAYOUT-COMPARISON.md docs/architecture/
git mv AGENT4_ROLE.md docs/architecture/roles/
git mv AGENT5_ROLE.md docs/architecture/roles/

# Move spec
git mv spec.md docs/architecture/specs/agent-status-spec.md

# Archive historical docs
git mv EXPANSION-SUMMARY.md ψ-archive/2025-12-expansion/
git mv AGENT-STATUS-COMPLETE.md ψ-archive/2025-12-expansion/
git mv IMPLEMENTATION-GUIDE.md ψ-archive/2025-12-expansion/
git mv AUDIT-INDEX.md ψ-archive/2025-12-cleanup/
git mv products.json ψ-archive/original-project/

# Archive layout preview (merged into comparison)
git mv TMUX-LAYOUT-PREVIEW.md ψ-archive/2025-12-expansion/
```

### Phase 3: Delete Test Files (PERMANENT)

```bash
# Delete test files
git rm README-test.md
git rm test-main.txt
git rm MAW-AGENTS.md

# Delete temporary audit reports (content preserved in AUDIT-INDEX.md)
git rm ACTIONABLE-NEXT-STEPS.md
git rm UNIMPLEMENTED-ISSUES-AUDIT.md
```

### Phase 4: Update References

Files that reference moved documents need updating:

**Update CLAUDE.md**:
- Change references to architecture files to point to `docs/architecture/`
- Update AGENT4_ROLE.md path to `docs/architecture/roles/AGENT4_ROLE.md`
- Update AGENT5_ROLE.md path to `docs/architecture/roles/AGENT5_ROLE.md`

**Update README.md**:
- Update links to moved documentation

**Update .agents/scripts/sync.sh**:
- Update paths to AGENT4_ROLE.md and AGENT5_ROLE.md if referenced

### Phase 5: Commit & Verify

```bash
# Stage all changes
git add -A

# Commit with descriptive message
git commit -m "refactor: Marie Kondo cleanup - organize root directory

- Move: Architecture docs → docs/architecture/
- Move: Role definitions → docs/architecture/roles/
- Move: Spec → docs/architecture/specs/
- Archive: Historical docs → ψ-archive/2025-12-expansion/
- Archive: Audit reports → ψ-archive/2025-12-cleanup/
- Archive: Original project data → ψ-archive/original-project/
- Delete: Test files (README-test.md, test-main.txt, MAW-AGENTS.md)
- Delete: Temporary audit reports (preserved in AUDIT-INDEX.md)

Result: 18 → 3 files in root (CLAUDE.md, README.md, AGENTS.md)
"
```

---

## Part 4: Benefits Analysis

### Before Cleanup

**Root Directory**: 21 files total
- 18 markdown files
- 3 core files lost in noise
- Hard to find what you need
- Unclear what's current vs historical

### After Cleanup

**Root Directory**: 3 essential files only
- CLAUDE.md (AI guidelines)
- README.md (project overview)
- AGENTS.md (agent instructions)

**Benefits**:
1. **Clarity**: Immediately see the 3 most important files
2. **Organization**: Architecture docs grouped logically
3. **History Preserved**: Nothing lost, just organized
4. **Easier Navigation**: docs/architecture/ is intuitive
5. **Reduced Cognitive Load**: Less scanning, more doing

---

## Part 5: Safety Checks

### Before Executing

- [ ] All file contents read and understood
- [ ] No file contains unique unreferenced information
- [ ] Archive locations create proper history trail
- [ ] Git operations use safe commands (no -f flags)
- [ ] References in other files identified

### Rollback Plan

If needed, reverse with:
```bash
# Undo last commit (keeps files)
git reset --soft HEAD^

# Or restore specific file
git checkout HEAD^ path/to/file.md
```

---

## Part 6: Post-Cleanup Verification

### Checklist

After cleanup, verify:

- [ ] Root has exactly 3 .md files (CLAUDE.md, README.md, AGENTS.md)
- [ ] docs/architecture/ contains all architecture docs
- [ ] docs/architecture/roles/ contains both role definitions
- [ ] ψ-archive/ directories created and populated
- [ ] All git mv operations successful (no broken links)
- [ ] CLAUDE.md paths updated
- [ ] README.md links working
- [ ] Agent sync scripts still work

### Test Commands

```bash
# Verify structure
ls *.md | wc -l  # Should be 3
ls docs/architecture/*.md | wc -l  # Should be 4
ls docs/architecture/roles/*.md | wc -l  # Should be 2
ls ψ-archive/2025-12-expansion/*.md | wc -l  # Should be 4

# Test agent sync still works
.agents/scripts/sync.sh --files CLAUDE.md AGENTS.md

# Verify no broken git references
git status
```

---

## Part 7: Execution Summary

### Files to Delete (6)
- README-test.md
- test-main.txt
- MAW-AGENTS.md
- TMUX-LAYOUT-PREVIEW.md
- ACTIONABLE-NEXT-STEPS.md
- UNIMPLEMENTED-ISSUES-AUDIT.md

### Files to Archive (5)
- EXPANSION-SUMMARY.md → ψ-archive/2025-12-expansion/
- AGENT-STATUS-COMPLETE.md → ψ-archive/2025-12-expansion/
- IMPLEMENTATION-GUIDE.md → ψ-archive/2025-12-expansion/
- AUDIT-INDEX.md → ψ-archive/2025-12-cleanup/
- products.json → ψ-archive/original-project/

### Files to Move (6)
- 6-AGENT-ARCHITECTURE.md → docs/architecture/
- 6-AGENTS-QUICKSTART.md → docs/architecture/
- TMUX-LAYOUT-COMPARISON.md → docs/architecture/
- AGENT4_ROLE.md → docs/architecture/roles/
- AGENT5_ROLE.md → docs/architecture/roles/
- spec.md → docs/architecture/specs/agent-status-spec.md

### Files to Keep in Root (3)
- CLAUDE.md
- README.md
- AGENTS.md

---

## Part 8: One-Command Execution

```bash
#!/bin/bash
# cleanup.sh - Execute Marie Kondo cleanup plan

set -e  # Exit on error

echo "🧹 Marie Kondo Cleanup - Starting..."

# Phase 1: Create directories
echo "📁 Creating directory structure..."
mkdir -p docs/architecture/roles
mkdir -p docs/architecture/specs
mkdir -p ψ-archive/2025-12-expansion
mkdir -p ψ-archive/2025-12-cleanup
mkdir -p ψ-archive/original-project

# Phase 2: Move architecture docs
echo "📦 Moving architecture documentation..."
git mv 6-AGENT-ARCHITECTURE.md docs/architecture/
git mv 6-AGENTS-QUICKSTART.md docs/architecture/
git mv TMUX-LAYOUT-COMPARISON.md docs/architecture/
git mv AGENT4_ROLE.md docs/architecture/roles/
git mv AGENT5_ROLE.md docs/architecture/roles/
git mv spec.md docs/architecture/specs/agent-status-spec.md

# Phase 3: Archive historical docs
echo "📚 Archiving historical documentation..."
git mv EXPANSION-SUMMARY.md ψ-archive/2025-12-expansion/
git mv AGENT-STATUS-COMPLETE.md ψ-archive/2025-12-expansion/
git mv IMPLEMENTATION-GUIDE.md ψ-archive/2025-12-expansion/
git mv TMUX-LAYOUT-PREVIEW.md ψ-archive/2025-12-expansion/
git mv AUDIT-INDEX.md ψ-archive/2025-12-cleanup/
git mv products.json ψ-archive/original-project/

# Phase 4: Delete test/temp files
echo "🗑️  Removing test and temporary files..."
git rm README-test.md
git rm test-main.txt
git rm MAW-AGENTS.md
git rm ACTIONABLE-NEXT-STEPS.md
git rm UNIMPLEMENTED-ISSUES-AUDIT.md

# Verify result
echo "✅ Cleanup complete!"
echo ""
echo "Root directory now contains:"
ls -1 *.md

echo ""
echo "Run 'git status' to review changes before committing."
```

---

## Recommendation

**Execute this cleanup plan** to:
1. Reduce root clutter from 18 → 3 markdown files
2. Create logical documentation structure
3. Preserve all historical content in archives
4. Make the repository easier to navigate

**Next steps**:
1. Review this plan
2. Execute cleanup.sh (or manual commands)
3. Update references in CLAUDE.md
4. Commit with provided message
5. Verify with post-cleanup checklist

---

**Generated**: 2025-12-08
**Total Impact**: 18 files reorganized, 6 deleted, root reduced to 3 essential files
**Risk Level**: LOW (all operations reversible, nothing lost)
**Estimated Time**: 15 minutes
