const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const { ApiError } = require('../../src/lib/errors');
const { assertEmail } = require('../../src/lib/validation');
const User = require('../../src/models/User');

module.exports = withApi(
  async function userMe(req, res) {
    const user = await requireAuth(req);

    if (req.method === 'GET') {
      return sendSuccess(res, 200, { user: user.toSafeObject() });
    }

    const body = await readJsonBody(req);
    const updates = {};

    if (body.fullName !== undefined) {
      updates.fullName = String(body.fullName).trim();
    }

    if (body.email !== undefined) {
      updates.email = assertEmail(body.email);
    }

    if (body.phone !== undefined) {
      updates.phone = String(body.phone).trim();
    }

    if (body.profileImageUrl !== undefined) {
      updates.profileImageUrl = String(body.profileImageUrl).trim();
    }

    if (!Object.keys(updates).length) {
      throw new ApiError(400, 'No profile fields were provided');
    }

    if (updates.email || updates.phone) {
      const duplicate = await User.findOne({
        _id: { $ne: user._id },
        $or: [
          updates.email ? { email: updates.email } : null,
          updates.phone ? { phone: updates.phone } : null
        ].filter(Boolean)
      });

      if (duplicate) {
        throw new ApiError(409, 'Email or phone is already in use');
      }
    }

    Object.assign(user, updates);
    await user.save();

    return sendSuccess(res, 200, { user: user.toSafeObject() }, 'Profile updated');
  },
  {
    methods: ['GET', 'PATCH']
  }
);
