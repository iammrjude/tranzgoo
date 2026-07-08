const { ApiError } = require('./errors');

function parseAmountToKobo(value, fieldName = 'amount') {
  if (value === undefined || value === null || value === '') {
    throw new ApiError(400, `${fieldName} is required`);
  }

  const amount = Number(value);

  if (!Number.isFinite(amount) || amount <= 0) {
    throw new ApiError(400, `${fieldName} must be a positive number`);
  }

  return Math.round(amount * 100);
}

function formatKobo(kobo) {
  return Number((Number(kobo || 0) / 100).toFixed(2));
}

module.exports = {
  formatKobo,
  parseAmountToKobo
};
