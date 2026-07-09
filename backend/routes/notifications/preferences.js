const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');

const preferenceKeys = [
  'accountUpdates',
  'transactions',
  'promotions',
  'securityAlerts'
];

function normalizePreferences(preferences = {}) {
  return {
    accountUpdates: preferences.accountUpdates !== false,
    transactions: preferences.transactions !== false,
    promotions: preferences.promotions === true,
    securityAlerts: preferences.securityAlerts !== false
  };
}

module.exports = withApi(
  async function notificationPreferences(req, res) {
    const user = await requireAuth(req);

    if (req.method === 'GET') {
      return sendSuccess(res, 200, {
        preferences: normalizePreferences(user.notificationPreferences)
      });
    }

    const body = await readJsonBody(req);
    const updates = {};

    preferenceKeys.forEach((key) => {
      if (body[key] !== undefined) {
        updates[key] = body[key] === true;
      }
    });

    user.notificationPreferences = {
      ...normalizePreferences(user.notificationPreferences),
      ...updates
    };
    await user.save();

    return sendSuccess(
      res,
      200,
      {
        preferences: normalizePreferences(user.notificationPreferences)
      },
      'Notification preferences updated'
    );
  },
  {
    methods: ['GET', 'PATCH']
  }
);
