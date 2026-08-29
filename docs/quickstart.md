# Quickstart

Ten minutes from clone to first command.

## 1. Install

```bash
git clone https://github.com/veshc/artstack.git ~/src/artstack
cd ~/src/artstack && ./setup
```

This regenerates the skill files from their templates and symlinks them into
`~/.claude/skills/`. It does nothing else: no network calls, no telemetry, no
update check.

If another skill suite already owns one of the names (gstack ships `/review`
too), setup installs that one as `artstack-review` and leaves the existing
skill alone. `./setup --check` shows what is installed; `./setup --uninstall`
removes it.

## 2. Describe your train and team

From your product repository, not from the ArtStack checkout:

```bash
cd /path/to/your/product/repo
~/src/artstack/setup --init-context --team <your-team-name>
```

That creates the train file and your team's file. Fill them in. This is where
the value comes from; vague context produces vague output.

- `.artstack/art.md`: PI dates and objectives, teams on the train, cross-team dependencies, architectural runway, NFRs, definition of done. One per repo, shared by every team. See `context/examples/art.example.md`.
- `.artstack/teams/<your-team>.md`: your stack, test frameworks, work item conventions, review rules, cadence. See `context/examples/team.example.md`.

Commit them. They belong with the code, and a teammate who installs ArtStack
then gets your team's context for free.

There is nothing to wire up and no `CLAUDE.md` to copy. Every skill resolves
these files at runtime and tells you which ones it found. If it reports
`ART_FILE: none`, it says so at the top of its output rather than quietly
running with no train context.

If several teams work in this repo, each gets a file under `.artstack/teams/`.
The repo's default is named in `.artstack/active-team`; pass `--team <name>` to
act as a different one for a single command. When several teams exist and
nothing selects one, skills stop and ask rather than guessing — being filed
against the wrong team's backlog is worse than being asked.

Refresh `art.md` at every planning-interval boundary. Stale context is worse than no context because it is confidently wrong.

## 3. Optional: connect your tracker

With an Azure DevOps or Jira MCP server configured (see `integrations/`), commands fetch real work items by ID instead of working from pasted text. Read-only scopes only. Without a connection, every command accepts pasted item text.

## 4. Run your first skill

You do not have to memorise the names. The skills carry trigger phrases, so
describing the work usually reaches the right one: "break this feature down
into stories", "review my changes", "what could this change break". `/artstack`
routes explicitly if you would rather ask.

Engineers, start where the leverage is highest:

```
/pi-prep 12345
```

You get stories with acceptance criteria, dependencies, ROAM-ready risks, a load estimate, and proposed objective wording, ready for planning. Then walk the flow:

```
/feature-review 12345 hold     challenge the scope
/arch-runway 12345             lock the technical plan
... build ...
/review                        staff-engineer pass before the PR
/demo-prep iteration-3         script your system-demo segment
```

QA automation engineers:

```
/test-plan 12345               risk-based plan mapped to acceptance criteria
/automate PORTAL-1301          write the tests, run them, package commits
/regression feature/pay-status blast radius, suite selection, gap filling
/defect "checkout 500 on retry" complete defect report, you file it
```

## 5. The one rule

Read the output before you use it. These commands embody roles and produce strong drafts; they do not replace the product owner, the architect, or your judgment. Everything stays draft markdown until a human files, commits, or says it in a room.

Full reference: `docs/commands.md`. Worked end-to-end example: `examples/payment-status-feature/`. Rolling it out to a team: `docs/adoption.md`. Security review pack: `docs/security.md`.
