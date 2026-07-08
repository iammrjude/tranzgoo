const { ApiError } = require('./errors');

function requireFields(body, fields) {
  const missing = fields.filter((field) => {
    const value = body[field];
    return value === undefined || value === null || String(value).trim() === '';
  });

  if (missing.length) {
    throw new ApiError(400, 'Missing required fields', { fields: missing });
  }
}

function normalizeEmail(email) {
  return String(email || '').trim().toLowerCase();
}

function assertEmail(email) {
  const normalized = normalizeEmail(email);
  const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalized);

  if (!isValid) {
    throw new ApiError(400, 'Enter a valid email address');
  }

  return normalized;
}

function assertPassword(password) {
  if (String(password || '').length < 6) {
    throw new ApiError(400, 'Password must be at least 6 characters long');
  }
}

module.exports = {
  assertEmail,
  assertPassword,
  normalizeEmail,
  requireFields
};
