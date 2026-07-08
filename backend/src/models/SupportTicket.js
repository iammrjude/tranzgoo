const mongoose = require('mongoose');

const supportTicketSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    subject: {
      type: String,
      required: true
    },
    message: {
      type: String,
      required: true
    },
    status: {
      type: String,
      enum: ['open', 'in_progress', 'closed'],
      default: 'open'
    }
  },
  {
    timestamps: true
  }
);

module.exports =
  mongoose.models.SupportTicket ||
  mongoose.model('SupportTicket', supportTicketSchema);
