# /test-plan 41207 (abridged output)

## Risk ranking

1. Wrong status shown (customer believes a failed payment succeeded): money/trust damage, highest severity
2. Live update silently broken (page shows stale state with no notice): defeats the feature's purpose, hard to notice
3. v2 event contract mishandled in BFF (first consumer of Badger's schema): cross-team contract risk
4. 500-payment page busts performance budget: NFR breach, degrades whole portal impression
5. Failure reason unmapped or wrong wording: support-call driver returns, cosmetic-plus
6. Accessibility of status indicators: NFR breach (WCAG 2.1 AA)

## Coverage map (excerpt)

| Story | Criterion | Test | Level | Auto/Manual | Tag |
| --- | --- | --- | --- | --- | --- |
| See statuses | Each payment shows correct status | Status mapping table test, all four states plus unknown | Unit (BFF) | Auto | |
| See statuses | 500 payments within p95 budget | Render perf test with seeded 500-payment account | E2E | Auto | @regression |
| See statuses | Empty state | Component test, zero-payment fixture | Unit (FE) | Auto | |
| See statuses | Not color-alone, screen reader | axe scan plus manual SR pass | E2E + Manual | Both | @regression |
| Live updates | Row updates within 30s of ledger change | E2E: trigger stubbed v2 event, assert row update and latency | E2E | Auto | @smoke |
| Live updates | Stream down: refresh still works, notice shown | Integration: BFF with event source stopped | Integration | Auto | @regression |
| Live updates | No polling of ledger DB | Architecture test: BFF has no ledger DB connection string/client | Unit (BFF) | Auto | |
| Failed guidance | Mapped reason and next step shown | Component test per mapped code | Unit (FE) | Auto | |
| Failed guidance | Unmapped code: generic message, code logged | Integration: unknown code fixture, assert log + audit entry | Integration | Auto | @regression |

## Additional tests (beyond criteria)

- Idempotency: duplicate v2 events for the same transition do not flicker or double-log
- Out-of-order events: completed then late processing event must not regress the shown status
- Permissions: customer A never receives customer B's status events on the push channel (highest-severity negative test in the plan)
- Boundary: payment exactly 90 days old, and window edge across timezone change
- Reconnect: push channel drops and reconnects; missed transitions are reconciled on reconnect

## NFR coverage

| NFR | Test approach | Status |
| --- | --- | --- |
| p95 API under 300ms | BFF endpoint perf assertion in integration suite | Planned |
| WCAG 2.1 AA | axe in E2E plus manual screen-reader pass per iteration | Planned |
| Audit logging | Assert audit entries in integration tests touching customer data | Planned |
| Data residency | Covered by platform; not tested at feature level (why: infra-enforced, Kestrel owns) | N/A |
| 99.9 percent availability | Not feature-testable; degradation behavior covered by stream-down tests | Partial |

## Automation order and estimates

1. E2E happy-path skeleton (statuses render from seeded data) so it can gate PRs from day one (2 pts)
2. BFF unit suite: status mapping, architecture test (1 pt)
3. Integration: stream-down, unmapped code, audit assertions (3 pts)
4. E2E live-update with stubbed events, then permissions negative test (3 pts)
5. Perf and accessibility passes once UI stabilizes, iteration 2 (2 pts)

## Gaps and open questions

- Latency assertion strategy for "within 30s" in CI without flakiness: propose asserting under 10s against stubbed events with generous timeout, and measuring real latency in the iteration-2 perf pass instead of in CI
- Manual screen-reader pass owner needed each iteration
- Badger contract tests: who owns consumer-driven contract tests for v2 schema, us or them? Raise at next sync.
