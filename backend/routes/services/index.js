const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const { services } = require('../../src/lib/catalog');

module.exports = withApi(
  async function serviceIndex(req, res) {
    await requireAuth(req);
    return sendSuccess(res, 200, { services });
  },
  {
    methods: ['GET']
  }
);
