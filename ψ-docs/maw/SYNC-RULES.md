# Multi-Agent Sync Rules

**⚠️ CRITICAL: These rules prevent data loss and workflow corruption**

---

## 🎯 The Golden Rule (Read This First)

> **Know who you are (main or agent),
> sync from the right source (remote or local main),
> never force anything (`-f`),
> respect all boundaries (stay in your worktree).**

**If you remember only ONE thing, remember this:**

### 🔴 NEVER USE `-f` FLAG
```bash
# ❌ ABSOLUTELY FORBIDDEN
git push -f
git push --force
git checkout -f
git clean -f
git reset --hard (from agent worktree)

# These commands WILL destroy agent history and break the multi-agent workflow
```

**There is NO exception to this rule in multi-agent workflows.**

---

## Identity Check - ALWAYS FIRST

Before ANY git operation, verify your identity:

```bash
pwd                           # Where am I?
git branch --show-current     # Which branch am I on?
```

**You are either:**
- **Main Agent**: In project root (`/path/to/project`), on `main` branch
- **Agent 1/2/3**: In worktree (`/path/to/project/agents/N`), on `agents/N` branch

## Sync Rules by Identity

### Main Agent (Root, Main Branch)

**Pull from Remote ONLY**
```bash
# ✅ CORRECT
git pull --ff-only origin main

# ❌ NEVER
git pull origin agents/1
git pull origin agents/2
git pull origin agents/3
```

**Never Touch Agent Worktrees**
```bash
# ❌ FORBIDDEN
cd agents/1
cd agents/2
cd agents/3
rm -rf agents/*
git push --force origin agents/1
```

**Coordinate, Don't Control**
- Send tasks via `/maw.hey`
- Review PRs from agents
- Merge to main when ready
- Let agents sync themselves

### Agent 1/2/3 (Worktree, agents/N Branch)

**Merge from Local Main ONLY**
```bash
# ✅ CORRECT
git merge main

# ❌ NEVER
git pull origin main        # Wrong: skip local main
git merge origin/main       # Wrong: bypass local main
git rebase main             # Discouraged: can cause conflicts
```

**Push Your Own Branch**
```bash
# ✅ CORRECT
git push origin agents/1    # (or agents/2, agents/3)

# ❌ NEVER
git push origin main
git push --force origin agents/1
```

**🚨 CRITICAL: Stay in Your Worktree**

Each agent MUST stay in their assigned worktree. This is not a suggestion - it's a fundamental architectural requirement.

```bash
# ✅ CORRECT - Agent 1 working in their own space
cd ~/project/agents/1
pwd                        # /path/to/project/agents/1
git branch --show-current  # agents/1
# ... do your work here ...

# ❌ FORBIDDEN - Agent 1 crossing boundaries
cd ~/project/agents/2      # WRONG: entering Agent 2's domain
cd ~/project               # WRONG: entering main agent's domain
cd ../agents/3             # WRONG: entering Agent 3's domain
vim ../agents/2/file.txt   # WRONG: modifying other agent's files
git checkout agents/2      # WRONG: switching to other agent's branch
```

**Why this matters:**
- Each worktree is an independent workspace
- Crossing boundaries breaks the isolation model
- Other agents won't see your changes if you work in their space
- Git will get confused about which branch owns which changes
- You risk creating merge conflicts across worktrees

**The Rule:**
- Agent 1 works ONLY in `agents/1/`
- Agent 2 works ONLY in `agents/2/`
- Agent 3 works ONLY in `agents/3/`
- Main agent works ONLY in project root

**If you need to share work:**
- Commit in your own worktree
- Push to your branch: `git push origin agents/N`
- Create a PR
- Let main agent merge to main
- Other agents sync via `git merge main`

**Never** reach across worktree boundaries.

## 🔴 ABSOLUTE PROHIBITIONS

### 1. NEVER Use `-f` or `--force` Flags (MOST CRITICAL)

**This is the #1 rule. If you break this, you WILL cause data loss.**

```bash
# ❌ ABSOLUTELY FORBIDDEN - NO EXCEPTIONS
git push -f
git push --force
git push --force-with-lease    # Still dangerous in multi-agent context
git checkout -f
git clean -f
git clean -fd
git reset --hard
git reset --hard origin/main
git rebase --force-rebase

# ANY command with -f or --force is FORBIDDEN
```

**Why this is critical:**
- Each agent's history is intentionally independent
- Force operations destroy this independence permanently
- You will lose other agents' work
- You will break the multi-agent architecture
- Recovery is difficult or impossible

**Real example of damage:**
In the 2025-11-30 session, `git push --force` destroyed all three agents' independent histories, losing their work-in-progress commits and breaking the workflow.

**What to do instead:**
```bash
# If branches diverge
git merge main              # Merge, don't force
git checkout -b new-branch  # Create new branch
# Ask for help              # Don't guess with force

# If you have conflicts
git merge main              # Resolve conflicts properly
git add resolved-files
git commit -m "Resolve merge conflicts"

# If you're stuck
# STOP. ASK FOR HELP. DO NOT USE -f
```

**The rule is absolute: NO `-f` FLAG. EVER.**

### 2. NEVER Cross Worktree Boundaries (CRITICAL)

**Each agent MUST stay in their assigned worktree. Period.**

```bash
# ❌ FORBIDDEN - Crossing agent boundaries
cd agents/1 && git checkout agents/2  # WRONG: Agent switching branches
cd agents/2 && rm file.txt            # WRONG: Modifying other agent's files
cd ../agents/3                        # WRONG: Entering other worktree
vim ~/project/agents/2/file.txt       # WRONG: Editing from outside
git push origin agents/1:agents/2     # WRONG: Pushing to other agent's branch

# ❌ FORBIDDEN - Main agent entering agent worktrees
cd agents/1                           # WRONG: Main agent must stay in root
cd agents/2                           # WRONG: Main agent must stay in root
rm -rf agents/*                       # WRONG: Deleting agent worktrees

# ❌ FORBIDDEN - Agent entering other domains
cd ~/project                          # WRONG: Agent leaving their worktree
cd ../                                # WRONG: Agent going to root
```

**Why this is critical:**
- Each agent's worktree is their autonomous domain
- Crossing boundaries breaks the isolation model
- Git will get confused about which branch owns changes
- You'll create impossible-to-resolve merge conflicts
- Other agents won't see your changes

**The absolute rule:**
- **Agent 1**: Stay in `agents/1/` directory ONLY
- **Agent 2**: Stay in `agents/2/` directory ONLY
- **Agent 3**: Stay in `agents/3/` directory ONLY
- **Main agent**: Stay in project root ONLY, NEVER enter `agents/*`

**Before EVERY command, verify:**
```bash
pwd                        # Am I in the right place?
git branch --show-current  # Am I on the right branch?
```

### 3. NEVER Sync from Wrong Source

**The sync hierarchy is sacred: `origin/main` → `local main` → `agents/N`**

```bash
# ❌ FORBIDDEN - Main agent syncing from agent branches
git merge agents/1            # WRONG: Main should never merge agent branches directly
git pull origin agents/2      # WRONG: Main pulls from origin/main ONLY
git merge agents/3            # WRONG: Use PR workflow instead

# ❌ FORBIDDEN - Agent syncing from remote
git pull origin main          # WRONG: Agent should merge local main, not pull remote
git fetch origin main && git merge origin/main  # WRONG: Bypass local main
git rebase origin/main        # WRONG: Agents don't touch origin directly

# ❌ FORBIDDEN - Agent syncing from other agents
git merge agents/2            # WRONG: Agents don't merge other agents
git pull origin agents/3      # WRONG: Agents sync from main ONLY
```

**Why the hierarchy matters:**
- `origin/main` is the single source of truth
- `local main` is the sync point for all agents
- Each agent merges from `local main`, never from `origin` or other agents
- Skipping steps breaks the coordination flow
- You'll create divergent histories

**The correct sync pattern:**
```bash
# Main agent (in project root)
git pull --ff-only origin main     # Pull from remote

# Agent 1/2/3 (in their worktree)
git merge main                     # Merge from LOCAL main
```

**Never skip levels in the hierarchy.**

## Correct Sync Workflow

### Full Project Sync (Main Agent)

```bash
# 1. Verify identity
pwd                                    # Should show: /path/to/project
git branch --show-current              # Should show: main

# 2. Pull latest from remote
git pull --ff-only origin main

# 3. Notify all agents to sync
/maw.hey all "Main branch updated, please sync: git merge main"

# 4. Each agent (in their worktree) runs:
# git merge main
```

### Agent Receiving Updates

```bash
# 1. Verify identity
pwd                                    # Should show: /path/to/project/agents/1
git branch --show-current              # Should show: agents/1

# 2. Merge from local main
git merge main

# 3. Resolve conflicts if any
# (Never use --force to "resolve")

# 4. Continue work
```

### Agent Contributing Back

```bash
# 1. Commit your work
git add -A
git commit -m "feat: description"

# 2. Push to your branch
git push origin agents/1

# 3. Create PR
gh pr create --base main --head agents/1

# 4. Wait for main agent to review and merge
```

## Visual Sync Flow

```
┌─────────────┐
│ origin/main │  (GitHub remote)
└──────┬──────┘
       │ git pull --ff-only (Main Agent ONLY)
       ▼
┌─────────────┐
│ local main  │  (Shared .git database)
└──────┬──────┘
       │ git merge main (Agent 1/2/3 ONLY)
       ├─────────┬─────────┬─────────┐
       ▼         ▼         ▼         ▼
   ┌────────┐ ┌────────┐ ┌────────┐
   │agents/1│ │agents/2│ │agents/3│
   └────────┘ └────────┘ └────────┘
       │         │         │
       │ git push origin agents/N
       ▼         ▼         ▼
   ┌────────────────────────────┐
   │ origin/agents/1,2,3        │
   └────────────────────────────┘
             │
             │ gh pr create → merge
             ▼
       ┌─────────────┐
       │ origin/main │ (cycle continues)
       └─────────────┘
```

## Emergency Recovery

### If You Force-Pushed by Mistake

```bash
# 1. STOP immediately
# 2. Check reflog
git reflog agents/1

# 3. Find the commit BEFORE the force push
# 4. Reset to that commit (without --hard)
git reset abc1234

# 5. Create recovery branch
git checkout -b agents/1-recovery

# 6. Ask for help in project channel
```

### If Branches Are Hopelessly Diverged

```bash
# DON'T force push
# DON'T git reset --hard

# DO create a new branch
git checkout -b agents/1-new
git merge main
# Work from clean slate, cherry-pick what you need
```

### If You Modified Wrong Worktree

```bash
# 1. Stash changes
git stash

# 2. Go to correct worktree
cd ../agents/2  # (or wherever you should be)

# 3. Apply stash
git stash pop

# 4. Verify and commit in correct location
```

## 🚨 Pre-Operation Checklist (MANDATORY)

**Run this checklist before EVERY git operation. No exceptions.**

### Identity Verification (ALWAYS FIRST)
```bash
pwd                           # WHERE am I?
git branch --show-current     # WHICH branch am I on?
```

### Before ANY Command, Ask:
- [ ] **Am I in the right directory?**
  - Main agent → project root
  - Agent 1 → `agents/1/`
  - Agent 2 → `agents/2/`
  - Agent 3 → `agents/3/`

- [ ] **Am I on the right branch?**
  - Main agent → `main`
  - Agent 1 → `agents/1`
  - Agent 2 → `agents/2`
  - Agent 3 → `agents/3`

- [ ] **Am I using the correct sync source?**
  - Main agent → `origin/main` (remote)
  - Agent 1/2/3 → `main` (local)

- [ ] **🔴 STOP: Am I about to use `-f` or `--force`?**
  - If YES: **STOP IMMEDIATELY. DO NOT PROCEED.**
  - Ask for help instead
  - There is NO valid reason to use force in multi-agent workflows

- [ ] **Am I crossing worktree boundaries?**
  - Am I trying to `cd agents/*` from root?
  - Am I trying to `cd ../` from my worktree?
  - If YES: **STOP. Stay in your worktree.**

- [ ] **Am I about to modify another agent's files?**
  - If YES: **STOP. Use PR workflow instead.**

### If You Answer "YES" to Any STOP Item:
1. **Do not execute the command**
2. Step back and ask: "What am I trying to accomplish?"
3. Consult this guide for the correct approach
4. Ask for help if unsure
5. **NEVER guess with force operations or boundary crossing**

## Why This Matters

**Real Incident from 2025-11-30 Session:**

> Around 16:40, the main agent (me) misunderstood "merge to same commit" as needing
> to force-push all agent branches to match main. This violated the rule against force
> operations and destroyed the independent history of all three agent branches.
>
> **What was lost**: Each agent's work-in-progress commits, their independent evolution
> **What was learned**: Each agent's history is intentionally independent. The architecture
> depends on this independence. Force-syncing breaks the model.

## Summary: One Rule to Remember

**🎯 The Golden Rule of Multi-Agent Sync:**

> Know who you are (main or agent),
> sync from the right source (remote or local main),
> never force anything,
> respect all boundaries.

If you're ever unsure, ASK. Never guess with force operations.

---

**Last Updated**: 2025-12-01
**Incident Reference**: Session 2025-11-30 retrospective (force-push violation)
**Status**: MANDATORY for all agents
