const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { electricityProviders } = require('../../../src/lib/catalog');

module.exports = withApi(
  async function electricityProvidersRoute(req, res) {
    await requireAuth(req);
    return sendSuccess(res, 200, { providers: electricityProviders });
  },
  {
    methods: ['GET']
  }
);
