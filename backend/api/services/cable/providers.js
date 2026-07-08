const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { cableProviders } = require('../../../src/lib/catalog');

module.exports = withApi(
  async function cableProvidersRoute(req, res) {
    await requireAuth(req);
    return sendSuccess(res, 200, { providers: cableProviders });
  },
  {
    methods: ['GET']
  }
);
