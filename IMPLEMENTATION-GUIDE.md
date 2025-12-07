# Agent Status Tracking System - Implementation Guide

**Status**: Complete Specification + Ready for Execution
**Date**: 2025-12-07 23:50 GMT+7
**Architecture**: 6-Agent (Agent 0 main, Agent 1 shadow, Agents 2-5 specialists)

## Overview

This guide provides the step-by-step implementation for the Agent Status Tracking System with 6-agent architecture.

## Prerequisite Verification ✅

- ✅ PocketBase running on http://127.0.0.1:8090
- ✅ Inbox system operational (PocketBase collection)
- ✅ Signal file infrastructure (.tmp/agent{N}-done)
- ✅ TMux setup updated for 6-agent layout (profile6.sh)
- ✅ Specification document (spec.md) completed

## Architecture

```
Agent 0 (You - Claude)
  ├─ Orchestrates phases
  ├─ Sends directives to Shadow (Agent 1)
  └─ Sends requests to Agents 2-5

Agent 1 (Shadow - Claude)
  ├─ Executes your `/` commands
  ├─ Sends requests to agents via maw hey
  └─ Posts results to GitHub

Agent 2 (Codex - General)
  ├─ Executes tasks from main agent
  └─ Integration work in Phase 5

Agent 3 (Codex - General)
  ├─ Executes tasks from main agent
  └─ Integration work in Phase 5

Agent 4 (Codex - Specialist)
  ├─ PocketBase expert
  ├─ Creates collections (Phase 2)
  ├─ Tests endpoints (Phase 3)
  └─ Manages schema

Agent 5 (Codex - Research)
  ├─ Researches PocketBase best practices
  ├─ Finds recommendations
  └─ Documents findings
```

## Phase-by-Phase Implementation

### Phase 1: PocketBase Collection Creation

**Objective**: Create `agent_status` collection with proper schema

**Collection Name**: `agent_status`

**Schema (6 fields)**:

```json
[
  {
    "id": "agent_id_field",
    "name": "agent_id",
    "type": "text",
    "required": true,
    "options": {}
  },
  {
    "id": "status_field",
    "name": "status",
    "type": "select",
    "required": true,
    "options": {
      "values": ["pending", "working", "completed", "failed"]
    }
  },
  {
    "id": "task_name_field",
    "name": "task_name",
    "type": "text",
    "required": true,
    "options": {}
  },
  {
    "id": "started_at_field",
    "name": "started_at",
    "type": "date",
    "required": true,
    "options": {}
  },
  {
    "id": "completed_at_field",
    "name": "completed_at",
    "type": "date",
    "required": false,
    "options": {}
  },
  {
    "id": "result_field",
    "name": "result",
    "type": "json",
    "required": false,
    "options": {}
  },
  {
    "id": "error_field",
    "name": "error",
    "type": "text",
    "required": false,
    "options": {}
  }
]
```

**How to Create**:

**Option 1: Via PocketBase Admin UI**
1. Go to http://127.0.0.1:8090/_/
2. Create new collection "agent_status"
3. Add fields as specified above
4. Save

**Option 2: Via curl (programmatic)**
```bash
curl -X POST http://127.0.0.1:8090/api/admin/collections \
  -H "Content-Type: application/json" \
  -d '{
    "name": "agent_status",
    "type": "base",
    "schema": [
      {"id": "f1", "name": "agent_id", "type": "text", "required": true},
      {"id": "f2", "name": "status", "type": "select", "required": true, "options": {"values": ["pending", "working", "completed", "failed"]}},
      {"id": "f3", "name": "task_name", "type": "text", "required": true},
      {"id": "f4", "name": "started_at", "type": "date", "required": true},
      {"id": "f5", "name": "completed_at", "type": "date"},
      {"id": "f6", "name": "result", "type": "json"},
      {"id": "f7", "name": "error", "type": "text"}
    ]
  }'
```

**Verification**:
```bash
# Verify collection exists
curl http://127.0.0.1:8090/api/collections | jq '.items[] | select(.name == "agent_status")'

# Should return collection metadata
```

**Expected Output**:
```json
{
  "id": "pbc_xxxxx",
  "name": "agent_status",
  "type": "base",
  "schema": [...]
}
```

---

### Phase 2: REST API Endpoint Testing

**Objective**: Test 3 endpoints to verify collection is working

**Endpoint 1: POST /api/collections/agent_status/records**

Purpose: Create status record

```bash
curl -X POST http://127.0.0.1:8090/api/collections/agent_status/records \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "2",
    "status": "working",
    "task_name": "Phase 1 Implementation",
    "started_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  }'
```

Expected response: `201 Created` with record data

**Endpoint 2: GET /api/collections/agent_status/records (filtered)**

Purpose: Query specific agent status

```bash
curl 'http://127.0.0.1:8090/api/collections/agent_status/records?filter=(agent_id="2")'
```

Expected response: `200 OK` with matching records

**Endpoint 3: GET /api/collections/agent_status/records (list all)**

Purpose: List all agent statuses

```bash
curl 'http://127.0.0.1:8090/api/collections/agent_status/records'
```

Expected response: `200 OK` with all records

---

### Phase 3: CLI Tools Creation

**File**: `.agents/scripts/agent-status.sh`

**Commands**:

```bash
#!/bin/bash
# Agent status CLI tool

POCKETBASE_URL="http://127.0.0.1:8090"

# List all agents' statuses
status_list() {
    curl -s "$POCKETBASE_URL/api/collections/agent_status/records" | \
    jq -r '.items[] | "\(.agent_id) | \(.status) | \(.task_name)"' | column -t -s '|'
}

# Show specific agent status
status_agent() {
    local agent_id=$1
    curl -s "$POCKETBASE_URL/api/collections/agent_status/records?filter=(agent_id=\"$agent_id\")" | \
    jq '.items[0]'
}

# Watch real-time (refresh every 2s)
status_watch() {
    while true; do
        clear
        echo "🔍 Agent Status ($(date '+%H:%M:%S'))"
        echo "=================================="
        status_list
        echo ""
        echo "Refreshing in 2s... (Ctrl+C to stop)"
        sleep 2
    done
}

# Main
case "${1:-list}" in
    list)   status_list ;;
    watch)  status_watch ;;
    *)      status_agent "$1" ;;
esac
```

**Integration**:
```bash
# Add to maw.env.sh
source "$(dirname "$0")/scripts/agent-status.sh"

# Make available as maw status
alias maw.status='agent-status.sh'
```

---

### Phase 4: Agent Integration Scripts

**Agent 2/3 `run.sh` Updates**:

Before executing task:
```bash
curl -X POST http://127.0.0.1:8090/api/collections/agent_status/records \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "'$AGENT_ID'",
    "status": "working",
    "task_name": "'$TASK_NAME'",
    "started_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  }'
```

After executing task:
```bash
curl -X POST http://127.0.0.1:8090/api/collections/agent_status/records \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "'$AGENT_ID'",
    "status": "completed",
    "task_name": "'$TASK_NAME'",
    "completed_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
    "result": {...}
  }'

# Fire signal
touch .tmp/agent${AGENT_ID}-done
```

---

### Phase 5: End-to-End Testing

**Test Scenario**: Agent 2 executes task, updates status, fires signal

```bash
# 1. Start agent 2 (simulated)
echo "Starting Agent 2..."
rm -f .tmp/agent2-done

# 2. Agent 2 sends "working" status
curl -X POST http://127.0.0.1:8090/api/collections/agent_status/records \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "2",
    "status": "working",
    "task_name": "Test Task",
    "started_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  }'

# 3. Simulate work (1 second)
sleep 1

# 4. Agent 2 sends "completed" status
curl -X POST http://127.0.0.1:8090/api/collections/agent_status/records \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "2",
    "status": "completed",
    "task_name": "Test Task",
    "completed_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  }'

# 5. Agent 2 fires signal
touch .tmp/agent2-done

# 6. Main agent waits and checks signal
if [ -f .tmp/agent2-done ]; then
    echo "✅ Agent 2 completed - signal received"
    # Query status
    curl -s 'http://127.0.0.1:8090/api/collections/agent_status/records?filter=(agent_id="2")' | \
    jq '.items[-1]' | grep -E "(status|completed_at)"
fi
```

**Success Criteria**:
- ✅ Signal file created < 100ms after API call
- ✅ Status API returns latest record
- ✅ All 3 endpoints working correctly
- ✅ Multiple agents can update status in parallel

---

### Phase 6: Documentation & Retrospective

**Files to Create**:

1. `ψ-docs/maw/AGENT-STATUS-GUIDE.md`
   - Architecture overview
   - How to use CLI tools
   - Integration examples
   - Troubleshooting

2. `agents/4/POCKETBASE-GUIDE.md`
   - Agent 4 responsibilities
   - Collection management
   - Schema migration patterns

3. `agents/5/RESEARCH-GUIDE.md`
   - Agent 5 research methods
   - How to document findings
   - Source citation requirements

4. Update `AGENTS.md`
   - Add Agent 4 and 5 roles
   - Add service request examples

---

## Execution Checklist

### For Agent 0 (You):
- [ ] Read this guide completely
- [ ] Review spec.md and plan #34
- [ ] Verify Phase 0 checklist (all systems ready)
- [ ] Execute Phase 1 (create collection)
- [ ] Execute Phase 2 (test endpoints)
- [ ] Monitor Phases 3-5 (delegate to agents)
- [ ] Complete Phase 6 (documentation)

### For Shadow Agent (Agent 1):
- [ ] Monitor inbox for directives from Agent 0
- [ ] Execute directives exactly as specified
- [ ] Send requests to Agents 2-5 via `maw hey`
- [ ] Post results to GitHub issues
- [ ] Fire signals when tasks complete

### For Agents 2-3:
- [ ] Wait for task requests from Agent 0
- [ ] Claim task from inbox (mark as processing)
- [ ] Update status API (working → completed)
- [ ] Post results to inbox
- [ ] Fire signal when done

### For Agent 4:
- [ ] Wait for service requests from other agents
- [ ] Create/manage PocketBase collections
- [ ] Test API endpoints
- [ ] Document results
- [ ] Fire signal when complete

### For Agent 5:
- [ ] Wait for research requests
- [ ] Search and read documentation
- [ ] Synthesize findings with sources
- [ ] Post findings to inbox
- [ ] Fire signal when complete

---

## Success Criteria (Complete)

### Phase 1: Collection Creation ✅
- [ ] `agent_status` collection exists in PocketBase
- [ ] All 7 fields present with correct types
- [ ] Collection accepts records

### Phase 2: Endpoint Testing ✅
- [ ] POST /api/collections/agent_status/records works (201 Created)
- [ ] GET /api/collections/agent_status/records?filter=(...) works (200 OK)
- [ ] GET /api/collections/agent_status/records works (200 OK)
- [ ] All responses contain correct data

### Phase 3: CLI Tools ✅
- [ ] `agent-status.sh` created with 3 commands
- [ ] `maw status list` shows all agents
- [ ] `maw status <id>` shows specific agent
- [ ] `maw status watch` auto-refreshes every 2s

### Phase 4: Agent Integration ✅
- [ ] Agent 2 run.sh updated with status API calls
- [ ] Agent 3 run.sh updated with status API calls
- [ ] Status updates happen before/after tasks

### Phase 5: End-to-End Testing ✅
- [ ] Agent executes task
- [ ] Status API updated automatically
- [ ] Signal fires < 10ms after completion
- [ ] Main agent can monitor via signals and API
- [ ] Multiple agents can update simultaneously

### Phase 6: Documentation ✅
- [ ] All guides created and linked
- [ ] AGENTS.md updated with Agent 4/5 roles
- [ ] Retrospective completed with learnings
- [ ] Examples provided for all features

---

## Timeline

**Expected Duration**: 2-4 hours for full implementation

**Breakdown**:
- Phase 0 (Verification): 15 min ✅ COMPLETE
- Phase 1 (Collection): 15 min
- Phase 2 (Endpoints): 20 min
- Phase 3 (CLI): 20 min
- Phase 4 (Integration): 30 min
- Phase 5 (Testing): 30 min
- Phase 6 (Docs): 30 min

**Total**: ~2.5 hours

---

## Next Steps

1. **Agent 0 (You)**: Execute Phase 1 - Create collection
2. **Agent 1 (Shadow)**: Stand by for directives
3. **Agent 5**: Wait for research request
4. **Agents 2-4**: Prepare for tasks

Ready to start Phase 1? ✅
