const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { formatKobo, parseAmountToKobo } = require('../../../src/lib/money');
const { requireFields } = require('../../../src/lib/validation');

const RATE = 0.8;

module.exports = withApi(
  async function airtimeToCashQuote(req, res) {
    await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['amount']);

    const amountKobo = parseAmountToKobo(body.amount);
    const payoutAmountKobo = Math.round(amountKobo * RATE);

    return sendSuccess(res, 200, {
      quote: {
        amount: formatKobo(amountKobo),
        amountKobo,
        payoutAmount: formatKobo(payoutAmountKobo),
        payoutAmountKobo,
        rate: RATE
      }
    });
  },
  {
    methods: ['POST']
  }
);
