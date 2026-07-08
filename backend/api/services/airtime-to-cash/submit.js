const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { airtimeNetworks, findById } = require('../../../src/lib/catalog');
const { ApiError } = require('../../../src/lib/errors');
const { generateReference } = require('../../../src/lib/ids');
const { formatKobo, parseAmountToKobo } = require('../../../src/lib/money');
const { requireFields } = require('../../../src/lib/validation');
const AirtimeToCashRequest = require('../../../src/models/AirtimeToCashRequest');

const RATE = 0.8;

module.exports = withApi(
  async function submitAirtimeToCash(req, res) {
    const user = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['network', 'phone', 'amount']);

    const network = findById(airtimeNetworks, body.network);

    if (!network) {
      throw new ApiError(400, 'Unsupported airtime network');
    }

    const amountKobo = parseAmountToKobo(body.amount);
    const payoutAmountKobo = Math.round(amountKobo * RATE);
    const requestCode = generateReference('A2C');

    const request = await AirtimeToCashRequest.create({
      user: user._id,
      network: network.id,
      phone: String(body.phone).trim(),
      amountKobo,
      payoutAmountKobo,
      rate: RATE,
      requestCode,
      instructions:
        'Transfer the airtime to the assigned TranzGOO line. Your wallet will be credited after confirmation.'
    });

    return sendSuccess(
      res,
      201,
      {
        request,
        quote: {
          amount: formatKobo(amountKobo),
          payoutAmount: formatKobo(payoutAmountKobo),
          rate: RATE
        }
      },
      'Airtime-to-cash request submitted'
    );
  },
  {
    methods: ['POST']
  }
);
