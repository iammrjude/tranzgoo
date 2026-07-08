const bcrypt = require('bcryptjs');
const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { signToken } = require('../../src/lib/auth');
const { connectDb } = require('../../src/lib/db');
const { ApiError } = require('../../src/lib/errors');
const { generateReferralCode, generateTranzgoId } = require('../../src/lib/ids');
const {
  assertEmail,
  assertPassword,
  requireFields
} = require('../../src/lib/validation');
const User = require('../../src/models/User');
const Wallet = require('../../src/models/Wallet');

async function createUniqueTranzgoId() {
  for (let attempt = 0; attempt < 10; attempt += 1) {
    const tranzgoId = generateTranzgoId();
    const exists = await User.exists({ tranzgoId });

    if (!exists) {
      return tranzgoId;
    }
  }

  throw new Error('Unable to generate a unique TranzGOO ID');
}

module.exports = withApi(
  async function register(req, res) {
    const body = await readJsonBody(req);

    requireFields(body, [
      'fullName',
      'email',
      'phone',
      'password',
      'confirmPassword'
    ]);

    const fullName = String(body.fullName).trim();
    const email = assertEmail(body.email);
    const phone = String(body.phone).trim();
    const password = String(body.password);
    const confirmPassword = String(body.confirmPassword);

    assertPassword(password);

    if (password !== confirmPassword) {
      throw new ApiError(400, 'Passwords do not match');
    }

    await connectDb();

    const existingUser = await User.findOne({
      $or: [{ email }, { phone }]
    });

    if (existingUser) {
      throw new ApiError(409, 'An account already exists with this email or phone');
    }

    const passwordHash = await bcrypt.hash(password, 12);
    const tranzgoId = await createUniqueTranzgoId();
    const referralCode = generateReferralCode(fullName);

    const user = await User.create({
      fullName,
      email,
      phone,
      passwordHash,
      tranzgoId,
      referralCode
    });

    await Wallet.create({
      user: user._id,
      fundingAccounts: []
    });

    const token = signToken(user);

    return sendSuccess(
      res,
      201,
      {
        token,
        user: user.toSafeObject()
      },
      'Registration successful'
    );
  },
  {
    methods: ['POST']
  }
);
