const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const Transaction = require('../../src/models/Transaction');

module.exports = withApi(
  async function transactions(req, res) {
    const user = await requireAuth(req);
    const page = Math.max(Number(req.query.page || 1), 1);
    const limit = Math.min(Math.max(Number(req.query.limit || 20), 1), 100);
    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      Transaction.find({ user: user._id })
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit),
      Transaction.countDocuments({ user: user._id })
    ]);

    return sendSuccess(res, 200, {
      transactions: items,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    });
  },
  {
    methods: ['GET']
  }
);
