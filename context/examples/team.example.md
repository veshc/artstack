# Team context: Falcon (example, sanitized)

Example of a filled-in team.md for a portal team on the Orion train.

## What we own

Customer portal frontend (React), the portal BFF (backend-for-frontend), and the portal E2E suite.

## Stack

- Languages/frameworks: React 18 with TypeScript, .NET 8 for the BFF
- Build/CI: Azure Pipelines, YAML under /pipelines
- Branching: trunk-based; gated PRs to main; release branch cut per PI

## Test strategy

- Unit: Vitest for frontend (co-located *.test.tsx), xUnit for BFF (tests/Unit)
- Integration: BFF integration tests with WireMock stubs, tests/Integration, run in CI
- E2E/UI: Playwright in tests/e2e, page-object pattern under tests/e2e/pages, specs tagged @smoke or @regression
- API: BFF contract tests generated from OpenAPI spec
- Coverage expectations: every acceptance criterion maps to at least one automated test; happy path gets an E2E spec

## Work item conventions

- Tracker: Azure DevOps, org trudata, project Portal, area path Portal\Falcon
- Hierarchy: Epic > Feature > User Story > Task; bugs use the "Defect" template
- Story template: user-story sentence plus Gherkin acceptance criteria (Given/When/Then)
- Estimation: Fibonacci points; team capacity roughly 40 points per iteration

## Review rules

- Two approvals, one from a code owner
- No PR over 400 changed lines without a linked design note
- Failing E2E smoke blocks merge

## Iteration cadence

- 2-week iterations; planning Monday of week 1, demo and retro Friday of week 2

## Definition of done (team additions)

- Storybook entry for new shared components
- Feature flag noted in the flag register with an expiry date
