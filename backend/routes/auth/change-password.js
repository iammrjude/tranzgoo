const bcrypt = require('bcryptjs');
const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const { ApiError } = require('../../src/lib/errors');
const { assertPassword, requireFields } = require('../../src/lib/validation');
const User = require('../../src/models/User');

module.exports = withApi(
  async function changePassword(req, res) {
    const authUser = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['currentPassword', 'newPassword', 'confirmPassword']);

    const newPassword = String(body.newPassword);
    const confirmPassword = String(body.confirmPassword);

    assertPassword(newPassword);

    if (newPassword !== confirmPassword) {
      throw new ApiError(400, 'Passwords do not match');
    }

    const user = await User.findById(authUser._id).select('+passwordHash');
    const passwordMatches = await bcrypt.compare(
      String(body.currentPassword),
      user.passwordHash
    );

    if (!passwordMatches) {
      throw new ApiError(401, 'Current password is incorrect');
    }

    user.passwordHash = await bcrypt.hash(newPassword, 12);
    user.passwordChangedAt = new Date();
    user.resetPasswordTokenHash = '';
    user.resetPasswordExpiresAt = null;
    await user.save();

    return sendSuccess(res, 200, {}, 'Password changed successfully');
  },
  {
    methods: ['POST']
  }
);
