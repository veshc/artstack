# Feature 41207: Live payment status in customer portal

As filed in Azure DevOps (Portal project, area Portal\Falcon, parent epic 41200 "Payment transparency").

**Description.** Customers currently phone support to ask whether a payment has gone through. Support handles roughly 900 such calls a month. We want customers to see the current status of their recent payments in the portal, updating without a page refresh, so they stop calling.

**Acceptance criteria (feature level).**

- Customer sees a status (received, processing, completed, failed) for each payment from the last 90 days
- Status updates appear in the portal within 30 seconds of the ledger state change
- Failed payments show a plain-language reason and a next step
- Works for customers with up to 500 payments in the window

**Notes.** Badger team is delivering the payment-status event stream (v2 schema) in iteration 2. Serves PI-14 objective 1 (BV 9).
