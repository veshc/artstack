# Quickstart

Ten minutes from clone to first command.

## 1. Install

```bash
git clone --depth 1 https://github.com/veshc/artstack.git ~/artstack
cd ~/artstack && ./setup
```

The setup script copies the ten commands into `~/.claude/commands/artstack/` and creates `context/art.md` and `context/team.md` from templates. It does nothing else: no network calls, no telemetry.

## 2. Describe your train and team

Fill in the two context files. This is where the value comes from; vague context produces vague output.

- `context/art.md`: PI dates and objectives, teams, cross-team dependencies, architectural runway, NFRs, definition of done. See `context/examples/art.example.md` for a filled-in model.
- `context/team.md`: your stack, test frameworks, work item conventions, review rules, cadence. See `context/examples/team.example.md`.

Copy the repo's `CLAUDE.md` into the project where you run Claude Code (or merge its sections into your existing `CLAUDE.md`), and make sure the `@context/...` paths resolve from there.

Refresh `art.md` at every planning-interval boundary. Stale context is worse than no context because it is confidently wrong.

## 3. Optional: connect your tracker

With an Azure DevOps or Jira MCP server configured (see `integrations/`), commands fetch real work items by ID instead of working from pasted text. Read-only scopes only. Without a connection, every command accepts pasted item text.

## 4. Run your first command

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

Full command reference: `docs/commands.md`. Worked end-to-end example: `examples/payment-status-feature/`.
