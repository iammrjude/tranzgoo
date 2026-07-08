const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { airtimeNetworks } = require('../../../src/lib/catalog');

module.exports = withApi(
  async function dataNetworks(req, res) {
    await requireAuth(req);
    return sendSuccess(res, 200, { networks: airtimeNetworks });
  },
  {
    methods: ['GET']
  }
);
