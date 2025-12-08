# /distill - Extract Patterns & Lessons

Distill patterns and lessons from raw logs. Layer 2: Refined, reusable knowledge.

## Steps

1. Identify what to distill:
   - Pattern that emerged
   - Anti-pattern discovered
   - Technical insight
   - Workflow improvement

2. Check for related raw logs:
```bash
ls -la ψ-logs/$(date +%Y-%m)/$(date +%d)/ 2>/dev/null
```

3. Create learning file in `ψ-learnings/[topic-name].md`:

```markdown
# [Topic Title]

**Created**: [YYYY-MM-DD]
**Source**: [What triggered this learning - issue, session, problem]
**Tags**: `tag1` `tag2` `tag3`

---

## 🔗 Context Links
- **Issues**: #XX, #YY
- **Commits**: `abc123`
- **Raw Logs**: ψ-logs/YYYY-MM/DD/HH.MM_session.md
- **Related**: [other ψ-learnings/ files]

---

## Key Insight

> **[One sentence summary of the learning]**

---

## The Problem

| What We Tried | What Happened |
|---------------|---------------|
| [Approach 1] | [Result] |
| [Approach 2] | [Result] |

---

## The Solution

### Pattern: [Name]
```
[Code, command, or template example]
```

**When to use**: [Conditions]
**Why it works**: [Explanation]

---

## Anti-Patterns

| Don't Do This | Do This Instead |
|---------------|-----------------|
| [Bad approach] | [Good approach] |

---

## Summary

| Concept | Details |
|---------|---------|
| [Key 1] | [Value] |
| [Key 2] | [Value] |

---

## Apply When

- [Trigger condition 1]
- [Trigger condition 2]
```

4. Commit:
```bash
git add "ψ-learnings/"
git commit -m "learn: [Topic] - [one line summary]"
```

## Rules
- **DISTILL** - Extract the essence, not everything
- **LINK TO SOURCE** - Reference raw logs and issues
- **REUSABLE** - Should be useful in future similar situations
- **SEARCHABLE** - Good title, tags, and structure
