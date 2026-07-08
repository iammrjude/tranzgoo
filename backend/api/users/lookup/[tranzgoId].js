const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { connectDb } = require('../../../src/lib/db');
const { ApiError } = require('../../../src/lib/errors');
const User = require('../../../src/models/User');

module.exports = withApi(
  async function lookupUser(req, res) {
    await requireAuth(req);
    await connectDb();

    const tranzgoId = String(req.query.tranzgoId || '').trim().toUpperCase();
    const user = await User.findOne({ tranzgoId });

    if (!user) {
      throw new ApiError(404, 'No user found with this TranzGOO ID');
    }

    return sendSuccess(res, 200, {
      user: {
        fullName: user.fullName,
        tranzgoId: user.tranzgoId,
        profileImageUrl: user.profileImageUrl
      }
    });
  },
  {
    methods: ['GET']
  }
);
