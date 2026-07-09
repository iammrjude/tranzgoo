const crypto = require('crypto');
const bcrypt = require('bcryptjs');
const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { connectDb } = require('../../src/lib/db');
const { ApiError } = require('../../src/lib/errors');
const { assertPassword, requireFields } = require('../../src/lib/validation');
const User = require('../../src/models/User');

function hashToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex');
}

module.exports = withApi(
  async function resetPassword(req, res) {
    const body = await readJsonBody(req);

    requireFields(body, ['token', 'newPassword', 'confirmPassword']);

    const newPassword = String(body.newPassword);
    const confirmPassword = String(body.confirmPassword);

    assertPassword(newPassword);

    if (newPassword !== confirmPassword) {
      throw new ApiError(400, 'Passwords do not match');
    }

    await connectDb();

    const user = await User.findOne({
      resetPasswordTokenHash: hashToken(String(body.token).trim()),
      resetPasswordExpiresAt: { $gt: new Date() }
    }).select('+resetPasswordTokenHash +resetPasswordExpiresAt');

    if (!user) {
      throw new ApiError(400, 'Password reset code is invalid or expired');
    }

    user.passwordHash = await bcrypt.hash(newPassword, 12);
    user.passwordChangedAt = new Date();
    user.resetPasswordTokenHash = '';
    user.resetPasswordExpiresAt = null;
    await user.save();

    return sendSuccess(res, 200, {}, 'Password reset successful');
  },
  {
    methods: ['POST']
  }
);
