# AI Self-Learning Demo

## Concept

AI can read its own documentation to learn new capabilities.

## Documentation URLs

- **Subagents**: https://code.claude.com/docs/en/sub-agents
- **MCP Servers**: https://code.claude.com/docs/en/mcp
- **Hooks**: https://code.claude.com/docs/en/hooks

## Methods

### 1. MCP Playwright (Browser)

AI browses documentation like a human:

```
mcp__playwright__browser_navigate → go to URL
mcp__playwright__browser_snapshot → read page content
```

### 2. Subagent Research

AI spawns a subagent to research topics:

```
Task tool with subagent_type: "claude-code-guide"
→ Agent reads official docs
→ Returns accurate information
```

### 3. Background Learning

AI learns while doing other work:

```
Task tool with run_in_background: true
→ Research runs in parallel
→ Main conversation continues
→ Results retrieved when needed
```

## Demo Flow

1. User asks: "How do subagents work?"
2. AI spawns `claude-code-guide` subagent
3. Subagent reads https://code.claude.com/docs/en/sub-agents
4. AI receives documentation content
5. AI answers with accurate, up-to-date information

## Key Insight

AI doesn't need pre-trained knowledge for everything. It can:
- Browse documentation in real-time
- Learn new features as they're released
- Verify its own understanding against official sources
- Teach itself through reading
