const { sendSuccess, withApi } = require('../src/lib/api');

module.exports = withApi(
  async function health(req, res) {
    return sendSuccess(res, 200, {
      name: 'tranzgoo-api',
      status: 'ok',
      timestamp: new Date().toISOString()
    });
  },
  {
    methods: ['GET']
  }
);
