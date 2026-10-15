---
name: stack-pr-submit
description: Use when opening, submitting, or drafting pull requests for the current branch or a gh stack of stacked PRs — writing PR titles and descriptions, preparing for `gh stack submit`, or when the user types /stack-pr-submit.
metadata:
  opencode/slash: "true"
---

# Stack PR Submit

Draft PR titles and descriptions, one PR at a time, for the user to paste into `gh stack submit`'s
interactive editor (or `gh pr create` for a single branch). The user submits by default.

Arguments: $ARGUMENTS

- `--submit`: opt-in. After every PR is approved, the agent submits on the user's behalf (see
  Submitting). Without it, never run `gh stack submit`, `gh pr create`, or `gh pr edit`.

## Writing style

PR text is read by humans and AI reviewers. Write it in plain, complete sentences, even when the
session uses a terse or caveman output style. Common words like "config", "repo", "UI", and "API"
are fine; otherwise spell words out ("component", not "comp"; "because", not "b/c").

## Step 1: Detect mode

Run `gh stack view --json`.

- Exit `0`: **stack mode**. PRs to draft = `branches[]` entries with no `pr` and `isMerged` false,
  bottom to top. Skip branches that already have a PR. Each branch's diff is
  `git diff <parent-branch>...<branch>`, where the parent is the previous entry (or `trunk`).
- Exit `2`: **single mode**. Not a stack — draft one PR for the current branch against the default
  branch. Do not run any other `gh stack` command.

For `gh stack` details, rely on the `gh-stack` skill. Never run bare `gh stack view` or
`gh stack submit` yourself — both open a TUI and hang.

## Step 2: Gather context (once, before the first PR)

1. `.github/pull_request_template.md` — if it exists, its sections are the description structure.
2. `gh pr list --state merged --limit 10 --json title,body` — learn the title format, tone, level of
   detail, and the Jira base URL (copy it from Jira links in past bodies).
3. Per branch: `git log --format='%s%n%b' <parent>..<branch>` and the diff.
4. Jira key from the branch name or commits. If the jira MCP is available, read the ticket for the
   reason behind the change. If the Jira base URL is still unknown, ask the user once.
5. Decisions already made: from the conversation, commit messages (e.g. "per review"), and code
   comments. These feed Review Notes.

**Fallbacks** when no template exists: sections `Description`, `Changes`, `Review Notes`,
`Testing Steps`, `Tickets`, `Screenshots/Videos`. When past titles show no pattern:
`{type}: {JIRA-KEY} {Subject}`, where type is `feat` (new behavior), `fix` (bug fix), `refactor`,
`test`, `docs`, or `chore` (dependencies, tooling, config).

## Step 3: Ask about cross-project PRs (once)

Skip the question if the user already named cross-project PRs earlier in the conversation.
Otherwise, ask the user whether any PRs in other repositories (for example gary-ql, premier-ui) relate to this
work, and name any spots where the code suggests one (new GraphQL fields, API contracts, shared
types). Use their answer. For any suspected dependency they did not supply a link for, insert a
placeholder (see Placeholders).

## Step 4: Draft one PR, then stop

Each response contains exactly these parts, in order:

1. Heading: `PR {n} of {total}: {branch} → {base}` (single mode: `PR: {branch} → {base}`).
2. Title, in its own `text` code block.
3. Description, inside a four-backtick ````` ````markdown ````` fence so inner code blocks survive.
4. `Edit before submitting:` — a list of every placeholder in this description, each naming its
   section and what is needed.
5. One closing line, then stop and wait:
   - More PRs remain: `Reply with changes, or "next" for PR {n+1}.`
   - Last (or only) PR, no `--submit`: `Reply with changes, or "done". Then run gh stack submit (or gh pr create) and paste each title and description.`
   - Last (or only) PR, with `--submit`: `Reply with changes, or "submit" to create the PRs.`

Never draft the next PR until the user replies. A reply with no requested changes approves the
current PR; a reply with changes means revise and re-send the same PR in the same format.

### Title rules

- Follow the repository's past title pattern.
- Add the ` [PREVIEW]` suffix when either is true:
  - the PR has a meaningful UI change a reviewer would benefit from interacting with; or
  - the repository is an API/backend service (always — enables testing with Yaak, Postman, curl).
- Do not add it for types-only, tests-only, refactor-only, or tooling changes in a UI repository.

### Description rules

- Description: what changed and why, in two to four sentences.
- Changes: concise bullets of meaningful changes, not a file list.
- Review Notes: decisions an AI or human reviewer might otherwise flag, each with its reason, so
  already-addressed feedback is not raised again (for example "Uses recharts instead of the in-house
  chart library because it lacks dual-line tooltips."). If the template has no matching section, add
  `## Review Notes` after Changes.
- Testing Steps: concrete steps, each traceable to the diff. Behavior the diff does not show (for
  example what an upstream service returns) becomes a placeholder, not an assumption.
- Tickets: the bare Jira URL only, for example `https://example.atlassian.net/browse/MNTN-123`. No
  markdown link text, no ticket title.
- Related PRs: a `## Related PRs` section directly after Tickets, containing bare URLs of
  cross-project PRs (or their placeholders). Omit the section when there are none. GitHub already
  shows PRs in the same stack, so never list them, never write "Part of a stack", and never number
  the stack.
- Preview dependencies: do not list them or add a section for them.
- Screenshots/Videos: a placeholder when the PR changes UI; otherwise `N/A`.

### Placeholders

- Short values: Jinja style, for example `{{ link to gary-ql PR adding dailyPacing }}`.
- Larger content: an HTML comment, for example
  `<!-- TODO: screenshot of populated chart, tooltip hover, and empty state -->`.

## Submitting (only with `--submit`)

After the user approves every PR:

- Stack mode: `gh stack submit --auto` (pushes every branch and creates drafts; add `--open` only if
  the user asks), then `gh stack view --json` to map branches to new PR numbers, then for each:
  `gh pr edit <number> --title "<title>" --body-file <tmpfile>`.
- Single mode: `git push -u origin <branch>`, then
  `gh pr create --draft --base <default-branch> --title "<title>" --body-file <tmpfile>`.

Write each approved body (without the outer fence) to a `mktemp` file using the file-write tool, not
a heredoc (bodies contain backticks). If any `{{ }}` or `<!-- TODO -->` placeholders remain, list
them and ask the user to confirm before submitting. Report the PR URLs when done.

## Common mistakes

| Mistake | Fix |
|---|---|
| Drafting every PR in one response | One PR, then wait for "next" |
| `[MNTN-123](https://...)` or a ticket title | Bare URL only |
| Listing PRs from the same stack | Cross-project PRs only |
| Inventing testing steps or a Jira host | Placeholder, or ask |
| Decisions hidden in Description | Put them in Review Notes |
| Terse, abbreviated prose | Full sentences |
| Running submit without `--submit` | User runs it; just provide text |
