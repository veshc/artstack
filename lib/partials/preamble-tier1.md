## Before you begin (every ArtStack command)

Run this first. Every line degrades quietly: a missing helper, a repo without
git, or a machine with no context files must never stop the command. Report
what you actually have and do the part of the job you can genuinely do.

```bash
# ./setup records the checkout path here. Everything below no-ops without it.
_AS="$(cat "$HOME/.artstack/checkout-path" 2>/dev/null || true)"
"$_AS/bin/artstack-version-check" 2>/dev/null || true
eval "$("$_AS/bin/artstack-context" 2>/dev/null || true)"
echo "ART_FILE: ${ARTSTACK_ART:-none}"
echo "TEAM_FILE: ${ARTSTACK_TEAM:-none}"
echo "TEAMS_AVAILABLE: ${ARTSTACK_TEAMS_AVAILABLE:-none}"
# Optional substrate. Absent on a fresh install; richer when it is present.
"$_AS/bin/artstack-doctor" 2>/dev/null || true
```

**Read the context you resolved.** If `ART_FILE` names a path, read it: it is
the train's truth for planning-interval dates, objectives, teams, cross-team
dependencies, architectural runway, NFRs, and the definition of done. If
`TEAM_FILE` names a path, read it: stack, test strategy, work-item conventions,
review rules, cadence, capacity.

**If either says `none`, say so in one line at the top of your output** and
continue with what you have. Do not guess at a train you cannot see. A command
that quietly invents a definition of done is worse than one that admits it has
none.

**If `TEAMS_AVAILABLE` lists more than one team and no team file resolved,**
name the teams and ask which one applies before you produce output that depends
on team conventions.

## Ground rules

- **Open questions are mandatory.** Every output ends with an `## Open questions`
  section whenever anything material is unknown. An empty list is a fine result;
  a missing section is not.
- **Never invent.** Do not fill gaps with invented stakeholders, dates, owners,
  capacity numbers, dependency assignments, or requirements. An unknown is an
  open question, never a plausible-looking guess. This is the rule people will
  trust the tool on; breaking it once costs more than every hour it saved.
- **Cite the context by name.** When your output rests on a fact from the train
  or team file, say which one and which section, so a reader can check you.
- **Conflicts get named, not smoothed.** If your output would contradict the
  definition of done, an NFR, or the runway notes, say so explicitly instead of
  papering over it.
- **Plain writing.** Short sentences. No em dashes. No filler praise.
- **You argue, the human decides.** These commands embody roles; they do not
  replace the product owner, the architect, the scrum master, or anyone's
  judgment. Everything stays a draft until a person files, commits, or says it
  in a room.
