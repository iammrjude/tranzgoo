const mongoose = require('mongoose');

const transactionSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    reference: {
      type: String,
      required: true,
      unique: true,
      index: true
    },
    type: {
      type: String,
      required: true,
      enum: [
        'funding',
        'transfer_in',
        'transfer_out',
        'airtime',
        'data',
        'cable',
        'electricity',
        'education',
        'airtime_to_cash'
      ]
    },
    direction: {
      type: String,
      required: true,
      enum: ['credit', 'debit']
    },
    amountKobo: {
      type: Number,
      required: true
    },
    balanceAfterKobo: {
      type: Number,
      default: 0
    },
    status: {
      type: String,
      enum: ['pending', 'successful', 'failed', 'reversed'],
      default: 'pending'
    },
    description: {
      type: String,
      default: ''
    },
    counterpartyUser: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null
    },
    metadata: {
      type: mongoose.Schema.Types.Mixed,
      default: {}
    }
  },
  {
    timestamps: true
  }
);

module.exports =
  mongoose.models.Transaction || mongoose.model('Transaction', transactionSchema);
