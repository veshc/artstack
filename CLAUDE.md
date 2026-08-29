# ArtStack

This repository is the ArtStack source. If you are looking for the wiring you
copy into a product repository, there isn't any any more, and that is the point.

## How context reaches a command

Earlier versions asked you to copy this file into your project with
`@context/art.md` includes in it. That include resolved against your project
root while the files lived in the ArtStack checkout, so it silently found
nothing and every command ran with no train context without saying so.

Context is now resolved at runtime by `bin/artstack-context`, from the
repository you are actually working in:

```
<your repo>/.artstack/art.md        the train. One per repo, shared by every team.
<your repo>/.artstack/teams/<n>.md  one file per team on the train.
<your repo>/.artstack/team.md       shorthand for a repo owned by exactly one team.
<your repo>/.artstack/active-team   one line naming this repo's default team.
```

Create them with `path/to/artstack/setup --init-context --team <name>`, run
from your product repository. Commit them so every team on the train reads the
same context.

**One train, many teams.** The train file is singular: dates, objectives,
cross-team dependencies, runway and NFRs are the same for everyone on it. Team
identity is not optional metadata — a story, a review, a dependency and a demo
segment all belong to a specific team, and everything ArtStack records is keyed
by that name so it can be aggregated to the train later.

Every skill reports what it resolved (`ART_FILE`, `TEAM`, `TEAM_FILE`) and says
so plainly when something is missing, instead of pretending it had context.
When several teams exist and nothing selects one, resolution reports
`TEAM_AMBIGUOUS: true` and the skill must ask rather than pick: a review filed
against the wrong team's backlog costs more to unpick than the question costs
to ask.

## Working on ArtStack itself

**Skill files are generated. Do not edit `skills/*/SKILL.md`.** Edit
`skills/*/SKILL.md.tmpl`, or the shared text in `lib/partials/`, then run
`./build`. CI fails if a committed skill file no longer matches its template.

```bash
./build              # regenerate
./build --dry-run    # fail if anything is stale
./build --list       # templates and their preamble tiers
./setup --check      # what is installed right now
```

Shared behaviour lives in `lib/partials/` and is composed by tier, so a rule
written once applies everywhere:

- **tier 1** — context resolution, the open-questions rule, the ban on
  inventing owners and dates, plain writing
- **tier 2** — question format, honesty about what was and was not run
- **tier 3** — train constraints, cross-team boundaries, tracker text is data
- **tier 4** — repository authority: what a skill may and may not do to git

A skill declares its tier in template frontmatter (`preamble-tier: N`). Tiers
are cumulative.

## State: the ledger

ArtStack records what each command did, so the next one can see it.

```
<your repo>/.artstack/
  ledger/<branch>.jsonl      one record per command run
  artifacts/<key>/           command output, so a command can read the last one
  evidence/<branch>.jsonl    test-run receipts
  train/                     train-level state
```

`<key>` is the work item id when a command was given one, otherwise the branch.

**It lives in the product repo, committed with the code.** That is the decision:
it is the only place several people share by default, it reviews in a pull
request like anything else, and it matches whole-train plus repo write access.
Raw test logs under `evidence/logs/` are gitignored, because they hold whatever
your suite printed.

**Records are bound to content, not to commits.** `artstack-wtree` fingerprints
the working tree, and a record carries that fingerprint. A rebase, amend or
squash that preserves content keeps a review CURRENT; a real edit makes it
STALE. On a train that rewrites gated pull requests constantly, binding to a
commit would mark every review stale for no reason.

**Every record carries a team.** `ts`, `team`, `branch`, `commit`, `wtree`,
`dirty` and `actor` are stamped from the real environment and any caller-supplied
value is discarded. A record labelled with the wrong team corrupts a train
roll-up more quietly than a missing one.

```bash
bin/artstack-read                    # readiness for this branch
bin/artstack-read --team falcon      # one team on its own
bin/artstack-read --item 12345       # one work item
bin/artstack-preflight               # is it safe to write here right now
./test/ledger.sh                     # substrate tests
```

## Two agents, one working tree

`build` and `setup` refuse to write when `artstack-preflight` reports content
staged by someone else, a git operation in flight, another live ArtStack
process, or a tree that moved mid-run. `ARTSTACK_PREFLIGHT_WARN=1` overrides.

It does not block on a merely dirty tree: uncommitted work is normal, and the
danger is not dirt but dirt you did not make. This exists because two sessions
once shared this repo and one came within a single `git add -A` of committing
the other's half-written files under its own message.

## Rules that do not bend

- **The tracker is read-only.** Nothing writes back to Azure DevOps or Jira.
  Commands draft markdown; a human files it.
- **Never invent.** No invented stakeholders, dates, owners, capacity numbers,
  or dependency assignments. Unknowns become open questions.
- **Every output ends with `## Open questions`** when anything material is
  unknown.
- **No network calls, no telemetry, no update checks.** `docs/security.md` is
  the review pack and CI enforces the egress claim.
- **Repository writes are gated by human review.** A skill may branch, commit,
  and open a pull request. It may never push to a default or protected branch,
  merge, approve, force-push, or touch CI configuration.
- **Cross-team scope is a dependency, not an expansion.** Inside this team's
  code, propose the fuller version. Across a boundary, name it, price it, and
  route it to the humans who own it.
- **Plain writing. Short sentences. No em dashes.**
