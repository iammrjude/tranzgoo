const crypto = require('crypto');
const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { connectDb } = require('../../src/lib/db');
const { ApiError } = require('../../src/lib/errors');
const { requireFields } = require('../../src/lib/validation');
const User = require('../../src/models/User');

function hashToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex');
}

module.exports = withApi(
  async function verifyResetCode(req, res) {
    const body = await readJsonBody(req);

    requireFields(body, ['token']);

    await connectDb();

    const user = await User.findOne({
      resetPasswordTokenHash: hashToken(String(body.token).trim()),
      resetPasswordExpiresAt: { $gt: new Date() }
    }).select('+resetPasswordTokenHash +resetPasswordExpiresAt');

    if (!user) {
      throw new ApiError(400, 'Password reset code is invalid or expired');
    }

    return sendSuccess(
      res,
      200,
      { valid: true },
      'Password reset code verified'
    );
  },
  {
    methods: ['POST']
  }
);
