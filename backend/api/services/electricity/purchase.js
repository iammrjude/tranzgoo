const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { electricityProviders, findById } = require('../../../src/lib/catalog');
const { ApiError } = require('../../../src/lib/errors');
const { formatKobo, parseAmountToKobo } = require('../../../src/lib/money');
const { chargeWallet } = require('../../../src/lib/purchases');
const { requireFields } = require('../../../src/lib/validation');

module.exports = withApi(
  async function electricityPurchase(req, res) {
    const user = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['provider', 'meterNumber', 'amount']);

    const provider = findById(electricityProviders, body.provider);

    if (!provider) {
      throw new ApiError(400, 'Unsupported electricity provider');
    }

    const result = await chargeWallet({
      user,
      amountKobo: parseAmountToKobo(body.amount),
      type: 'electricity',
      description: `${provider.name} electricity purchase`,
      metadata: {
        provider: provider.id,
        meterNumber: String(body.meterNumber).trim(),
        meterType: body.meterType || 'prepaid'
      }
    });

    return sendSuccess(
      res,
      201,
      {
        token: `DEMO-${Date.now()}`,
        transaction: result.transaction,
        wallet: {
          balance: formatKobo(result.wallet.balanceKobo),
          balanceKobo: result.wallet.balanceKobo
        }
      },
      'Electricity purchase successful'
    );
  },
  {
    methods: ['POST']
  }
);
