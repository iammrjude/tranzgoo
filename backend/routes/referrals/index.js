const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const User = require('../../src/models/User');

module.exports = withApi(
  async function referrals(req, res) {
    const user = await requireAuth(req);
    const referredCount = await User.countDocuments({ referredBy: user._id });

    return sendSuccess(res, 200, {
      referralCode: user.referralCode,
      referredCount,
      inviteMessage: `Join TranzGOO with my referral code ${user.referralCode}`
    });
  },
  {
    methods: ['GET']
  }
);
