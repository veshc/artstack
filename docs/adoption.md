# Adoption

How ArtStack goes from one curious developer to a team that relies on it.
Nothing here requires permission from a platform team, and no step commits you
to the next one.

## Stage 1: one person, one repo

One developer installs it and uses it on their own work for a couple of weeks.

```bash
git clone https://github.com/veshc/artstack.git ~/src/artstack
cd ~/src/artstack && ./setup
cd /path/to/your/product/repo
~/src/artstack/setup --init-context
```

Fill in `.artstack/art.md` and `.artstack/team.md`. Do not commit them yet —
keep them local while you find out whether the content is right.

Start with the two commands that pay off immediately and need the least
context: `/review` before you open a pull request, and `/defect` the next time
something breaks. Both produce something you can judge in a minute.

**What you are testing:** does the output survive contact with your actual
codebase and your actual train. If `/review` finds nothing you did not already
know, twice in a row, say so — that is useful information and it belongs in an
issue.

## Stage 2: commit the context

Once `art.md` and `team.md` say something true, commit them.

This is the step that turns ArtStack from a personal tool into a team one, and
it is worth doing carefully. The context files are read by every command, so
they are also the fastest way to make every command wrong at once.

- Keep them under two pages each. Long context is skimmed context.
- Put nothing in them you would not put in a pull request. No credentials, no
  customer data, no personal data about named people.
- Refresh `art.md` at every planning-interval boundary. Stale context is worse
  than no context, because it is confidently wrong and nobody notices.
- Put the refresh on the same checklist as the planning event itself, owned by
  a person. It will not happen otherwise.

Once they are committed, a teammate who installs ArtStack gets your team's
context for free.

## Stage 3: a second and third user

Ask two colleagues to install it. Do not announce it to the team yet.

Two people is where you find out whether your context files are actually
readable by someone who did not write them, and whether the commands are
useful to someone who did not choose them. Both failures are common and both
are cheap to fix at this size.

**Watch for:** a command nobody runs twice. That is a command that is either
wrong for your train or badly explained. Cut it or rewrite it. Ten commands is
already at the edge of what a person will learn.

## Stage 4: the team

Add ArtStack to the team's onboarding and to the repo's own `CLAUDE.md`:

```markdown
## ArtStack

This repo uses ArtStack for AI-assisted train workflows.

    git clone https://github.com/veshc/artstack.git ~/src/artstack
    cd ~/src/artstack && ./setup

Train and team context live in `.artstack/`. Refresh `art.md` each planning
interval. Skills: /pi-prep /wsjf /feature-review /arch-runway /review
/test-plan /automate /regression /defect /demo-prep
```

At this point decide who owns the context files. In practice this is whoever
runs the team's planning: a scrum master, a team coach, or the product owner.
Unowned context rots within one planning interval.

## Stage 5: more than one team

Several teams on the same train can share one `art.md` — the train is the same
for all of them — while keeping separate team files:

```
.artstack/
  art.md                 the train: dates, objectives, dependencies, runway, NFRs
  teams/
    falcon.md
    orion.md
  active-team            one line, the team this repo belongs to
```

If each team has its own repository, each repository gets its own `.artstack/`
with a copy of the train file. Keeping those copies in step is a real problem
and ArtStack does not solve it yet. Until it does, one person owning the train
file and opening a pull request against each repo at the planning boundary is
tedious but honest, and it is better than four divergent copies nobody trusts.

## What to measure

If you want to know whether this is working, decide the measure before you
start, not after:

- Hours to produce planning inputs, compared against the previous interval.
- Percentage of generated artifacts used with minor or no edits.
- Defect reports accepted without a request for more information.
- Review findings that turned out to be real, and the ones that were noise.

Any of these beats an impression. A tool that feels fast and produces drafts
nobody uses is worse than no tool, and only the numbers will tell you.

## When to stop

Uninstall is one command and leaves your context files alone:

```bash
~/src/artstack/setup --uninstall
```

If a team tries this for a planning interval and does not want to continue,
that is a legitimate result worth writing down. The commands that failed are
more informative than the ones that worked.
