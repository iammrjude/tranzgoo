const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { cableProviders, findById } = require('../../../src/lib/catalog');
const { ApiError } = require('../../../src/lib/errors');
const { requireFields } = require('../../../src/lib/validation');

module.exports = withApi(
  async function validateCable(req, res) {
    await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['provider', 'smartCardNumber']);

    const provider = findById(cableProviders, body.provider);

    if (!provider) {
      throw new ApiError(400, 'Unsupported cable provider');
    }

    return sendSuccess(res, 200, {
      customer: {
        name: 'Demo Cable Customer',
        provider: provider.name,
        smartCardNumber: String(body.smartCardNumber).trim()
      }
    });
  },
  {
    methods: ['POST']
  }
);
