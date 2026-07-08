const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const Notification = require('../../src/models/Notification');

module.exports = withApi(
  async function notifications(req, res) {
    const user = await requireAuth(req);
    const notifications = await Notification.find({ user: user._id })
      .sort({ createdAt: -1 })
      .limit(50);

    return sendSuccess(res, 200, { notifications });
  },
  {
    methods: ['GET']
  }
);
