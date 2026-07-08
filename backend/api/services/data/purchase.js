const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { dataPlans, findById } = require('../../../src/lib/catalog');
const { ApiError } = require('../../../src/lib/errors');
const { formatKobo, parseAmountToKobo } = require('../../../src/lib/money');
const { chargeWallet } = require('../../../src/lib/purchases');
const { requireFields } = require('../../../src/lib/validation');

module.exports = withApi(
  async function dataPurchase(req, res) {
    const user = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['planId', 'phone']);

    const plan = findById(dataPlans, body.planId);

    if (!plan) {
      throw new ApiError(400, 'Unsupported data plan');
    }

    const amountKobo = parseAmountToKobo(plan.amount);

    const result = await chargeWallet({
      user,
      amountKobo,
      type: 'data',
      description: `${plan.name} data purchase`,
      metadata: {
        planId: plan.id,
        network: plan.network,
        phone: String(body.phone).trim()
      }
    });

    return sendSuccess(
      res,
      201,
      {
        transaction: result.transaction,
        wallet: {
          balance: formatKobo(result.wallet.balanceKobo),
          balanceKobo: result.wallet.balanceKobo
        }
      },
      'Data purchase successful'
    );
  },
  {
    methods: ['POST']
  }
);
