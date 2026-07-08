const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');

module.exports = withApi(
  async function authMe(req, res) {
    const user = await requireAuth(req);
    return sendSuccess(res, 200, { user: user.toSafeObject() });
  },
  {
    methods: ['GET']
  }
);
