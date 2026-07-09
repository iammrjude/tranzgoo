const mongoose = require('mongoose');
const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { ApiError } = require('../../../src/lib/errors');
const AirtimeToCashRequest = require('../../../src/models/AirtimeToCashRequest');

module.exports = withApi(
  async function getAirtimeToCashRequest(req, res) {
    const user = await requireAuth(req);

    if (!mongoose.isValidObjectId(req.query.id)) {
      throw new ApiError(400, 'Invalid airtime-to-cash request ID');
    }

    const request = await AirtimeToCashRequest.findOne({
      _id: req.query.id,
      user: user._id
    });

    if (!request) {
      throw new ApiError(404, 'Airtime-to-cash request not found');
    }

    return sendSuccess(res, 200, { request });
  },
  {
    methods: ['GET']
  }
);
