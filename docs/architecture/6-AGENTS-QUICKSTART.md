# 6-Agent Architecture - Quick Start

**Status**: ✅ Fully Deployed
**Agents**: 1-5 (6 total with Agent 0 = You)
**Layout**: Horizontal (profile6) or Grid (profile6-grid, coming soon)

---

## Start Agents in TMux

```bash
# Start 6 agents in horizontal layout (all agents in row)
.agents/scripts/start-agents.sh profile6

# Or use grid layout (when ready)
.agents/scripts/start-agents.sh profile6-grid
```

---

## Communication Patterns

### 1. Direct to Agent 1 (Shadow Claude)
```bash
# You want Agent 1 to execute a command:
maw hey 1 "/nnn to create implementation plan"
maw hey 1 "/speckit.analyze issue #34"
```

**Agent 1 does**: Runs your / commands and posts results to GitHub

### 2. Request to Specialists (Agents 2-5)

**To Agent 4 (PocketBase Specialist)**:
```bash
maw hey 4 "Create agents collection with: id, name, status fields"
maw hey 4 "Query all agents with status=working"
maw hey 4 "Test API endpoint /api/collections/agents/records"
```

**To Agent 5 (Research Specialist)**:
```bash
maw hey 5 "Research best practices for database migration"
maw hey 5 "Analyze authentication patterns in modern systems"
maw hey 5 "Find examples of 6-agent architectures"
```

**To Agents 2-3 (General Executors)**:
```bash
maw hey 2 "Run integration tests for payment module"
maw hey 3 "Build and push Docker container"
```

---

## Architecture at a Glance

```
YOU (Agent 0)
  ├─ Think strategically
  ├─ Make decisions
  └─ Send directives
      ↓
  Agent 1 (Shadow Claude)
      ├─ Executes / commands
      ├─ Posts to GitHub
      └─ Signals when done

  Agents 2-3 (General Executors)
      ├─ Handle assigned tasks
      ├─ Respond via inbox
      └─ Can run in parallel

  Agent 4 (PocketBase Specialist)
      ├─ Create/modify collections
      ├─ Execute CRUD operations
      ├─ Test API endpoints
      └─ Monitor database health

  Agent 5 (Research Specialist)
      ├─ Web search & research
      ├─ Analyze documentation
      ├─ Identify patterns
      └─ Provide findings
```

---

## Key Principles

| Principle | What it Means | Why It Matters |
|-----------|---------------|----------------|
| **Token Efficiency** | Agent 0 (you) uses minimal tokens | Faster decisions, lower cost |
| **Specialization** | Agent 4 = DB expert, Agent 5 = Research | Focused work, better results |
| **Async Pattern** | Agents respond via inbox, not direct | Parallelizable, auditable |
| **Service Requests** | `maw hey` → inbox response | Clear communication, traceable |
| **Separation** | Different agents = different concerns | Easier to understand & maintain |

---

## Check Agent Status

```bash
# List status of all agents
maw status list

# Real-time monitoring (2s refresh)
maw status watch

# Check specific agent
maw status 4
```

---

## File Locations

| File | Purpose |
|------|---------|
| `.agents/agents.yaml` | Agent definitions (config) |
| `AGENT4_ROLE.md` | PocketBase specialist role |
| `AGENT5_ROLE.md` | Research specialist role |
| `6-AGENT-ARCHITECTURE.md` | Complete documentation |
| `EXPANSION-SUMMARY.md` | Expansion details & learnings |
| `.agents/profiles/profile6.sh` | Horizontal layout config |
| `.agents/profiles/profile6-grid.sh` | Grid layout config (future) |

---

## Common Tasks

### Task: Add a New Agent
```bash
# Edit .agents/agents.yaml to add agent 6
# Then run:
.agents/scripts/agents.sh create 6
```

### Task: Sync Files to All Agents
```bash
# Update CLAUDE.md and sync to all agents:
.agents/scripts/sync.sh --files CLAUDE.md AGENT4_ROLE.md
```

### Task: Get Agent 4 to Create a Collection
```bash
# Direct request:
maw hey 4 "Create tasks collection with: id, name, status, assignee, due_date"

# Agent 4 creates → tests → responds via inbox
# You see: "✅ Created tasks collection. POST http://127.0.0.1:8090/..."
```

### Task: Research + Implement
```bash
# 1. Get research from Agent 5
maw hey 5 "Research PocketBase authentication patterns"

# 2. Agent 5 responds (via inbox) with findings

# 3. Review findings

# 4. Ask Agent 4 to implement best pattern
maw hey 4 "Implement JWT auth for agents collection based on [pattern]"

# 5. Agent 4 implements + tests + responds
```

---

## Roles Explained

### Agent 1: Shadow Claude
- **Job**: Execute your commands
- **Used For**: Running `/nnn`, `/plan`, `/analyze`, `/rrr`
- **Communication**: You → Agent 1 → GitHub issue → Signal
- **Example**: "Shadow, run /speckit.plan and post to issue #34"

### Agents 2-3: General Executors
- **Job**: Handle assigned tasks
- **Used For**: Implementation work, testing, deployments
- **Communication**: You → maw hey 2 → Inbox response
- **Example**: "maw hey 2 'Run unit tests for auth module'"
- **Parallel**: Both can work simultaneously

### Agent 4: PocketBase Specialist
- **Job**: Database operations only
- **Used For**: Collections, CRUD, API testing, health checks
- **Communication**: You → maw hey 4 → Inbox response
- **Example**: "maw hey 4 'Create agents collection with id, name, status'"
- **Expertise**: Deep knowledge of PocketBase

### Agent 5: Research Specialist
- **Job**: Research and knowledge work
- **Used For**: Web search, documentation analysis, patterns
- **Communication**: You → maw hey 5 → Inbox response
- **Example**: "maw hey 5 'Research distributed agent communication patterns'"
- **Expertise**: Gathering external knowledge

---

## Monitoring Workflow

```
You (Agent 0)
  ├─ Send requests (maw hey)
  ├─ Agents work in background
  ├─ Check inbox for responses
  ├─ Review results
  └─ Make next decision

Agent Status:
  maw status watch  # See real-time progress
  maw status 4      # Check specific agent
  maw status list   # List all agent status
```

---

## Troubleshooting

### Agents Not Responding
```bash
# Check tmux session is running
tmux list-sessions | grep ai-000-workshop

# Check inbox for messages
cat agents/*/inbox/latest.txt

# Manually check agent status in PocketBase
# Visit: http://127.0.0.1:8090/_/
```

### Request Format Issues
```bash
# ✅ CORRECT:
maw hey 4 "Create users collection"
maw hey 5 "Research authentication patterns"

# ❌ WRONG (without quotes):
maw hey 4 Create users collection  # Will fail

# ❌ WRONG (without agent number):
maw hey "Create users collection"  # Missing agent number
```

### Agent Not Found in TMux
```bash
# Verify agents exist:
ls -la agents/

# Verify git worktrees:
git worktree list

# Verify agent configuration:
cat .agents/agents.yaml
```

---

## Documentation References

- **Complete Architecture**: `6-AGENT-ARCHITECTURE.md`
- **Expansion Details**: `EXPANSION-SUMMARY.md`
- **Agent 4 Details**: `AGENT4_ROLE.md`
- **Agent 5 Details**: `AGENT5_ROLE.md`
- **Global Guidelines**: `CLAUDE.md`
- **PocketBase Setup**: `IMPLEMENTATION-GUIDE.md`
- **Agent Status**: `AGENT-STATUS-COMPLETE.md`

---

## Quick Commands Cheat Sheet

```bash
# Start agents
.agents/scripts/start-agents.sh profile6

# Check status
maw status list       # All agents
maw status watch      # Real-time
maw status 4          # Agent 4

# Send requests
maw hey 4 "request"   # To Agent 4
maw hey 5 "research"  # To Agent 5

# Manage agents
.agents/scripts/agents.sh list           # List all
.agents/scripts/agents.sh create 6       # Create new
.agents/scripts/agents.sh remove 6       # Remove

# Sync files
.agents/scripts/sync.sh --files CLAUDE.md

# Git operations
git worktree list     # Show all worktrees
git status           # Current branch status
git log --oneline -5 # Recent commits
```

---

## Next Steps for You

1. **Start TMux**: `.agents/scripts/start-agents.sh profile6`
2. **Try Agent 4**: `maw hey 4 "What collections exist?"`
3. **Try Agent 5**: `maw hey 5 "How do multi-agent systems scale?"`
4. **Check Inbox**: See agent responses
5. **Review Logs**: Understand communication

---

**Last Updated**: 2025-12-07
**Status**: ✅ Ready to Use
**Next**: Test profile6 layout and agent communication
