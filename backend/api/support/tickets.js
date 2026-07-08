const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const { requireFields } = require('../../src/lib/validation');
const SupportTicket = require('../../src/models/SupportTicket');

module.exports = withApi(
  async function supportTickets(req, res) {
    const user = await requireAuth(req);

    if (req.method === 'GET') {
      const tickets = await SupportTicket.find({ user: user._id }).sort({
        createdAt: -1
      });

      return sendSuccess(res, 200, { tickets });
    }

    const body = await readJsonBody(req);

    requireFields(body, ['subject', 'message']);

    const ticket = await SupportTicket.create({
      user: user._id,
      subject: String(body.subject).trim(),
      message: String(body.message).trim()
    });

    return sendSuccess(res, 201, { ticket }, 'Support ticket created');
  },
  {
    methods: ['GET', 'POST']
  }
);
