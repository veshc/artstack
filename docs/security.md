# Security review pack

This document exists so a security reviewer can approve or reject ArtStack
without reading every file. It states what ArtStack is, what it reads, what it
writes, what leaves the machine, and what it deliberately cannot do.

ArtStack is markdown and a handful of small shell scripts. There is no service,
no daemon, no binary, no package to install, and no account to create.

## What ArtStack is

A set of skills for Claude Code. A skill is a markdown file containing
instructions. When a person invokes one, Claude Code reads the file and follows
it. ArtStack adds no execution capability that Claude Code does not already
have; it constrains and directs the capability that is already there.

## Inventory

| Path | What it is |
|------|-----------|
| `skills/*/SKILL.md` | Generated skill instructions. Markdown. Committed so they are reviewable in git. |
| `skills/*/SKILL.md.tmpl` | The hand-written source for the above. |
| `lib/partials/*.md` | Shared instruction text composed into every skill. |
| `build` | Bash. Expands templates into `SKILL.md` files. |
| `setup` | Bash. Symlinks skills into `~/.claude/skills/`, records a version. |
| `bin/artstack-context` | Bash. Resolves which context files apply to a repo. |
| `bin/artstack-version-check` | Bash. Compares two local files. |
| `context/*.template` | Blank templates a team fills in. |
| `docs/`, `examples/` | Documentation. |

Everything is plain text except nothing. There are no binaries in this
repository.

## Network egress

**ArtStack makes no network calls.** Not at install, not at runtime, not on a
schedule.

- No telemetry, no analytics, no usage reporting, no crash reporting.
- No update check. `bin/artstack-version-check` compares two files on the local
  disk and never opens a socket. Updating is `git pull`, run by a person, on
  their own schedule.
- No licence check, no registration, no phone-home of any kind.
- No hosted service, no companion application, no browser extension, no
  database, no memory service.

You can verify this by reading the four scripts. They are short, and the only
commands they invoke are `git`, `find`, `sed`, `awk`, `diff`, `cp`, `ln`,
`mkdir`, and `cat`.

The one thing that does leave the machine is the model traffic Claude Code
already generates: the prompt, including whatever context the person's session
contains, goes to whatever endpoint Claude Code is configured to use. In a
managed enterprise that is your gateway (Bedrock, Vertex, or a corporate proxy).
ArtStack hardcodes no endpoint and makes no assumption that any particular host
is reachable.

## What ArtStack reads

- **Repository files.** Source, tests, configuration, diffs, git history — the
  same files the person running Claude Code can already read.
- **Context files.** `art.md` and `team.md` in the target repo's `.artstack/`
  directory. These are written by your team and are meant to be committed.
  They should contain no secrets, no credentials, and no customer data; the
  templates say so at the top.
- **Work items,** if and only if a tracker connection is configured. See below.

## What ArtStack writes

- **At install:** symlinks under `~/.claude/skills/`, and two small files under
  `~/.artstack/` recording the checkout path and installed version.
- **At `--init-context`:** `art.md` and `team.md` in the target repo, copied
  from blank templates.
- **At runtime:** whatever the person's session writes. Skills are instructed
  never to push to a default or protected branch, never to merge or approve a
  pull request, never to force-push, and never to modify CI configuration or
  repository settings. Those constraints are instructions to a model, not an
  enforced sandbox — see Limitations.

## Tracker access

ArtStack ships no tracker integration code. It ships configuration templates
and query conventions for MCP servers that Microsoft and Atlassian publish for
Azure DevOps and Jira.

- The MCP server runs on the developer's own machine, under their own account,
  with their own credentials.
- Recommended scopes are **read-only**: work items read, project and team read.
  `integrations/*/README.md` states this and the templates keep the token in an
  environment variable rather than a file.
- **Nothing writes back to the tracker.** No item creation, no field updates, no
  comments, no state transitions, no attachments. Every skill carries this rule
  and the skills that draft tracker content explicitly stop at markdown for a
  human to file.
- ArtStack never sees, stores, proxies, or forwards work-item data. It goes into
  the person's local session context and then to your configured model endpoint,
  exactly like any other text they might paste.

**Prompt injection.** Work-item text is written by anyone with tracker access,
which on a large train is hundreds of people plus every automated integration.
ArtStack instructs every skill to treat tracker text, log output, screenshots
and pull-request descriptions as data rather than instructions, and to surface
anything that reads as a directive rather than acting on it. This is a
mitigation, not a guarantee — see Limitations.

## Data handling guidance for adopters

- Do not put secrets, credentials, or customer personal data in `art.md` or
  `team.md`. They are committed to a repository.
- If your work items contain customer personal data, sanitise before including
  them in a prompt. This is a property of your tracker content, not of ArtStack.
- The context files describe a train: dates, objectives, team names, runway,
  NFRs. Treat them at the same classification as your internal planning
  material, and put them in the repository whose access list already matches.

## Limitations, stated plainly

A security review that only lists strengths is not useful. These are the real
edges:

1. **Skill instructions are instructions, not enforcement.** "Never push to
   main" is a constraint on a language model's behaviour, not a permission
   boundary. If you need it enforced, enforce it where it can be: branch
   protection, required reviewers, and CI. ArtStack assumes gated pull requests
   and is designed to work with them, not to replace them.
2. **Prompt-injection defence is best-effort.** Treating tracker text as data
   reduces risk substantially; it does not eliminate it. Keep tracker tokens
   read-only so the worst case stays a bad draft rather than a bad write.
3. **ArtStack inherits Claude Code's permissions.** It cannot do anything the
   person running it could not already do, and it does not reduce what they can
   do. Your existing controls on Claude Code still apply and still matter.
4. **The model endpoint sees the context.** That is inherent to using an AI
   coding assistant at all. ArtStack's contribution is that it adds no second
   destination.

## Reviewer checklist

- [ ] `grep -rn "curl\|wget\|http://\|https://" build setup bin/` — the only
      hits should be in comments, documentation URLs, and the injection
      patterns inside `bin/artstack-guard`, which exist to *detect* such
      commands in untrusted tracker text, never to run them. CI asserts both
      properties separately.
- [ ] Read `build`, `setup`, `bin/artstack-context`, `bin/artstack-version-check`
      in full. Roughly 400 lines of bash total.
- [ ] Confirm no binaries: `find . -type f -exec file {} + | grep -v text`.
- [ ] Confirm the tracker read-only rule appears in every generated skill:
      `grep -L "tracker stays read-only" skills/*/SKILL.md` should list only
      the router.
- [ ] Confirm your MCP token scopes are read-only in your own tracker.
