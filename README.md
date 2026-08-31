# ArtStack

AI workflows for teams on agile release trains.

ArtStack is an open-source set of Claude Code commands for software engineers and QA automation engineers working on large agile trains. It adapts the idea behind [gstack](https://github.com/garrytan/gstack), role-embodied AI workflows, from the solo-founder world to enterprise release-train delivery: planning intervals, WSJF prioritization, architectural runway, system demos, and test automation at scale.

More work in less time, for the people on the train who actually live in a terminal.

> **Status: built, not yet dogfooded.** The workflow is complete end to end and
> tested, and has not yet run a full planning interval on a live train. No
> results are claimed until it has.
>
> `bin/artstack-metrics` produces the numbers, from your own ledger, locally. It
> reports command usage, how far work gets through the chain, and how long
> dependencies sit unagreed. It deliberately does not report hours saved or
> artifact acceptance: the ledger does not know them, and inventing them is
> exactly what "real numbers or no claim" was meant to prevent.

## Why not just gstack

gstack is excellent and this project would not exist without it. But it is built for a solo founder shipping to main: CEO reviews, office hours, founder mode. On a release train you already have a product owner, a system architect, gated PRs, and a train cadence. ArtStack keeps what transfers (role embodiment, planning-first workflow, review rigor) and replaces the startup framing with train roles and train artifacts.

## Nineteen skills across the lifecycle

### Plan

| Skill | Role | What it does |
| --- | --- | --- |
| `/plan-feature` | Pipeline | One feature from raw work item to locked plan: decompose, challenge scope, lock the runway, agree the test approach. Decides what the team owns, escalates what it does not |

### Engineer track

| Command | Role | What it does |
| --- | --- | --- |
| `/pi-prep` | Product owner | Decomposes an epic/feature into stories with acceptance criteria, flags cross-team dependencies, drafts planning inputs |
| `/wsjf` | Prioritization analyst | Evidence-based WSJF scoring with an argued comparison table |
| `/feature-review` | Product owner | Challenges scope in four modes: expand, selectively expand, hold, reduce |
| `/arch-runway` | System architect | Reviews plans against architectural runway and NFRs, locks data flow and edge cases |
| `/review` | Staff engineer | Deep code review that catches what CI misses |
| `/implement` | Engineer | Builds a story against the locked plan, code and tests in the same commit, on a feature branch |
| `/investigate` | Debugger | Root cause before any fix. Reproduce, trace, one hypothesis at a time, stop after three failures |
| `/ship` | Release engineer | Merges the base branch, runs tests, checks criteria, opens the pull request. Never merges it |
| `/verify` | Verifier | Checks the running system against what the story promised, after it lands |
| `/demo-prep` | Presenter | Builds a system-demo script from the iteration's completed work |

### QA automation track

| Command | Role | What it does |
| --- | --- | --- |
| `/test-plan` | Test architect | Risk-based test plan mapped to acceptance criteria, automation vs manual split |
| `/automate` | Automation engineer | Writes automated tests in your team's framework, following your existing patterns |
| `/regression` | Regression strategist | Blast-radius analysis, suite selection, gap detection, missing-test generation |
| `/defect` | Defect analyst | Drafts a complete defect report from a failure; you review and file it |

### Train track

| Skill | Role | What it does |
| --- | --- | --- |
| `/art-status` | Release train engineer | The train view across teams: activity, objectives, dependencies, and what the view cannot see |
| `/dependency` | Coordinator | Cross-team dependencies as objects with state, so "requested" and "committed" stop looking alike |
| `/inspect-adapt` | Facilitator | Evidence for the inspect and adapt session, from what actually happened |

## Who decides

Every skill classifies the decisions it reaches. MECHANICAL and TEAM choices it
takes, with reasons. PRODUCT OWNER and TRAIN choices it never takes: it presents
the options and the recommendation and stops. When unsure which side a decision
falls on, it escalates.

That boundary is recorded, not just described. `artstack-decide` logs what was
taken and what was refused, and a record on someone else's call cannot be
written as "decided".

## State

ArtStack records what each command did in `.artstack/` in your repo, committed
with the code, so the team shares one copy.

Records bind to content rather than commits: a rebase or squash that preserves
content keeps a review current, a real edit makes it stale. Every record carries
a team, so `artstack-roll` can assemble a train view from what teams already
committed — and it leads with what it cannot see before it shows a number.

```bash
bin/artstack-read                 # is this branch ready
bin/artstack-read --team falcon   # one team on its own
bin/artstack-roll                 # the train view
bin/artstack-dependency board     # who is waiting on whom
bin/artstack-decide --open        # what is waiting on a human
bin/artstack-metrics              # what ArtStack actually did here
```

## How it knows your train

ArtStack reads a small context layer of plain markdown you own, living in the
repository you are working in:

```
<your repo>/.artstack/art.md            the train: PI dates and objectives, teams,
                                        dependencies, runway, NFRs, DoD
<your repo>/.artstack/teams/<name>.md   one per team: stack, test frameworks,
                                        norms, cadence
<your repo>/.artstack/active-team       this repo's default team
```

Create them with `./setup --init-context --team <name>`, run from your product
repo, then commit them so every team on the train reads the same context.
Refresh `art.md` each planning interval.

One train, many teams: the train file is singular and shared; each team has its
own file. Team identity is explicit everywhere, because a story, a review and a
dependency each belong to a specific team.

Every skill reports which files it resolved, states which team it is acting as,
and says so plainly when something is missing, rather than running with no
context and not mentioning it. When several teams exist and none is selected, it
asks instead of picking.

## Live work-item data

Commands can read your backlog through existing MCP servers for Azure DevOps and Jira (config templates in `integrations/`). Read-only scopes, your own credentials, running on your machine. ArtStack never sees, stores, or proxies your data. Nothing writes back to your tracker in v1.

## Built for locked-down enterprises

- Works through enterprise LLM gateways; no hardcoded endpoints
- Zero telemetry, no phone-home, no update checks
- Everything is auditable markdown plus one small setup script
- No companion apps, no hosted services, no captive tooling
- `docs/security.md` is a ready-made pack for your security review, and CI
  enforces the no-egress claim rather than asking you to trust it

## Install

```bash
git clone https://github.com/veshc/artstack.git ~/src/artstack
cd ~/src/artstack && ./setup

cd /path/to/your/product/repo
~/src/artstack/setup --init-context
```

`./setup` regenerates the skill files and symlinks them into
`~/.claude/skills/`, so a `git pull` plus a re-run is the whole update story.
`--init-context` creates `.artstack/art.md` and `.artstack/team.md` in your
product repo from blank templates (filled examples in `context/examples/`).

Because the skills are symlinked rather than copied, and because they carry
`triggers` and a description, you can describe what you need in plain English
instead of memorising ten command names. `/artstack` routes explicitly if you
prefer.

If another skill suite already owns a name — gstack also ships `/review` —
setup installs that one as `artstack-review` and leaves the existing skill
untouched. `./setup --uninstall` removes everything it installed.

Full walkthrough: `docs/quickstart.md`. Rollout path: `docs/adoption.md`.

## Repo layout

```
skills/<name>/SKILL.md.tmpl   hand-written source for each skill
skills/<name>/SKILL.md        generated by ./build, committed, never hand-edited
lib/partials/                 shared behaviour composed into every skill by tier
build                         template -> SKILL.md generator; --dry-run gates CI
setup                         symlinks skills, seeds repo context, --uninstall
bin/                          small helpers (context resolution, version check)
context/                      art.md and team.md templates plus filled examples
integrations/                 read-only MCP config templates for ADO and Jira
docs/                         quickstart, reference, security pack, adoption
examples/                     one feature walked end to end
```

Skill files are generated. Edit the `.tmpl`, run `./build`, commit both.

## Credits and license

MIT. ArtStack began as an adaptation of [gstack](https://github.com/garrytan/gstack) by Garry Tan (MIT); ported material retains its copyright notice, and `CREDITS.md` lists what was ported and what is new. This project is not affiliated with or endorsed by any scaled agile framework organization; it is written for teams on agile release trains, whatever process name they run under.

## Contributing

The Jira integration track and new command proposals are the best places to start. See `docs/adoption.md` for the individual-dev-to-team rollout path. Issues and PRs welcome once the repo is public.
