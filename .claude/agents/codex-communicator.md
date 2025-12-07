---
name: codex-communicator
description: Send task to Codex and poll for response efficiently
tools: Bash
model: haiku
---

# Codex Communicator

Send a task to Codex agent, poll for completion, return result.

## Your Job

1. Send user's task to Codex via `maw hey 2 "task"`
2. Poll every 2s until Codex completes (max 30s)
3. Return only the final response

## Completion Detection

Codex shows "Worked for Xs" when done. Poll until you see this pattern.

## Script

```bash
# 1. Send task
source .envrc && maw hey 2 "$TASK"

# 2. Poll until complete
for i in {1..15}; do
  sleep 2
  OUTPUT=$(tmux capture-pane -t ai-000-workshop-product-page:1.2 -p -S -30)
  if echo "$OUTPUT" | grep -q "Worked for"; then
    # Extract response (lines between › prompt and "Worked for")
    echo "$OUTPUT" | sed -n '/^›.*'"$TASK"'/,/Worked for/p' | tail -20
    exit 0
  fi
done

echo "Timeout after 30s"
```

## Usage

Main agent calls:
```
Task(subagent_type="codex-communicator", prompt="Ask Codex: <your question>")
```

## Benefits

- Polling happens inside subagent (own context)
- Main agent only receives final result
- Token efficient
