const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { cablePackages } = require('../../../src/lib/catalog');

module.exports = withApi(
  async function cablePackagesRoute(req, res) {
    await requireAuth(req);

    const provider = String(req.query.provider || '').toLowerCase();
    const packages = provider
      ? cablePackages.filter((item) => item.provider === provider)
      : cablePackages;

    return sendSuccess(res, 200, { packages });
  },
  {
    methods: ['GET']
  }
);
