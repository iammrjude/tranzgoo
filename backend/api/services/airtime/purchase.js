const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { airtimeNetworks, findById } = require('../../../src/lib/catalog');
const { ApiError } = require('../../../src/lib/errors');
const { formatKobo, parseAmountToKobo } = require('../../../src/lib/money');
const { chargeWallet } = require('../../../src/lib/purchases');
const { requireFields } = require('../../../src/lib/validation');

module.exports = withApi(
  async function airtimePurchase(req, res) {
    const user = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['network', 'phone', 'amount']);

    const network = findById(airtimeNetworks, body.network);

    if (!network) {
      throw new ApiError(400, 'Unsupported airtime network');
    }

    const amountKobo = parseAmountToKobo(body.amount);

    const result = await chargeWallet({
      user,
      amountKobo,
      type: 'airtime',
      description: `${network.name} airtime purchase`,
      metadata: {
        network: network.id,
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
      'Airtime purchase successful'
    );
  },
  {
    methods: ['POST']
  }
);
