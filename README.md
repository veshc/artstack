# ArtStack

AI workflows for teams on agile release trains.

ArtStack is an open-source set of Claude Code commands for software engineers and QA automation engineers working on large agile trains. It adapts the idea behind [gstack](https://github.com/garrytan/gstack), role-embodied AI workflows, from the solo-founder world to enterprise release-train delivery: planning intervals, WSJF prioritization, architectural runway, system demos, and test automation at scale.

More work in less time, for the people on the train who actually live in a terminal.

> **Status: dogfooding.** We are running ArtStack on a live agile release train for one full planning interval before calling it 1.0. Measured results will be published here when the PI completes.
>
> Placeholder for dogfood numbers: hours saved on PI prep, artifact acceptance rate, test authoring time. Real numbers or no claim.

## Why not just gstack

gstack is excellent and this project would not exist without it. But it is built for a solo founder shipping to main: CEO reviews, office hours, founder mode. On a release train you already have a product owner, a system architect, gated PRs, and a train cadence. ArtStack keeps what transfers (role embodiment, planning-first workflow, review rigor) and replaces the startup framing with train roles and train artifacts.

## Two tracks, ten commands

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

ArtStack reads a small context layer of plain markdown you own:

- `art.md`: PI dates and objectives, teams, dependencies, runway, NFRs, definition of done
- `team.md`: your stack, test frameworks, norms, cadence
- your repo's `CLAUDE.md`: standard project context

Fill in two files, and every command operates with your train's context. Refresh `art.md` each planning interval.

## Live work-item data

Commands can read your backlog through existing MCP servers for Azure DevOps and Jira (config templates in `integrations/`). Read-only scopes, your own credentials, running on your machine. ArtStack never sees, stores, or proxies your data. Nothing writes back to your tracker in v1.

## Built for locked-down enterprises

- Works through enterprise LLM gateways; no hardcoded endpoints
- Zero telemetry, no phone-home, no update checks
- Everything is auditable markdown plus one small setup script
- No companion apps, no hosted services, no captive tooling
- `docs/security.md` is a ready-made pack for your security review

## Install

```bash
git clone --depth 1 https://github.com/veshc/artstack.git ~/artstack
cd ~/artstack && ./setup
```

The setup script copies the ten commands into `~/.claude/commands/artstack/` and creates your `context/art.md` and `context/team.md` from templates. Fill those in (filled examples in `context/examples/`), wire the repo `CLAUDE.md` into your project, and start with `/pi-prep`. Full walkthrough: `docs/quickstart.md`.

## Repo layout

```
commands/         the ten command prompts (installed by ./setup)
context/          art.md and team.md templates plus filled examples
integrations/     read-only MCP config templates for Azure DevOps and Jira
docs/             quickstart and per-command reference
examples/         one feature walked end to end (feature, stories, tests, demo)
CLAUDE.md         context wiring to copy into your project
setup             install script (copies files, nothing else)
```

## Credits and license

MIT. ArtStack began as an adaptation of [gstack](https://github.com/garrytan/gstack) by Garry Tan (MIT); ported material retains its copyright notice, and `CREDITS.md` lists what was ported and what is new. This project is not affiliated with or endorsed by any scaled agile framework organization; it is written for teams on agile release trains, whatever process name they run under.

## Contributing

The Jira integration track and new command proposals are the best places to start. See `docs/adoption.md` for the individual-dev-to-team rollout path. Issues and PRs welcome once the repo is public.
