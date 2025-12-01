# Agent Inbox

**Purpose**: Agents submit their completed work here for main agent review and integration.

## Filename Convention

```
YYYY-MM-DD_HH-MM_agent-{N}_{task-name}.md
```

**Examples:**
- `2025-12-01_17-30_agent-2_subagents-analysis.md`
- `2025-12-01_18-00_agent-1_css-implementation.md`
- `2025-12-01_18-15_agent-3_testing-report.md`

## Benefits

- ✅ **Sortable by time**: `ls inbox/` shows chronological order
- ✅ **Agent attribution**: Clear who submitted what
- ✅ **Task identification**: Descriptive names
- ✅ **No nested directories**: Flat, simple structure
- ✅ **Git-friendly**: Easy to track in version control

## Workflow

### For Agents (submitting work)

```bash
# Agent creates their deliverable
# Filename: inbox/YYYY-MM-DD_HH-MM_agent-2_task-name.md

# Commit to their branch
git add inbox/
git commit -m "docs: submit research on {topic}"
git push origin agents/2

# Create PR
gh pr create --base main --head agents/2 --title "Research: {topic}"
```

### For Main Agent (reviewing work)

```bash
# Check inbox
ls -lt inbox/

# Review submitted work
cat inbox/2025-12-01_17-30_agent-2_subagents-analysis.md

# If approved, integrate into docs
mv inbox/2025-12-01_17-30_agent-2_subagents-analysis.md docs/research/subagents-vs-maw.md

# Or merge PR from agent
gh pr review {number}
gh pr merge {number}

# Clean up inbox (optional)
git rm inbox/2025-12-01_17-30_agent-2_subagents-analysis.md
```

## File Types

- `.md` - Research, analysis, documentation
- `.json` - Data, configuration
- `.txt` - Logs, raw output
- `.html` - Generated pages, reports

## Inbox Lifecycle

1. **Submitted**: Agent creates file in `inbox/`
2. **Reviewed**: Main agent checks the work
3. **Integrated**: Moved to appropriate location (`docs/`, `src/`, etc.)
4. **Cleaned**: Original inbox file removed after integration

## Example Task Assignment

```bash
# Main agent assigns task to Agent 2
/maw.hey 2 "Research topic X. Submit to: inbox/YYYY-MM-DD_HH-MM_agent-2_topic-x.md"

# Agent 2 completes work and saves to inbox
# Main agent reviews inbox
ls -lt inbox/

# Main agent integrates the work
```

## Notes

- Inbox files are **deliverables**, not work-in-progress
- Agents should only submit completed, reviewed work
- Main agent is responsible for inbox cleanup
- Use descriptive task names (lowercase, hyphen-separated)

---

**Created**: 2025-12-01
**Pattern**: Agent submission workflow
