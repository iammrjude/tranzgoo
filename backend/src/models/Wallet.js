const mongoose = require('mongoose');

const fundingAccountSchema = new mongoose.Schema(
  {
    bankName: String,
    accountNumber: String,
    accountName: String
  },
  {
    _id: false
  }
);

const walletSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
      index: true
    },
    currency: {
      type: String,
      default: 'NGN'
    },
    balanceKobo: {
      type: Number,
      default: 0,
      min: 0
    },
    lockedBalanceKobo: {
      type: Number,
      default: 0,
      min: 0
    },
    fundingAccounts: {
      type: [fundingAccountSchema],
      default: []
    }
  },
  {
    timestamps: true
  }
);

module.exports = mongoose.models.Wallet || mongoose.model('Wallet', walletSchema);
