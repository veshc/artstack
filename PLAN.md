# ArtStack Implementation Plan

Date: 2026-08-04
Repo target: github.com/veshc/artstack (personal account, open source)
Tagline: AI workflows for teams on agile release trains.

Basis: the office-hours evaluation returned a conditional pass. Conditions carried into this plan: target users are software engineers and QA automation engineers on release trains (two equal tracks), Essential-level scope only, Jira/ADO read integration is the core build, and we dogfood on one of our own ARTs for one full PI before publishing. Starting point is Garry Tan's gstack (MIT).

## 1. Repo structure: fresh repo, ported commands (recommended)

Recommendation: **fresh repo, not a fork.** Reasons:

- Roughly a quarter of gstack is captive to its own ecosystem (gstack browser, gbrain, /sync-gbrain). We are dropping all of it, plus the founder framing. A fork carries history, naming, and defaults we would spend the whole project stripping out.
- Enterprise security reviewers will read this repo. A clean tree where every file exists on purpose reviews faster than a fork with vestigial history.
- MIT does not require forking. We port the commands we want, keep gstack's copyright notice on ported material, and credit clearly (section 7).

Layout:

```
artstack/
  README.md
  LICENSE            MIT, with gstack attribution for ported portions
  CREDITS.md         origin story, what was ported from gstack and what is new
  setup              install script: clone into ~/.claude/skills/artstack
  commands/
    engineer/        pi-prep, wsjf, feature-review, arch-runway, review, demo-prep
    qa/              test-plan, automate, regression, defect
  context/           ART-context CLAUDE.md templates (art.md, team.md, repo snippet)
  integrations/
    ado/             MCP config template plus query conventions
    jira/            MCP config template plus query conventions
  docs/
    commands.md      full reference for every command
    adoption.md      individual dev install through team rollout
    security.md      review pack for enterprise security teams
  examples/          worked examples with sanitized artifacts
```

## 2. Command set

Each command embodies a role, the gstack trick, but the roles are train roles, not startup roles. Every command reads the ART context layer (section 3) and, where connected, live work items via MCP (section 4). All output is markdown the user reviews before it goes anywhere.

### Engineer track

- **/pi-prep**: product owner lens. Takes an epic or feature from Jira/ADO, decomposes to features/stories with acceptance criteria, flags dependencies on other teams, drafts PI-planning inputs (objectives, risks, load estimate against capacity). Ported from the /office-hours reframing pattern, rebuilt for planning-interval prep.
- **/wsjf**: prioritization analyst lens. Structured WSJF scoring with evidence: user/business value, time criticality, risk reduction and opportunity enablement, job size, each argued rather than guessed, with a comparison table across the candidate set. Output is a recommendation the PO can defend, not a decree.
- **/feature-review**: product owner challenge session. The direct adaptation of /plan-ceo-review with the founder framing removed. Four modes preserved from gstack (scope expansion, selective expansion, hold scope, scope reduction) because they map cleanly to feature negotiation inside a PI.
- **/arch-runway**: system architect lens. Adapted from /plan-eng-review. Reviews a plan against the architectural runway and NFRs recorded in the ART context: does this feature consume runway, extend it, or ignore it. Locks data flow, edge cases, and test approach before build.
- **/review**: staff-engineer code review, ported from gstack nearly unchanged. This one already works; adaptation is limited to respecting gated-PR workflows (no push-to-main assumptions).
- **/demo-prep**: takes the iteration's completed stories and produces a system-demo script: what to show, in what order, tied back to PI objectives, with a risks-and-not-done honesty section.

### QA automation track

- **/test-plan**: test architect lens. From a feature and its acceptance criteria, produces a test plan: risk-based prioritization, what gets automated vs manual, coverage mapping against acceptance criteria, NFR test needs pulled from ART context.
- **/automate**: automation engineer pair. Writes automated tests for a story against the team's declared framework (from team context: e.g. Playwright, Selenium, pytest, Postman/newman). Follows the codebase's existing patterns; adapted from gstack's /qa which drives a real browser, kept here for web UI verification loops.
- **/regression**: regression strategist. Given a diff or a feature, identifies blast radius, selects the regression suite to run, flags gaps where changed code has no covering test, and generates the missing tests.
- **/defect**: defect analyst. From a failure (log, screenshot, failing test), writes a defect report in the team's Jira/ADO template: reproduction steps, expected vs actual, severity argument, suspected cause from code reading. Read-only in v1: it drafts the report as markdown; the human files it.

Deferred to backlog, not v1: /inspect-adapt (I&A prep), /iteration-retro, write-back commands. Ten commands is already at the edge of learnable; gstack's own reviews say 35 was too many.

## 3. ART-context CLAUDE.md layer

Three layers, all plain markdown, all in the repo owner's control, no secrets in any of them:

1. **art.md** (train level): PI number and dates, PI objectives, teams on the train and what they own, cross-team dependencies, architectural runway summary, NFRs, definition of done. Maintained by whoever adopts first; regenerated each PI (a /pi-prep subcommand drafts the update from Jira/ADO reads, human commits it).
2. **team.md** (team level): team norms, tech stack, test framework and strategy, code review rules, iteration cadence, capacity notes.
3. **Repo CLAUDE.md snippet**: standard project context per gstack's original pattern, plus an include pointing at the two files above.

Design rule: the context layer is data, commands are behavior. A team adopts ArtStack by filling in two markdown files, same as gstack's CLAUDE.md customization step, and everything is auditable by reading the files.

## 4. Jira/ADO integration: MCP, read-only first

- **Use existing MCP servers, do not build one.** Atlassian and Microsoft both ship MCP servers for Jira and Azure DevOps. ArtStack ships config templates and query conventions, not server code. That keeps our maintenance surface at prompts and docs.
- **Read-only scopes in v1.** Tokens are the individual user's own credentials with read scopes: work items, iterations, area paths, backlogs. Commands read epics/features/stories, WSJF fields, iteration assignments, and PI/iteration dates. Nothing writes back to Jira/ADO in v1; /defect and /pi-prep produce markdown the human pastes or files.
- **ADO first, Jira second.** Our own trains run on ADO, so dogfooding forces ADO to work. Jira templates ship at launch but marked community-validated after external users confirm.
- **Data flow stays local.** MCP servers run on the developer's machine with their credentials. ArtStack never sees, stores, or proxies work-item data.
- v2 candidates, opt-in only: write-back (file the defect, create the stories) behind an explicit flag.

## 5. Enterprise constraints (non-negotiable)

- **Gateway-friendly.** Works with whatever endpoint Claude Code is configured for, including enterprise gateways (Bedrock, Vertex, corporate proxies). No hardcoded API endpoints, no assumptions about anthropic.com being reachable.
- **Zero telemetry.** No phone-home, no analytics, no update checks that send data. The setup script clones and copies files, nothing else.
- **Auditable by reading.** Everything is markdown and a small shell script. docs/security.md is the pre-written pack for a security reviewer: what it reads, what it writes, what leaves the machine (answer: prompts to the org's own configured model endpoint, nothing else).
- **No captive tooling.** No companion browser, no memory service, no hosted anything. This is the direct lesson from gstack's critical reviews.

## 6. Licensing and naming

- MIT license. Ported gstack material keeps its copyright notice in LICENSE; CREDITS.md states plainly that ArtStack started from Garry Tan's gstack and lists what was ported vs written new.
- The scaled-agile framework name is trademarked. It stays out of the project name, tagline, and marketing copy. Docs may reference it descriptively and factually where unavoidable, with no implication of endorsement or certification. House phrasing everywhere: "teams on agile release trains," "planning intervals," "trains."
- Name: ArtStack. ART (agile release train) plus stack, and the gstack lineage is audible in it, which is the point.

## 7. Milestones

1. **Scaffold (weeks 1-2).** Repo private at veshc/artstack. Layout, LICENSE, CREDITS, setup script, context templates, security.md skeleton.
2. **Commands (weeks 2-6).** Engineer track first (port /review, adapt /feature-review and /arch-runway, write /pi-prep, /wsjf, /demo-prep), then QA track (adapt /qa into /automate, write /test-plan, /regression, /defect). Each command gets a worked example in examples/ before it counts as done.
3. **Integration (weeks 5-8, overlaps).** ADO MCP config and query conventions working against our real project; Jira templates drafted. Read-only verified: token scopes documented in security.md.
4. **Dogfood PI (one full planning interval, roughly 10-12 weeks).** One of our ARTs, both tracks, engineers and QA automation engineers. Metrics defined before the PI starts: hours to produce PI-planning inputs (vs last PI), story and test authoring time, review turnaround, percent of generated artifacts used with minor or no edits, defect report acceptance rate. Mid-PI checkpoint to fix what is not being used; a command nobody ran twice gets cut or rewritten.
5. **Publish (after PI ends, target early 2027).** Repo public with dogfood numbers in the README. No launch without the numbers; the numbers are the launch.

## 8. Launch

- README leads with the dogfood results: "measured across one 12-week planning interval on a live train: X hours saved on PI prep, Y percent of drafts used as-is." Real numbers or no claim.
- Announce: Show HN, r/ClaudeAI and r/agile, LinkedIn (the practitioner audience for scaled agile lives there), X with a nod to gstack lineage, and gstack's own discussions/community since "gstack does not fit process-heavy orgs" is a known gap we are filling.
- A short launch post (personal blog or LinkedIn article): why gstack does not fit release trains, what we changed, what we measured.
- Contribution guide ready at launch: the Jira track and additional command ideas are the obvious first asks for the community.

## What to build first, in one line

The engineer track's /pi-prep against live ADO data, because it is the command with the clearest before/after time measurement, and the next PI boundary is the natural deadline that forces the integration to be real.
