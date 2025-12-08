# /context-finder - Search History & Context

Fast search through git history, retrospectives, issues, and codebase using the context-finder subagent.

## Usage

```
/context-finder [search query]
```

## Examples

```
/context-finder tmux layout profiles
/context-finder archiver subagent prompt
/context-finder issue #42 codex
```

## How It Works

This command spawns the `context-finder` subagent (haiku model for speed) to search:

1. **Git history** - commits, branches, tags
2. **Retrospectives** - `ψ-retrospectives/`
3. **Learnings** - `ψ-learnings/`
4. **Session logs** - `ψ-logs/`
5. **Issues** - GitHub issues via `gh`
6. **Codebase** - grep/glob patterns

## Action

Use the Task tool with:
```
subagent_type: context-finder
model: haiku
prompt: "Search for: [USER_QUERY]

Return:
- File paths with excerpts
- Issue numbers with titles
- Commit hashes with messages
- Relevance ranking"
```

## Output Format

The subagent returns paths and excerpts. Main agent can then:
- Read specific files for detail
- Open issues with `gh issue view`
- Show commits with `git show`
