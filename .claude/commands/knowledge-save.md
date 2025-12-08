# /knowledge-save - Raw Session Capture

Quick capture of session work. Layer 1: Raw data with full traceability.

## Steps

1. Gather context:
```bash
# Get recent commits
git log --oneline -5

# Get current branch
git branch --show-current

# Get modified files
git status --short
```

2. Create log file:
```bash
mkdir -p "ψ-logs/$(date +%Y-%m)/$(date +%d)"
```

3. Write to `ψ-logs/YYYY-MM/DD/HH.MM_session.md`:

```markdown
# Session: [BRIEF_TITLE]

**Time**: [HH:MM] GMT+7
**Duration**: ~[X] min

## 🔗 Context Links
- **Issues**: #XX, #YY
- **Commits**: `abc123`, `def456`
- **Branch**: [branch-name]
- **Tags**: `tag1` `tag2` `tag3`

## What Happened
- [Action 1]
- [Action 2]
- [Action 3]

## Quick Notes
- [Observation or note]
- [Thing that worked/didn't]

## Files Touched
```
[git status --short output]
```

## Raw Thoughts
[Any unprocessed thoughts, questions, ideas - capture everything]
```

4. Commit:
```bash
git add "ψ-logs/"
git commit -m "log: Session snapshot $(date +%Y-%m-%d)"
```

## Rules
- **FAST** - Don't overthink, just capture
- **LINK EVERYTHING** - Issues, commits, tags are mandatory
- **RAW IS OK** - Doesn't need to be polished
- **Timestamp precision** - Always include time GMT+7
