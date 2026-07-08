const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const { requireFields } = require('../../src/lib/validation');

module.exports = withApi(
  async function referralInvite(req, res) {
    const user = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['recipient']);

    return sendSuccess(
      res,
      202,
      {
        recipient: String(body.recipient).trim(),
        referralCode: user.referralCode,
        message: `Join TranzGOO with my referral code ${user.referralCode}`
      },
      'Referral invite accepted for processing'
    );
  },
  {
    methods: ['POST']
  }
);
