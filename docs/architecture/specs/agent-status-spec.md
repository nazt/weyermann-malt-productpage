# Feature Specification: Agent Status Tracking System

## Overview
Implement efficient real-time agent status tracking using PocketBase database with instant (ms-level) response notifications via tmux signals.

## Problem Statement
Currently, the main agent (Claude) has no efficient way to monitor when Codex subagents (Agent 2, Agent 3) complete their tasks. Current solutions:
- Polling `.tmp/` files (100-500ms latency, wastes tokens)
- Checking tmux panes (requires screen capture)
- Manual checking

## Solution Goals
1. **Fast Response**: <10ms latency when agents complete (using tmux signals)
2. **Token Efficient**: Main agent uses minimal tokens while waiting (offload polling to subagent)
3. **Persistent History**: Store all agent task status in PocketBase for audit trail
4. **Real-time Visibility**: Query current agent status via REST API
5. **CLI Tools**: Command-line tools to monitor agent progress

## Functional Requirements

### 1. PocketBase Agent Status Collection
- Create `agent_status` collection with fields:
  - `agent_id` (text): Identifies agent (1, 2, 3, main)
  - `status` (text): pending, working, completed, failed
  - `task_name` (text): What task is being worked on
  - `started_at` (datetime): Task start time
  - `completed_at` (datetime): Task completion time
  - `result` (json): Task result data
  - `error` (text): Error message if failed

### 2. API Endpoints
- `POST /api/agent-status/update` - Agent updates its status
  - Body: `{agent_id, status, task_name, result?, error?}`
- `GET /api/agent-status/{agent_id}` - Query agent status
  - Returns: Current status record for agent
- `GET /api/agent-status/list` - List all agent statuses
  - Returns: All agent status records

### 3. Tmux Signal Integration
- Agents fire tmux signal when complete: `tmux send-signal -X agent{N}-complete`
- Main agent waits with: `tmux wait-signal agent{N}-complete`
- Response time: <10ms (instant)

### 4. CLI Tools
- `maw status list` - Show all agents' current status
- `maw status <agent_id>` - Show specific agent status
- `maw status watch` - Real-time status watcher (auto-refresh 2s)
- `.agents/scripts/wait-agents-fast.sh` - Token-efficient waiter for main agent

### 5. Agent Behavior
- Agent updates status before and after task
- Agent sends completion signal: `tmux send-signal -X agent{N}-complete`
- Status data persists in PocketBase indefinitely

## Non-Functional Requirements
- **Performance**: Completion notification <10ms latency
- **Reliability**: No message loss, signal survives restarts
- **Simplicity**: Minimal overhead, easy to integrate
- **Observability**: Full audit trail in PocketBase

## Implementation Phases

### Phase 1: PocketBase Collection + Endpoints (Agent 2)
- Create `agent_status` collection
- Implement 3 REST API endpoints
- Test all endpoints with sample data

### Phase 2: CLI Tools (Agent 3)
- Create `agent-status.sh` with status commands
- Integrate with existing monitoring tools
- Add verbose mode for debugging

### Phase 3: Integration
- Update agents to fire signals on completion
- Update main agent to use fast waiter
- Document usage and patterns

## Success Criteria
- [ ] Agent 2 creates collection with 3 working endpoints
- [ ] Agent 3 creates CLI tools that query endpoints
- [ ] Main agent receives completion signal <10ms after agent finishes
- [ ] Status history persists across restarts
- [ ] All commands tested and documented

## Dependencies
- PocketBase (already running)
- tmux (already available)
- Go (for Agent 2 changes)
- Bash (for Agent 3 scripts)

## Related Work
- Current: `.tmp/agent{N}-done` files (deprecated)
- Pattern: From Agent 2's retrospective (2025-12-08)
