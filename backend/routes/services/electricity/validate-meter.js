const { readJsonBody, sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { electricityProviders, findById } = require('../../../src/lib/catalog');
const { ApiError } = require('../../../src/lib/errors');
const { requireFields } = require('../../../src/lib/validation');

module.exports = withApi(
  async function validateMeter(req, res) {
    await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['provider', 'meterNumber']);

    const provider = findById(electricityProviders, body.provider);

    if (!provider) {
      throw new ApiError(400, 'Unsupported electricity provider');
    }

    return sendSuccess(res, 200, {
      customer: {
        name: 'Demo Electricity Customer',
        provider: provider.name,
        meterNumber: String(body.meterNumber).trim()
      }
    });
  },
  {
    methods: ['POST']
  }
);
