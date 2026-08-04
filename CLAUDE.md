# ArtStack context wiring

This file wires the ArtStack context layer into a Claude Code session. Copy it into your project root as CLAUDE.md, or merge these sections into your existing CLAUDE.md.

## Read these before any ArtStack command

- @context/art.md describes the release train: planning interval dates, objectives, teams, cross-team dependencies, architectural runway, NFRs, definition of done.
- @context/team.md describes this team: stack, test frameworks, norms, cadence, review rules.

Treat both files as authoritative. If a command's output would conflict with the definition of done, the NFRs, or the runway notes, say so explicitly instead of papering over it.

## Ground rules for all ArtStack commands

- You are working inside a large train with a fixed cadence, gated PRs, and existing roles. Never assume you can push to main, skip review, or change scope unilaterally.
- Work items live in Azure DevOps or Jira. If an MCP connection is available, read the real item instead of guessing. Read-only: never create, update, or comment on work items. Draft everything as markdown for a human to file.
- Every output ends with an "Open questions" section when anything material is unknown. Do not fill gaps with invented stakeholders, dates, or requirements.
- Match artifacts to this team's templates in context/team.md where they exist.
- Plain writing. Short sentences. No em dashes.

## Command map

Engineer track: /pi-prep, /wsjf, /feature-review, /arch-runway, /review, /demo-prep.
QA automation track: /test-plan, /automate, /regression, /defect.

Typical flow for a feature: /pi-prep to decompose it, /wsjf if priority is contested, /feature-review to challenge scope, /arch-runway to lock the technical approach, build, /review before the PR, /test-plan then /automate for coverage, /regression before merge to a release branch, /demo-prep at iteration end. /defect any time a failure needs a report.
