---
name: context-finder
description: Fast search through git history, retrospectives, issues, and codebase
tools: Bash, Grep, Glob
model: haiku
---

# Context Finder

Search and return **TIME + REFERENCE** for all results.

## Mode Detection

**If no query provided (empty/blank arguments)** → Run DEFAULT MODE
**If query provided** → Run SEARCH MODE

---

## DEFAULT MODE (No Arguments)

Gather recent context from ALL sources automatically:

### Step 1: Context Issues (from ccc)
```bash
gh issue list --limit 20 --state all --json number,title,createdAt --jq '.[] | select(.title | test("^(📋 )?[Cc]ontext:")) | "#\(.number) (\(.createdAt | split("T")[0])) \(.title)"' | head -5
```

### Step 2: Plan Issues
```bash
gh issue list --limit 20 --state all --json number,title,createdAt --jq '.[] | select(.title | test("^(📋 )?[Pp]lan:")) | "#\(.number) (\(.createdAt | split("T")[0])) \(.title)"' | head -5
```

### Step 3: Recent Commits (last 10)
```bash
git log --format="%h (%ad) %s" --date=format:"%Y-%m-%d %H:%M" -10
```

### Step 4: Latest Retrospectives (3 most recent)
```bash
ls -t ψ-retrospectives/**/*.md 2>/dev/null | head -3
```
For each file, read first 20 lines and extract **Primary Focus** line.
Output format: `- relative/path.md - Focus: [extracted focus]`

### Step 5: Latest Learnings (3 most recent)
```bash
ls -t ψ-learnings/*.md 2>/dev/null | head -3
```
For each file, extract first `#` heading (line starting with `# `).
Output format: `- filename.md - [heading text]`

### Output Format (Default Mode)
```
## Recent Context

### Context Issues (ccc)
#N (YYYY-MM-DD) title
#N (YYYY-MM-DD) title

### Plan Issues
#N (YYYY-MM-DD) title
#N (YYYY-MM-DD) title

### Recent Commits
`hash` (YYYY-MM-DD HH:MM) message

### Latest Retrospectives
- path/file.md (YYYY-MM-DD) - Focus: [extracted]
- path/file.md (YYYY-MM-DD) - Focus: [extracted]

### Latest Learnings
- filename.md - [first heading]
- filename.md - [first heading]

### Summary
[1-2 sentence summary of current momentum/focus]
```

---

## SEARCH MODE (With Query)

### Process
1. **Expand query** → synonyms, related terms, abbreviations
2. **Search parallel** → git, issues, retrospectives, learnings, codebase
3. **Return with timestamps** → human-readable format

### Commands
```bash
git log --all --grep="[query]" --format="%h (%ad) %s" --date=format:"%H:%M" -10
gh issue list --limit 10 --search "[query]" --json number,title,createdAt
grep -r "[query]" ψ-retrospectives/ ψ-learnings/ --include="*.md" -l
```

### Output Format (Search Mode)
```
## Search: "[query]"

### Commits
`hash` (HH:MM) message

### Issues
#N (YYYY-MM-DD) title

### Files
path (YYYY-MM-DD HH:MM)
- Excerpt: [relevant line]
```
