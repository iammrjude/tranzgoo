const mongoose = require('mongoose');
const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const { ApiError } = require('../../src/lib/errors');
const Transaction = require('../../src/models/Transaction');

module.exports = withApi(
  async function transactionDetails(req, res) {
    const user = await requireAuth(req);

    if (!mongoose.isValidObjectId(req.query.id)) {
      throw new ApiError(400, 'Invalid transaction ID');
    }

    const transaction = await Transaction.findOne({
      _id: req.query.id,
      user: user._id
    });

    if (!transaction) {
      throw new ApiError(404, 'Transaction not found');
    }

    return sendSuccess(res, 200, { transaction });
  },
  {
    methods: ['GET']
  }
);
