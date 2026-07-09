const bcrypt = require('bcryptjs');
const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { signToken } = require('../../src/lib/auth');
const { connectDb } = require('../../src/lib/db');
const { ApiError } = require('../../src/lib/errors');
const { assertEmail, requireFields } = require('../../src/lib/validation');
const User = require('../../src/models/User');

module.exports = withApi(
  async function login(req, res) {
    const body = await readJsonBody(req);

    requireFields(body, ['email', 'password']);

    const email = assertEmail(body.email);

    await connectDb();

    const user = await User.findOne({ email }).select('+passwordHash');

    if (!user) {
      throw new ApiError(401, 'Invalid email or password');
    }

    const passwordMatches = await bcrypt.compare(
      String(body.password),
      user.passwordHash
    );

    if (!passwordMatches) {
      throw new ApiError(401, 'Invalid email or password');
    }

    if (user.status !== 'active') {
      throw new ApiError(403, 'This account is not active');
    }

    user.lastLoginAt = new Date();
    await user.save();

    return sendSuccess(
      res,
      200,
      {
        token: signToken(user),
        user: user.toSafeObject()
      },
      'Login successful'
    );
  },
  {
    methods: ['POST']
  }
);
