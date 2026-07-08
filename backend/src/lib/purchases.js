const { ApiError } = require('./errors');
const { generateReference } = require('./ids');
const Wallet = require('../models/Wallet');
const Transaction = require('../models/Transaction');

async function chargeWallet({ user, amountKobo, type, description, metadata = {} }) {
  const wallet = await Wallet.findOne({ user: user._id });

  if (!wallet) {
    throw new ApiError(404, 'Wallet not found');
  }

  if (wallet.balanceKobo < amountKobo) {
    throw new ApiError(400, 'Insufficient wallet balance');
  }

  wallet.balanceKobo -= amountKobo;
  await wallet.save();

  const transaction = await Transaction.create({
    user: user._id,
    reference: generateReference('TX'),
    type,
    direction: 'debit',
    amountKobo,
    balanceAfterKobo: wallet.balanceKobo,
    status: 'successful',
    description,
    metadata
  });

  return {
    wallet,
    transaction
  };
}

module.exports = {
  chargeWallet
};
