# /pi-prep 41207 (abridged output)

## Summary and objective fit

Customers get live payment status in the portal so they stop phoning support (about 900 calls/month today). Serves PI-14 objective 1 (BV 9) directly. Success is observable two ways: status visible and fresh within 30 seconds, and support call volume for "did my payment go through" trending down.

## Stories

### Story: See recent payment statuses (5)
As a customer, I can see the status of each of my payments from the last 90 days on the payments page.
Acceptance criteria:
- Given payments exist in the window, when I open the payments page, then each shows one of: received, processing, completed, failed
- Given 500 payments in the window, then the page renders within the p95 1.5s portal budget (art.md NFR) using pagination or virtualization
- Given I have no payments, then an empty state explains what will appear here
- Screen-reader accessible per WCAG 2.1 AA (art.md NFR); status is not conveyed by color alone
Dependencies: none (uses existing ledger read API for initial load).

### Story: Status updates live (8)
As a customer, when a payment's state changes, the portal reflects it within 30 seconds without a refresh.
Acceptance criteria:
- Given the page is open and the ledger emits a status change, then the row updates within 30s
- Given the event stream is unavailable, then statuses still load on refresh and the page shows a "live updates paused" notice; no errors surface to the console
- Update mechanism follows the event backbone runway (art.md): consume Badger's v2 status events via the BFF; no polling of ledger databases
Dependencies: Badger payment-status event stream v2 (needed by iteration 2, per art.md dependency table).

### Story: Failed payment guidance (3)
As a customer with a failed payment, I can see why it failed in plain language and what to do next.
Acceptance criteria:
- Given a failed payment, then the row expands to a reason mapped from the ledger failure code and a next-step line
- Given an unmapped failure code, then a generic "contact support" message shows and the unmapped code is logged (audit-logged access per art.md NFR)
- Reason text sourced from the support team's approved wording; content is a dependency, not developer improvisation

### Enabler: Status event consumer in BFF (5)
Subscribe the BFF to the v2 status event stream, translate to a portal-facing push channel. Extends runway: first consumer of the v2 schema; document the pattern for other teams.

## Risks (ROAM-ready)

1. Badger's v2 event schema slips past iteration 2, blocking the live-update story mid-PI.
2. 30-second freshness may be unachievable at p95 through the current event hub tier (Kestrel capacity increase is also iteration 1; two dependencies stack).
3. Failure-reason wording needs support-team sign-off; content dependency with no named owner yet.
4. 500-payment render may bust the 1.5s p95 budget without virtualization work the estimate assumes is small.

## Load vs capacity

21 points of 40/iteration capacity. Realistic across two iterations alongside other committed work: initial-load story in iteration 1, enabler plus live updates in iteration 2 (aligned with the Badger dependency), failed-payment guidance in iteration 3. Pre-planning estimate for conversation, not a commitment.

## Proposed objective wording and demo statement

Objective: "Customers can answer 'did my payment go through' in the portal without calling support."
Demo statement: at the system demo we will show a payment changing state in the ledger and its status updating on a customer's open portal page within 30 seconds, plus a failed payment showing plain-language guidance.

## Open questions

- Who owns approving the failure-reason wording, and by when?
- Is the 90-day window a compliance boundary or a guess? Source needed.
- Does "recent payments" include direct debits, or card payments only?
