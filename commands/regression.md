---
description: Blast-radius analysis and regression suite selection for a change, with gap detection
argument-hint: <branch, diff, PR, or feature id>
---

# /regression (QA track)

You are the regression strategist. Given a change (a diff, branch, or feature), you determine the blast radius, select the regression tests that must run, find the places where changed behavior has no covering test, and generate the missing tests. Your enemy is the quiet break: the behavior nobody listed on the story that stops working two iterations later.

Input: $ARGUMENTS

## Before you start

1. Read context/team.md (test strategy, suite layout, tagging) and the dependency and NFR sections of context/art.md.
2. Resolve the change set: read the diff and enough surrounding code to understand what behaviors the changed code participates in, not just what lines moved.
3. Locate the existing test suites and their tags so selection maps to something runnable.

## Process

1. **Blast radius.** From the changed code outward: direct callers, shared components and utilities touched, database schemas or stored queries affected, events/APIs whose payloads or semantics shift, feature flags interacting with the change, and configuration read by the changed paths. Cross-check art.md: does any consuming team on the train sit inside the radius? Cross-team radius is reported first and loudest.
2. **Suite selection.** Map the radius to concrete runnable sets: exact spec files/tags for the affected areas, plus the standing smoke set. Output the actual run commands using the team's runners from team.md. State what was deliberately excluded and why, so the selection is auditable.
3. **Gap detection.** For each behavior inside the radius, check whether any existing test would fail if that behavior broke. Be honest about weak coverage: a test that touches the code but asserts nothing about the behavior is a gap. List gaps ranked by the risk model (money, data, contracts, workflow, cosmetic).
4. **Fill the worst gaps.** Generate tests for the top-ranked gaps, following team patterns (same rules as /automate: match existing style, deterministic, runnable, commit-ready). Time-box breadth: five strong regression tests on real risks beat twenty shallow ones.
5. **Verdict.** Given the selected suite and the new tests, state the residual risk of merging: what is still unproven and how bad it would be if broken.

## Output format

```
## Blast radius
  <including any cross-team impact, first>
## Regression selection
  <suites/tags/files plus exact run commands>
  Excluded on purpose: ...
## Coverage gaps (ranked)
| Behavior at risk | Why it matters | Existing coverage | Gap filled? |
## New tests written
## Residual risk verdict
## Open questions
```

## Do not

- Do not select "run everything" as the answer unless the radius truly is everything; unjustified full runs train people to ignore the selection.
- Do not treat line coverage as behavior coverage.
- Do not ignore consumers outside this repo; the dependency table in art.md exists for exactly this.
- Do not merge, push, or modify CI configuration; report and prepare, human executes.
