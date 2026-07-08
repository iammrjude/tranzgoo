const mongoose = require('mongoose');

const airtimeToCashRequestSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    network: {
      type: String,
      required: true
    },
    phone: {
      type: String,
      required: true
    },
    amountKobo: {
      type: Number,
      required: true
    },
    payoutAmountKobo: {
      type: Number,
      required: true
    },
    rate: {
      type: Number,
      required: true
    },
    requestCode: {
      type: String,
      required: true,
      unique: true
    },
    status: {
      type: String,
      enum: ['pending', 'processing', 'paid', 'rejected'],
      default: 'pending'
    },
    instructions: {
      type: String,
      default: ''
    }
  },
  {
    timestamps: true
  }
);

module.exports =
  mongoose.models.AirtimeToCashRequest ||
  mongoose.model('AirtimeToCashRequest', airtimeToCashRequestSchema);
