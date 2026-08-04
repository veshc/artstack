// Produced by /automate for story "Status updates live" (abridged example).
// Follows the Falcon team's conventions from team.md: Playwright, page-object
// pattern, @smoke tag on the happy path, stubbed v2 events via the test harness.
// One behavior per test; no sleeps, condition-based waits only.

import { test, expect } from '@playwright/test';
import { PaymentsPage } from './pages/payments.page';
import { seedCustomer, emitStatusEvent, stopEventStream } from './harness/portal-harness';

test.describe('payment status live updates', () => {
  test('row updates when a v2 status event arrives @smoke', async ({ page }) => {
    const customer = await seedCustomer({ payments: [{ id: 'pay-001', status: 'processing' }] });
    const payments = new PaymentsPage(page);
    await payments.gotoAs(customer);
    await expect(payments.statusCell('pay-001')).toHaveText('Processing');

    await emitStatusEvent({ paymentId: 'pay-001', status: 'completed', schema: 'v2' });

    // CI asserts a tight bound against stubbed events; the 30s NFR is measured
    // in the iteration perf pass, not here (see test plan, gaps section).
    await expect(payments.statusCell('pay-001')).toHaveText('Completed', { timeout: 10_000 });
  });

  test('duplicate events do not flicker or double-render @regression', async ({ page }) => {
    const customer = await seedCustomer({ payments: [{ id: 'pay-002', status: 'processing' }] });
    const payments = new PaymentsPage(page);
    await payments.gotoAs(customer);

    await emitStatusEvent({ paymentId: 'pay-002', status: 'completed', schema: 'v2' });
    await emitStatusEvent({ paymentId: 'pay-002', status: 'completed', schema: 'v2' });

    await expect(payments.statusCell('pay-002')).toHaveText('Completed', { timeout: 10_000 });
    expect(await payments.renderCountFor('pay-002')).toBe(2); // initial + one update
  });

  test('out-of-order event does not regress shown status @regression', async ({ page }) => {
    const customer = await seedCustomer({ payments: [{ id: 'pay-003', status: 'processing' }] });
    const payments = new PaymentsPage(page);
    await payments.gotoAs(customer);

    await emitStatusEvent({ paymentId: 'pay-003', status: 'completed', schema: 'v2' });
    await expect(payments.statusCell('pay-003')).toHaveText('Completed', { timeout: 10_000 });

    // late-arriving stale event
    await emitStatusEvent({ paymentId: 'pay-003', status: 'processing', schema: 'v2' });

    await expect(payments.statusCell('pay-003')).toHaveText('Completed');
  });

  test('stream down: statuses load on refresh and notice is shown @regression', async ({ page }) => {
    const customer = await seedCustomer({ payments: [{ id: 'pay-004', status: 'received' }] });
    await stopEventStream();

    const payments = new PaymentsPage(page);
    await payments.gotoAs(customer);

    await expect(payments.statusCell('pay-004')).toHaveText('Received');
    await expect(payments.liveUpdatesNotice()).toHaveText(/live updates paused/i);
    expect(await payments.consoleErrors()).toHaveLength(0);
  });
});
