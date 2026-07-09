const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { educationProducts } = require('../../../src/lib/catalog');

module.exports = withApi(
  async function educationProductsRoute(req, res) {
    await requireAuth(req);
    return sendSuccess(res, 200, { products: educationProducts });
  },
  {
    methods: ['GET']
  }
);
