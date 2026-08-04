# ART context: Orion train (example, sanitized)

Example of a filled-in art.md. Sanitized from a real train; use it as a model for tone and level of detail.

## Planning interval

- PI number: PI-14
- Dates: 2026-09-07 to 2026-11-27
- Iterations: 5 x 2 weeks plus 1 IP iteration
- Key ceremonies: PI planning Sep 3-4, system demo every second Thursday, inspect and adapt Nov 25

## PI objectives

1. Customers can see live payment status in the portal (committed, BV 9)
2. Retire the legacy notification service (committed, BV 7)
3. Cut p95 portal page load to under 1.5s (stretch, BV 5)

## Teams on the train

| Team | Owns | Key contact |
| --- | --- | --- |
| Falcon | Portal frontend, BFF | Falcon PO |
| Badger | Payments services, ledger | Badger PO |
| Kestrel | Platform, pipelines, observability | Kestrel lead |

## Cross-team dependencies this PI

| Depends on | For | Needed by |
| --- | --- | --- |
| Badger | Payment-status event stream (v2 schema) | Iteration 2 |
| Kestrel | Event hub capacity increase | Iteration 1 |

## Architectural runway

- Event backbone (Event Hubs plus schema registry) is live; new features should consume events, not poll databases.
- BFF pattern established for the portal; no direct service calls from the frontend.
- In progress this PI: standardized feature-flag service (Kestrel, ETA iteration 3). Features shipping before that use the existing config-based flags.

## Nonfunctional requirements

- p95 API response under 300ms for portal-facing endpoints
- 99.9 percent availability for payment-facing services
- WCAG 2.1 AA for all portal UI
- All customer-data access audit-logged
- Data stays in-region (EU customers on EU infrastructure)

## Definition of done

- Code reviewed and merged via gated PR
- Unit and integration tests green in CI
- Automated E2E coverage for the happy path
- Telemetry: new endpoints emit standard metrics and traces
- Documentation updated (runbook entry for new services)
- Demoed at a system demo
