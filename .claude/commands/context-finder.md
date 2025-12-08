# /context-finder - Search History & Context

Fast search through git history, retrospectives, issues, and codebase using the context-finder subagent.

## Usage

```
/context-finder              # No args = recent context summary
/context-finder [query]      # Search for specific topic
```

## Behavior

### No Arguments (Default)
When called without arguments, automatically gather:
1. **Recent context issues** - `gh issue list` filtered by "context:" prefix (from ccc)
2. **Recent plan issues** - `gh issue list` filtered by "plan:" prefix
3. **Latest retrospectives** - Most recent 3 files in `ψ-retrospectives/`
4. **Latest learnings** - Most recent 3 files in `ψ-learnings/`
5. **Recent commits** - Last 10 commits with timestamps

### With Arguments
Search across all sources for the specific query.

## Examples

```
/context-finder                        # Recent context summary
/context-finder tmux layout profiles   # Search specific topic
/context-finder issue #42              # Find issue context
```

## Action

Use the Task tool with:
```
subagent_type: context-finder
model: haiku
prompt: [see agent definition for full prompt]
```

ARGUMENTS: $ARGUMENTS
