# /demo-prep iteration-2 (abridged output, Falcon segment)

## Demo narrative

This PI we committed to letting customers answer "did my payment go through" without calling support (PI-14 objective 1). Two iterations in, you will see a customer's payments page update live as a payment completes in the ledger, and what the customer sees when a payment fails.

## Run sheet

| # | Segment | Story | Objective | Minutes | Driver |
| --- | --- | --- | --- | --- | --- |
| 1 | Statuses at a glance | See recent payment statuses | Obj 1 | 3 | Priya |
| 2 | Live update, end to end | Status updates live + BFF enabler | Obj 1 | 4 | Priya |
| 3 | When a payment fails | Failed payment guidance (partial) | Obj 1 | 2 | Marco |
| | Honesty and feedback | | | 2 | Marco |

Total 11 minutes against a 12-minute slot.

## Segments

### 1. Statuses at a glance
Setup: demo tenant, customer account "demo-cust-14" (seeded: 37 payments across all four states), portal at demo environment URL, logged out.
Steps:
1. Log in as demo-cust-14, open Payments. Expect: list renders with status chips, most recent first.
2. Point out the four states on screen and the 90-day window label.
3. Tab through three rows with the keyboard, screen reader off but caption visible. Expect: status announced in the row's accessible label, not color-alone.
Money shot: one screen answering the question that generates 900 support calls a month.
Feedback prompt: "Is this status granularity enough for the support team, or do you need sub-states of processing?"

### 2. Live update, end to end
Setup: same session, Payments page open. Badger's staging ledger console on the second screen (agreed with Badger PO; their event stream v2 is live in staging as of iteration 2).
Steps:
1. Marco triggers completion of payment pay-demo-021 in the staging ledger.
2. Watch the row. Expect: chip flips from Processing to Completed within 30 seconds, no refresh. Say the measured staging p95: currently 11 seconds.
Money shot: the chip flipping with nobody touching the browser.
Feedback prompt: "Would you want an optional notification when a payment completes, or is passive display enough?"

### 3. When a payment fails
Setup: payment pay-demo-030 seeded as failed with mapped reason code INSUF-01.
Steps:
1. Expand the failed row. Expect: plain-language reason and next-step line.
Money shot: no jargon on screen.

## Not demoed and why

- Unmapped failure codes fall back correctly but wording sign-off from support is still pending (content dependency, no owner yet; raised again this week). Showing only the mapped path.
- 500-payment performance story slipped to iteration 3: virtualization took the estimate over; page currently proven to 200 payments within budget.
- Failed-payment guidance is demoed with seeded data, not a real ledger failure; staging cannot safely produce one.

## Fallbacks and pre-demo checklist

- Fallback for segment 2: 40-second screen recording of yesterday's staging run, on Marco's desktop, if the cross-team live path misbehaves.
- Fallback for login issues: second seeded account demo-cust-15.
- Checklist: staging event stream healthy (check with Badger 30 min before), accounts log in, data reseeded, notifications off, second screen mirroring tested, recording file opens.

## Open questions

- Confirm Badger PO availability at 9am for the live trigger, or pre-agree the recording.
- Does the stakeholder group want the support-call metric baseline shown next demo? (Trend data available from iteration 4.)
