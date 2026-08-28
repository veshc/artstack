# ArtStack

AI workflows for teams on agile release trains.

ArtStack is an open-source set of Claude Code commands for software engineers and QA automation engineers working on large agile trains. It adapts the idea behind [gstack](https://github.com/garrytan/gstack), role-embodied AI workflows, from the solo-founder world to enterprise release-train delivery: planning intervals, WSJF prioritization, architectural runway, system demos, and test automation at scale.

More work in less time, for the people on the train who actually live in a terminal.

> **Status: dogfooding.** We are running ArtStack on a live agile release train for one full planning interval before calling it 1.0. Measured results will be published here when the PI completes.
>
> Placeholder for dogfood numbers: hours saved on PI prep, artifact acceptance rate, test authoring time. Real numbers or no claim.

## Why not just gstack

gstack is excellent and this project would not exist without it. But it is built for a solo founder shipping to main: CEO reviews, office hours, founder mode. On a release train you already have a product owner, a system architect, gated PRs, and a train cadence. ArtStack keeps what transfers (role embodiment, planning-first workflow, review rigor) and replaces the startup framing with train roles and train artifacts.

## Two tracks, ten skills

### Engineer track

| Command | Role | What it does |
| --- | --- | --- |
| `/pi-prep` | Product owner | Decomposes an epic/feature into stories with acceptance criteria, flags cross-team dependencies, drafts planning inputs |
| `/wsjf` | Prioritization analyst | Evidence-based WSJF scoring with an argued comparison table |
| `/feature-review` | Product owner | Challenges scope in four modes: expand, selectively expand, hold, reduce |
| `/arch-runway` | System architect | Reviews plans against architectural runway and NFRs, locks data flow and edge cases |
| `/review` | Staff engineer | Deep code review that catches what CI misses |
| `/demo-prep` | Presenter | Builds a system-demo script from the iteration's completed work |

### QA automation track

| Command | Role | What it does |
| --- | --- | --- |
| `/test-plan` | Test architect | Risk-based test plan mapped to acceptance criteria, automation vs manual split |
| `/automate` | Automation engineer | Writes automated tests in your team's framework, following your existing patterns |
| `/regression` | Regression strategist | Blast-radius analysis, suite selection, gap detection, missing-test generation |
| `/defect` | Defect analyst | Drafts a complete defect report from a failure; you review and file it |

## How it knows your train

ArtStack reads a small context layer of plain markdown you own, living in the
repository you are working in:

```
<your repo>/.artstack/art.md     PI dates and objectives, teams, dependencies,
                                 runway, NFRs, definition of done
<your repo>/.artstack/team.md    your stack, test frameworks, norms, cadence
```

Create them with `./setup --init-context`, run from your product repo, then
commit them so the whole team shares one copy. Refresh `art.md` each planning
interval.

Every skill reports which files it resolved and says so plainly when one is
missing, rather than running with no context and not mentioning it. A repo
shared by several teams can keep one file per team under `.artstack/teams/`.

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
