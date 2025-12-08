# /maw.issue — Create GitHub Issues

Use this command when you want an agent to turn a plan into a GitHub issue on
the current repository.

```
/maw.issue --title "Implement /maw-issue command" --body "1. Add CLI helper\n2. Wire up slash command\n3. Document usage"
```

Key behaviours:

- Verifies that the GitHub CLI (`gh`) is installed and authenticated (equivalent
  to running `gh auth status`) before continuing.
- Defaults to the current repository; pass `--repo org/name` to target another.
- Accepts body content via `--body`, `--body-file`, positional arguments, or
  piped STDIN. Use `--dry-run` to preview without creating the issue.
- Supports optional `--label/--labels`, `--assignee/--assignees`, and `--web`
  flags to fine‑tune the created issue.

Tip: pair this with the `nnn` planning workflow—capture the analysis, then run
`/maw.issue` (or `/maw-issue`) to publish the plan as a tracking issue.
