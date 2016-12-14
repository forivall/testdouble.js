import {fetch} from './fetch';
import {categorize} from './categorize';
import {notify} from './notify';

const unusualSpending = userId => {

  console.log(fetch); // [Function: fetch]
  console.log(categorize); // [Function: categorize]
  console.log(notify); // [Function: notify]

  const payments = fetch(userId);
  const categorizedPayments = categorize(payments);
  notify(userId, categorizedPayments);
};
export {unusualSpending};
