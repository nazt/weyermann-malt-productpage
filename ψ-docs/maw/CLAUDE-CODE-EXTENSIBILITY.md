# Claude Code Extensibility Report

**Date**: 2025-12-01
**Source**: Official Claude Code documentation (code.claude.com)
**Purpose**: Reference for implementing MAW slash commands

---

## 1. Subagents

**Location**: `.claude/agents/` (project) or `~/.claude/agents/` (user)

**Purpose**: Separate AI agents with their own context window, tools, and system prompts. They run autonomously and return results to the main conversation.

### File Format
```markdown
---
name: agent-name
description: When this agent should be invoked
tools: Read, Glob, Grep  # Optional - inherits all if omitted
model: sonnet  # Options: sonnet, opus, haiku, inherit
permissionMode: default  # Optional
skills: skill1, skill2  # Optional
---

System prompt for the subagent goes here.
```

### Built-in Agents
| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| Explore | Haiku | Quick codebase exploration | Read-only (Glob, Grep, Read) |
| Plan | Sonnet | Implementation planning | All tools, plan mode |
| General-purpose | Sonnet | Complex multi-step tasks | All tools |

### Key Characteristics
- Separate context window (don't share main conversation history)
- Can have restricted tool access
- Claude automatically selects appropriate agent based on task
- Return single final message to main conversation

---

## 2. Slash Commands

**Location**: `.claude/commands/` (project) or `~/.claude/commands/` (user)

**Purpose**: Custom commands invoked with `/command-name` that expand into prompts.

### File Format
```markdown
---
description: What this command does
argument-hint: <required> [optional]
allowed-tools:
  - Bash(script.sh:*)
  - Read
model: sonnet
---

Command prompt template here.
Use $ARGUMENTS for all args, or $1, $2, $3 for positional.
Use @path/to/file to include file contents.
```

### Frontmatter Options
| Field | Purpose |
|-------|---------|
| `description` | Shown in command list |
| `argument-hint` | Usage hint (e.g., `<agent> <message>`) |
| `allowed-tools` | Restrict which tools can be used |
| `model` | Override model for this command |
| `disable-model-invocation` | Prevent Claude from auto-invoking |

### Special Syntax
| Syntax | Purpose |
|--------|---------|
| `$ARGUMENTS` | All arguments as single string |
| `$1`, `$2`, `$3` | Positional arguments |
| `@file.txt` | Include file contents inline |
| `!command` | Execute bash and include output |

### Nested Commands
Nested directories become namespaced:
- `commands/foo/bar.md` → `/foo.bar`
- `commands/maw/lock.md` → `/maw.lock`

---

## 3. Plugins

**Location**: `.claude-plugin/` directory with `plugin.json` manifest

**Purpose**: Distributable packages containing commands, agents, skills, hooks, and MCP servers.

### Structure
```
.claude-plugin/
├── plugin.json          # Manifest
├── commands/            # Slash commands
├── agents/              # Subagents
├── skills/              # Auto-discovered skills
├── hooks/               # Event hooks
└── .mcp.json           # MCP server configs
```

### Manifest (plugin.json)
```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Plugin description",
  "commands": ["commands/"],
  "agents": ["agents/"],
  "skills": ["skills/"],
  "hooks": ["hooks/"],
  "mcp": ".mcp.json"
}
```

---

## 4. Skills

**Location**: `.claude/skills/` (project) or `~/.claude/skills/` (user)

**Purpose**: Auto-discovered capabilities that Claude can suggest based on context.

### Structure
```
skills/
└── my-skill/
    ├── SKILL.md         # Skill definition
    ├── templates/       # Template files
    └── scripts/         # Helper scripts
```

### Skills vs Slash Commands

| Aspect | Slash Commands | Skills |
|--------|---------------|--------|
| **Invocation** | Explicit `/command` | Auto-discovered by Claude |
| **Structure** | Single markdown file | Directory with `SKILL.md` + resources |
| **Use case** | User-triggered actions | Context-aware capabilities |
| **Complexity** | Simple prompts | Multi-file with templates, scripts |

**When to use Skills**: Complex workflows with multiple files/templates that Claude should suggest automatically.

**When to use Slash Commands**: User-triggered actions, simple prompts, explicit control.

---

## 5. Application to MAW

### Current MAW Architecture
```
.claude/commands/
├── maw.hey.md           # Send message to agent (gitignored)
├── maw.hey.sh           # Wrapper script (gitignored)
├── maw.agents-create.md # Create agents (gitignored)
└── ...

scripts/
├── agent-lock.sh        # Lock/unlock backend (tracked)
├── agent-status.sh      # Status backend (tracked)
└── smart-sync.sh        # Smart sync (tracked)
```

### Pattern: MAW Command Structure
```markdown
---
description: Short description
argument-hint: <required> [optional]
allowed-tools:
  - Bash(scripts/backend.sh:*)
---

Goal: What this command accomplishes.

Shell template:
```bash
scripts/backend.sh $ARGUMENTS
```
```

### Commands to Implement

**`/maw.lock <N> <task>`** - Lock agent with task description
```bash
scripts/agent-lock.sh lock $1 "${@:2}"
```

**`/maw.unlock <N>`** - Unlock agent
```bash
scripts/agent-lock.sh unlock $1
```

**`/maw.status [N]`** - Check agent status
```bash
scripts/agent-lock.sh status $1
```

---

## 6. Key Takeaways

1. **Slash commands** are the right choice for MAW lock system (user-triggered, explicit control)

2. **Backend scripts go in `scripts/`** (version controlled, accessible to all)

3. **Command wrappers go in `.claude/commands/maw.*`** (gitignored per MAW design)

4. **Use `allowed-tools`** to restrict commands to only the tools they need

5. **Subagents** could be useful for complex autonomous tasks (e.g., code review agent)

6. **Skills** are overkill for simple operations like lock/unlock

---

## 7. Fastest Way to Read Claude Code Docs

### Using MCP Playwright (Recommended)
```
# From Claude Code, use the browser MCP tools:
mcp__playwright__browser_navigate to https://code.claude.com/docs/en/sub-agents
mcp__playwright__browser_snapshot to get page content
```

### Key Documentation URLs
| Topic | URL |
|-------|-----|
| Subagents | https://code.claude.com/docs/en/sub-agents |
| Slash Commands | https://code.claude.com/docs/en/slash-commands |
| Plugins | https://code.claude.com/docs/en/plugins |
| Hooks | https://code.claude.com/docs/en/hooks |
| MCP Servers | https://code.claude.com/docs/en/mcp |
| Settings | https://code.claude.com/docs/en/settings |

### Quick Access Pattern
```bash
# Ask Claude Code to browse docs
"you have mcp please use to browse https://code.claude.com/docs/en/sub-agents"

# Or use WebFetch tool
WebFetch url=https://code.claude.com/docs/en/slash-commands prompt="summarize this page"
```

### Docs Navigation
The Claude Code docs site structure:
```
code.claude.com/docs/en/
├── overview
├── getting-started
├── sub-agents          # Autonomous agents
├── slash-commands      # Custom /commands
├── plugins             # Distributable packages
├── hooks               # Event handlers
├── mcp                 # Model Context Protocol
├── settings            # Configuration
└── cli                 # Command line options
```

---

## References

- [Subagents Documentation](https://code.claude.com/docs/en/sub-agents)
- [Slash Commands Documentation](https://code.claude.com/docs/en/slash-commands)
- [Plugins Documentation](https://code.claude.com/docs/en/plugins)
- MAW Repository: Soul-Brews-Studio/multi-agent-workflow-kit

---

**Last Updated**: 2025-12-01
