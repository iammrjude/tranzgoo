const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { cablePackages, findById } = require('../../../src/lib/catalog');
const { ApiError } = require('../../../src/lib/errors');
const { formatKobo, parseAmountToKobo } = require('../../../src/lib/money');
const { chargeWallet } = require('../../../src/lib/purchases');
const { requireFields } = require('../../../src/lib/validation');

module.exports = withApi(
  async function cablePurchase(req, res) {
    const user = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['packageId', 'smartCardNumber']);

    const cablePackage = findById(cablePackages, body.packageId);

    if (!cablePackage) {
      throw new ApiError(400, 'Unsupported cable package');
    }

    const result = await chargeWallet({
      user,
      amountKobo: parseAmountToKobo(cablePackage.amount),
      type: 'cable',
      description: `${cablePackage.name} cable subscription`,
      metadata: {
        packageId: cablePackage.id,
        provider: cablePackage.provider,
        smartCardNumber: String(body.smartCardNumber).trim()
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
      'Cable subscription successful'
    );
  },
  {
    methods: ['POST']
  }
);
