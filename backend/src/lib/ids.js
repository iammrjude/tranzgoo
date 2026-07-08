const crypto = require('crypto');

function randomDigits(length) {
  let output = '';

  while (output.length < length) {
    output += crypto.randomInt(0, 10).toString();
  }

  return output;
}

function generateTranzgoId() {
  return `A${randomDigits(6)}`;
}

function generateReferralCode(fullName) {
  const prefix = String(fullName || 'TG')
    .replace(/[^a-z0-9]/gi, '')
    .slice(0, 4)
    .toUpperCase()
    .padEnd(4, 'X');

  return `${prefix}${randomDigits(4)}`;
}

function generateReference(prefix = 'TG') {
  const stamp = Date.now().toString(36).toUpperCase();
  const suffix = crypto.randomBytes(4).toString('hex').toUpperCase();
  return `${prefix}-${stamp}-${suffix}`;
}

module.exports = {
  generateReference,
  generateReferralCode,
  generateTranzgoId
};
