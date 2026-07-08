const jwt = require('jsonwebtoken');
const { connectDb } = require('./db');
const { ApiError } = require('./errors');
const User = require('../models/User');

function getJwtSecret() {
  const secret = process.env.JWT_SECRET;

  if (!secret) {
    throw new Error('JWT_SECRET is not configured');
  }

  return secret;
}

function signToken(user) {
  return jwt.sign(
    {
      sub: user._id.toString(),
      email: user.email,
      tranzgoId: user.tranzgoId
    },
    getJwtSecret(),
    {
      expiresIn: process.env.JWT_EXPIRES_IN || '7d'
    }
  );
}

function getBearerToken(req) {
  const header = req.headers.authorization || req.headers.Authorization;

  if (!header || !String(header).startsWith('Bearer ')) {
    throw new ApiError(401, 'Authorization token is required');
  }

  return String(header).slice('Bearer '.length).trim();
}

async function requireAuth(req) {
  const token = getBearerToken(req);
  let decoded;

  try {
    decoded = jwt.verify(token, getJwtSecret());
  } catch (error) {
    throw new ApiError(401, 'Invalid or expired authorization token');
  }

  await connectDb();

  const user = await User.findById(decoded.sub);

  if (!user || user.status !== 'active') {
    throw new ApiError(401, 'User account is not active');
  }

  return user;
}

module.exports = {
  requireAuth,
  signToken
};
