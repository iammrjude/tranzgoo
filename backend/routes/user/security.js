const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');

module.exports = withApi(
  async function security(req, res) {
    const user = await requireAuth(req);

    return sendSuccess(res, 200, {
      security: {
        accountStatus: user.status,
        lastLoginAt: user.lastLoginAt,
        passwordChangedAt: user.passwordChangedAt,
        twoFactorEnabled: false,
        activeSessions: 1
      }
    });
  },
  {
    methods: ['GET']
  }
);
