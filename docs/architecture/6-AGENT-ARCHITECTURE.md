# 6-Agent Architecture - Complete Implementation

**Status**: ✅ Fully Deployed
**Date**: 2025-12-07
**Configuration**: `.agents/agents.yaml`
**Worktrees**: Git-based (git worktree + branches agents/1-5)
**Sync Strategy**: Smart sync with git merge (agents) + file sync

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│ TIER 1: STRATEGIC (Agent 0)                                 │
│ You (Main Claude) - Orchestration Only                       │
│ • Think strategically                                        │
│ • Make decisions                                             │
│ • Send directives to Agent 1                                │
│ • Monitor progress                                           │
│ TOKEN COST: Minimal (decisions + thinking)                  │
└─────────────────────────────────────────────────────────────┘
         ↓ "Shadow, run /nnn"
┌─────────────────────────────────────────────────────────────┐
│ TIER 2: TACTICAL (Agent 1)                                  │
│ Shadow Claude - Execute Your Commands                        │
│ • Run / commands (/nnn, /plan, /analyze, /rrr)             │
│ • Execute workflows you assign                              │
│ • Post results to GitHub                                    │
│ • Fire signals on completion                                │
│ MODEL: Claude (you assigned)                                │
└─────────────────────────────────────────────────────────────┘
         ↓ via maw hey [agent] [request]
┌──────────────────────────────────────┬──────────────────────┐
│ TIER 3A: EXECUTION (Agents 2-3)      │ TIER 3B: SPECIALIST  │
│                                      │ (Agents 4-5)         │
│ • General task execution             │                      │
│ • Handle assigned work               │ Agent 4:             │
│ • Status tracking integration        │ • PocketBase DB ops  │
│ • Respond via inbox                  │ • Collection mgmt    │
│ • Can run in parallel                │ • API testing        │
│                                      │                      │
│ MODEL: Codex                         │ Agent 5:             │
│                                      │ • Research & web     │
│                                      │ • Documentation      │
│                                      │ • Pattern analysis   │
│                                      │                      │
│                                      │ MODEL: Codex         │
└──────────────────────────────────────┴──────────────────────┘
         ↑ Respond via inbox to Agent 0
```

---

## Agent Specifications

### Agent 1: Shadow Claude (Tactical Executor)
- **Branch**: `agents/1`
- **Worktree**: `agents/1/` (git worktree)
- **Model**: Claude
- **Role**: Execute your / commands
- **Responsibilities**:
  - Run speckit commands (/nnn, /plan, /analyze, /rrr)
  - Execute workflows you assign
  - Post results to GitHub issues
  - Fire signal on completion

### Agent 2: General Executor (Codex)
- **Branch**: `agents/2`
- **Worktree**: `agents/2/` (git worktree)
- **Model**: Codex
- **Role**: General execution
- **Responsibilities**:
  - Handle tasks via `maw hey 2 "request"`
  - Execute implementation work
  - Respond with results to inbox
  - Integrate status tracking

### Agent 3: General Executor (Codex)
- **Branch**: `agents/3`
- **Worktree**: `agents/3/` (git worktree)
- **Model**: Codex
- **Role**: General execution (parallel with Agent 2)
- **Responsibilities**:
  - Handle tasks via `maw hey 3 "request"`
  - Execute implementation work
  - Respond with results to inbox
  - Integrate status tracking

### Agent 4: PocketBase Specialist (Codex)
- **Branch**: `agents/4`
- **Worktree**: `agents/4/` (git worktree)
- **Model**: Codex
- **Specialty**: Database operations
- **Responsibilities**:
  - Create/modify collections
  - Execute CRUD operations
  - Test API endpoints
  - Monitor database health
  - See: `AGENT4_ROLE.md`

### Agent 5: Research Specialist (Codex)
- **Branch**: `agents/5`
- **Worktree**: `agents/5/` (git worktree)
- **Model**: Codex
- **Specialty**: Documentation & research
- **Responsibilities**:
  - Execute research requests
  - Web search for information
  - Analyze documentation
  - Provide findings & patterns
  - See: `AGENT5_ROLE.md`

---

## Communication Flows

### Agent 0 → Agent 1 (You to Shadow)
**Direct / Command Execution**
```bash
# You (Agent 0):
"Shadow, run /speckit.plan on issue #34 and post findings"

# Agent 1:
1. Receives directive
2. Runs: /speckit.plan #34
3. Posts results to GitHub issue
4. Fires signal: tmux send-signal -X agent1-complete
5. Waits for next directive
```

### Agent 0 → Agents 2-5 (via maw hey)
**Service Request Pattern**
```bash
# You (Agent 0):
maw hey 4 "Create agent_status collection with: id, agent_id, status, task_name, started_at, completed_at"

# Agent 4:
1. Receives via inbox
2. Creates collection via PocketBase API
3. Tests endpoints
4. Posts to inbox: "✅ Created agent_status collection. POST http://127.0.0.1:8090/api/collections/agent_status/records"
5. You see inbox notification

# Agent 0:
Gets result notification → decides next step
```

### Agents 2-5 → Agent 0 (Response via Inbox)
**Async Results**
```
Inbox:
  [Agent 4] ✅ Collection created - agent_status
  [Agent 5] ✅ Research complete - found 3 patterns
  [Agent 2] ✅ Task completed - tests passing
```

---

## Worktree Management

### Current Setup
```bash
$ git worktree list
/Users/nat/000-workshop-product-page           aded7d1 [main]
/Users/nat/000-workshop-product-page/agents/1  01190ed [agents/1]
/Users/nat/000-workshop-product-page/agents/2  f39322c [agents/2]
/Users/nat/000-workshop-product-page/agents/3  e161680 [agents/3]
/Users/nat/000-workshop-product-page/agents/4  aded7d1 [agents/4]
/Users/nat/000-workshop-product-page/agents/5  aded7d1 [agents/5]
```

### Creating New Agents
```bash
# Edit .agents/agents.yaml to add agent config
# Then use MAW script:
.agents/scripts/agents.sh create 6
.agents/scripts/agents.sh create 7
```

### Syncing Updates to Agents
```bash
# Git-based sync (merge main into agent branches):
.agents/scripts/sync.sh

# File-only sync (CLAUDE.md, AGENT*_ROLE.md):
.agents/scripts/sync.sh --files CLAUDE.md AGENT4_ROLE.md AGENT5_ROLE.md
```

---

## Key Principles

### 1. Token Efficiency
- **Agent 0** (You): Minimal consumption - decisions only, no implementation
- **Agent 1**: Executes your directives (you delegate command execution)
- **Agents 2-5**: Distributed execution (parallelizable work)
- **Result**: Main agent uses ~10% tokens vs. monolithic approach

### 2. Separation of Concerns
- **Strategic** (Agent 0): Thinking, decisions, direction
- **Tactical** (Agent 1): Command execution, workflow management
- **Operational** (Agents 2-5): Task execution, specializations
- **Result**: Clear boundaries, easier to understand & maintain

### 3. Service Request Pattern
- Agents don't execute directly for Agent 0
- Agents receive requests via `maw hey` → inbox system
- Agents post results back to inbox
- Creates audit trail + enables parallelization
- **Result**: Reusable, traceable, auditable operations

### 4. Specialization
- Agent 4: **Only** PocketBase operations
- Agent 5: **Only** research & documentation
- Agents 2-3: General execution (can parallelize)
- **Result**: Experts in their domains, focused context

### 5. Signal Latency
- File-based signals (<10ms latency)
- **vs.** polling (wastes tokens)
- **vs.** polling + wait (wastes user time)
- **Result**: Fast, efficient status updates

---

## Operating Patterns

### Pattern: Research Then Implement
```
1. Agent 0: "Agent 5, research PocketBase auth patterns"
2. Agent 5: Posts findings to inbox
3. Agent 0: Reviews findings
4. Agent 0: "Agent 4, implement auth based on [pattern]"
5. Agent 4: Implements + tests
6. Agent 0: Validates & decides next step
```

### Pattern: Parallel Execution
```
1. Agent 0: "Agents 2-3, run integration tests"
2. Agent 2: Runs tests (parallel)
3. Agent 3: Runs tests (parallel)
4. Both post results to inbox
5. Agent 0: Reviews results, makes decision
```

### Pattern: Specialist Consultation
```
1. Agent 0: "Agents 2-3 are blocked on database. Agent 4, help?"
2. Agent 4: Consults + provides guidance via inbox
3. Agents 2-3 unblocked
4. Execution continues
```

---

## Configuration Files

### `.agents/agents.yaml`
Defines all agents:
- Branch name
- Worktree path
- Model (claude, codex)
- Role (shadow, executor, specialist)
- Description
- Responsibilities

**Updated**: 2025-12-07 with full 6-agent config

### `CLAUDE.md`
Generic guidelines copied to all agents (via smart sync)
- Safety rules
- Git workflows
- Context management
- Development practices

**Synced to**: All agents via `.agents/scripts/sync.sh --files`

### `AGENT4_ROLE.md` / `AGENT5_ROLE.md`
Specialized role definitions for agents 4 & 5:
- Primary job description
- How they work (receive requests, respond via inbox)
- Specific responsibilities
- Tools they use
- Example workflows
- Communication style
- Safety rules

**Synced to**: All agents (so all understand roles)

---

## Usage Examples

### As Agent 0 (You)

**Direct Agent 1 (Shadow) Execution:**
```bash
# You think: "I need a plan for the next feature"
# You say to Shadow:
"Shadow, run /speckit.plan on the latest feature request issue"

# Shadow executes, posts to issue
# You review and say: "Good. Now analyze it with /speckit.analyze"
```

**Request Specialist Work:**
```bash
# You need database work
maw hey 4 "Create users collection with: id, email, password, created_at"

# (Agent 4 gets notification via inbox)
# Agent 4 creates collection, tests, responds with HTTP endpoints
# You see inbox notification: "✅ Collection created"
```

**Parallel Execution:**
```bash
# You need tests run
maw hey 2 "Run integration tests for payment module"
maw hey 3 "Run integration tests for auth module"

# Both run in parallel
# Both post results to inbox
# You review both results
```

---

## Deployment Checklist

- [x] Created agents/4 and agents/5 (git worktree)
- [x] Updated `.agents/agents.yaml` with 6-agent config
- [x] Created `AGENT4_ROLE.md` (PocketBase specialist)
- [x] Created `AGENT5_ROLE.md` (Research specialist)
- [x] Synced files to all agents (`CLAUDE.md`, role files)
- [x] Committed role definitions to main
- [ ] (Optional) Create tmux profile6.sh for 6-agent layout
- [ ] (Optional) Add agents 4-5 to monitoring dashboard
- [ ] (Optional) Document specialist request templates

---

## Future Enhancements

### Agent 6: Logging Specialist
```yaml
6:
  branch: agents/6
  worktree_path: agents/6
  model: codex
  role: specialist
  specialty: logging
  description: Centralized logging, metrics, error tracking
```

### Agent 7: Integration Specialist
```yaml
7:
  branch: agents/7
  worktree_path: agents/7
  model: codex
  role: specialist
  specialty: integration
  description: External integrations, webhooks, third-party APIs
```

---

## Related Documentation

- **Agent Status Tracking**: See `AGENT-STATUS-COMPLETE.md`
- **Implementation Guide**: See `IMPLEMENTATION-GUIDE.md`
- **Agent 4 Specialization**: See `AGENT4_ROLE.md`
- **Agent 5 Specialization**: See `AGENT5_ROLE.md`
- **Configuration**: `.agents/agents.yaml`

---

## Key Learnings

### What We Learned
1. **6-Agent Model > 3-Agent**: Specialization enables scaling
2. **Service Request Pattern**: Creating audit trail + parallelization
3. **Token Efficiency**: Agent 0 can be ultra-lightweight (10% consumption)
4. **File-Based Signals**: <10ms latency beats polling every time
5. **Git Worktrees**: Perfect for agent separation (branches + sandboxed work)

### What Worked Well
- MAW script automated worktree creation (no manual git)
- Smart sync with --files for quick distribution
- YAML configuration makes agent definitions clear
- Specialization reduces context load (Agent 4 = DB expert)

### What To Improve
- Monitoring dashboard for agent status visibility
- Tmux profile for easy 6-agent layout
- Template system for common requests
- Token usage tracking per agent

---

## Quick Reference Commands

```bash
# Agent management
.agents/scripts/agents.sh list              # Show all agents
.agents/scripts/agents.sh create 6          # Create new agent
.agents/scripts/agents.sh remove 6          # Remove agent

# Syncing
.agents/scripts/sync.sh                     # Git-based sync (all branches)
.agents/scripts/sync.sh --files CLAUDE.md   # File-only sync

# Communication
maw hey 4 "request"                         # Send to Agent 4
maw hey 2 "task description"                # Send to Agent 2

# Check status
maw status list                             # Show all agent status
maw status watch                            # Real-time monitoring
```

---

**Last Updated**: 2025-12-07
**Version**: 1.0.0
**Status**: ✅ Production Ready
