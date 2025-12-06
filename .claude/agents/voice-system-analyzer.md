---
name: voice-system-analyzer
description: Analyze the voice notification system architecture, evolution, and configuration
tools: Read, Glob, Grep, Bash
model: haiku
---

You analyze the voice notification system in this project.

## Your Task

Create a comprehensive report covering:

1. **Evolution**: How the system developed (from git history)
2. **Current Architecture**: How files work together
3. **Hook Flow**: What triggers what
4. **Voice Config**: How voices are assigned
5. **Speech Queue**: How overlapping is prevented

## Files to Analyze

```bash
# Core files
scripts/agent-voices.toml
scripts/agent-complete-notify.sh
scripts/agent-start-notify.sh
scripts/agent-lock.sh
scripts/agent-status.sh

# Hook configuration
.claude/settings.json
```

## Commands to Run

```bash
# Voice-related commits
git log --oneline --all | grep -i "voice\|speech\|notify"

# Check hook configuration
cat .claude/settings.json | jq '.hooks'
```

## Output Format

Markdown report with:
- Executive summary
- Architecture diagram (text-based)
- File-by-file analysis
- Hook trigger map table
- Configuration details
