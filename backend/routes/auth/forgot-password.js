const crypto = require('crypto');
const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { connectDb } = require('../../src/lib/db');
const { ApiError } = require('../../src/lib/errors');
const {
  hasMailTransport,
  sendPasswordResetEmail
} = require('../../src/lib/mailer');
const { assertEmail, requireFields } = require('../../src/lib/validation');
const User = require('../../src/models/User');

function hashToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex');
}

module.exports = withApi(
  async function forgotPassword(req, res) {
    const body = await readJsonBody(req);

    requireFields(body, ['email']);

    const email = assertEmail(body.email);
    const expiresInMinutes = 15;

    if (process.env.NODE_ENV === 'production' && !hasMailTransport()) {
      throw new ApiError(500, 'Password reset email is not configured');
    }

    await connectDb();

    const user = await User.findOne({ email }).select(
      '+resetPasswordTokenHash +resetPasswordExpiresAt'
    );
    let resetToken;

    if (user) {
      resetToken = crypto.randomBytes(24).toString('hex');
      user.resetPasswordTokenHash = hashToken(resetToken);
      user.resetPasswordExpiresAt = new Date(
        Date.now() + expiresInMinutes * 60 * 1000
      );
      await user.save();

      if (hasMailTransport()) {
        await sendPasswordResetEmail({
          to: user.email,
          resetToken,
          expiresInMinutes
        });
      }
    }

    const data = {
      expiresInMinutes
    };

    if (resetToken && process.env.NODE_ENV !== 'production') {
      data.resetToken = resetToken;
    }

    return sendSuccess(
      res,
      202,
      data,
      'If an account exists for this email, a password reset code has been sent'
    );
  },
  {
    methods: ['POST']
  }
);
