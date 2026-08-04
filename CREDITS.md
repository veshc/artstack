# Credits

ArtStack is an adaptation of the ideas in [gstack](https://github.com/garrytan/gstack) by Garry Tan (MIT license). Full credit to that project for the core insight: slash commands that embody roles, a planning-first workflow (Think, Plan, Build, Review, Test, Ship, Reflect), and CLAUDE.md as the context backbone.

## What was carried over from gstack's design

- Role embodiment: each command puts Claude into a specific professional role with its own standards and blind-spot checks.
- The planning-first, review-heavy cycle before any code is written.
- The four scope modes (scope expansion, selective expansion, hold scope, scope reduction), which appear here in /feature-review.
- The QA loop pattern of driving a real browser, fixing with atomic commits, and generating a regression test, which appears here in /automate.
- The install pattern: clone into ~/.claude and let Claude Code pick up commands and context.

## What is new in ArtStack

- The roles: product owner, prioritization analyst, system architect, test architect, automation engineer, regression strategist, and defect analyst replace founder-centric roles.
- The artifacts: epics, capabilities, features, stories, WSJF scoring, planning-interval prep, system demo scripts, and test plans replace startup planning artifacts.
- The ART context layer (art.md and team.md) describing a release train and a team, refreshed each planning interval.
- Read-only MCP integration conventions for Azure DevOps and Jira work items.
- Enterprise posture: gateway-friendly, zero telemetry, no captive tooling.

## A note on the porting

ArtStack's command files are a reimplementation of gstack's documented command patterns, written fresh for release-train roles, rather than verbatim copies of gstack source files. The lineage is structural and gratefully acknowledged. ArtStack is a personal open-source project and is not affiliated with gstack, Y Combinator, or Anthropic, and is not affiliated with or endorsed by any scaled agile framework organization.
