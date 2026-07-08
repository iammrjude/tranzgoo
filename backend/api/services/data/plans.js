const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { dataPlans } = require('../../../src/lib/catalog');

module.exports = withApi(
  async function dataPlansRoute(req, res) {
    await requireAuth(req);

    const network = String(req.query.network || '').toLowerCase();
    const plans = network
      ? dataPlans.filter((plan) => plan.network === network)
      : dataPlans;

    return sendSuccess(res, 200, { plans });
  },
  {
    methods: ['GET']
  }
);
