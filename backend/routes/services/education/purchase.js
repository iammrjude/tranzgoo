const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { educationProducts, findById } = require('../../../src/lib/catalog');
const { ApiError } = require('../../../src/lib/errors');
const { generateReference } = require('../../../src/lib/ids');
const { formatKobo, parseAmountToKobo } = require('../../../src/lib/money');
const { chargeWallet } = require('../../../src/lib/purchases');
const { requireFields } = require('../../../src/lib/validation');

module.exports = withApi(
  async function educationPurchase(req, res) {
    const user = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['productId']);

    const product = findById(educationProducts, body.productId);

    if (!product) {
      throw new ApiError(400, 'Unsupported education product');
    }

    const pin = generateReference('PIN');
    const result = await chargeWallet({
      user,
      amountKobo: parseAmountToKobo(product.amount),
      type: 'education',
      description: `${product.name} purchase`,
      metadata: {
        productId: product.id,
        pin
      }
    });

    return sendSuccess(
      res,
      201,
      {
        pin,
        transaction: result.transaction,
        wallet: {
          balance: formatKobo(result.wallet.balanceKobo),
          balanceKobo: result.wallet.balanceKobo
        }
      },
      'Education product purchase successful'
    );
  },
  {
    methods: ['POST']
  }
);
