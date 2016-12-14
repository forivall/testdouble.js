import td from 'testdouble';

describe('unusualSpending() should', function() {
  it('interact correctly with fetch(), categorize() and notify()', function() {
    const fetch = td.replace('../../../lib/unusual-spending/fetch').fetch;
    const categorize = td.replace('../../../lib/unusual-spending/categorize').categorize;
    const notify = td.replace('../../../lib/unusual-spending/notify').notify;

    console.log(fetch); // { [Function: testDouble] toString: [Function] }
    console.log(categorize); // { [Function: testDouble] toString: [Function] }
    console.log(notify); // { [Function: testDouble] toString: [Function] }

    const dummyUserId = 'dummy-user-id';
    const dummyPaymentsResponse = 'dummy-payments-response';
    const dummyCategorizedPayments = 'dummy-categorized-payments';

    let unusualSpending;

    td.when(fetch(dummyUserId)).thenReturn(dummyPaymentsResponse);

    td.when(categorize(dummyPaymentsResponse)).thenReturn(
        dummyCategorizedPayments);

    unusualSpending = require('../../../lib/unusual-spending').unusualSpending;
    unusualSpending(dummyUserId);

    td.verify(notify(dummyUserId, dummyCategorizedPayments));
  });
});
