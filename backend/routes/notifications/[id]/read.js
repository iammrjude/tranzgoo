const mongoose = require('mongoose');
const { sendSuccess, withApi } = require('../../../src/lib/api');
const { requireAuth } = require('../../../src/lib/auth');
const { ApiError } = require('../../../src/lib/errors');
const Notification = require('../../../src/models/Notification');

module.exports = withApi(
  async function markNotificationRead(req, res) {
    const user = await requireAuth(req);

    if (!mongoose.isValidObjectId(req.query.id)) {
      throw new ApiError(400, 'Invalid notification ID');
    }

    const notification = await Notification.findOne({
      _id: req.query.id,
      user: user._id
    });

    if (!notification) {
      throw new ApiError(404, 'Notification not found');
    }

    notification.readAt = notification.readAt || new Date();
    await notification.save();

    return sendSuccess(res, 200, { notification }, 'Notification marked as read');
  },
  {
    methods: ['PATCH']
  }
);
