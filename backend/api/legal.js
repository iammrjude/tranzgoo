const { sendSuccess, withApi } = require('../src/lib/api');

module.exports = withApi(
  async function legal(req, res) {
    return sendSuccess(res, 200, {
      documents: [
        {
          id: 'terms',
          title: 'Terms of Service',
          summary:
            'Use of TranzGOO is subject to account, wallet, payment, and acceptable-use rules.'
        },
        {
          id: 'privacy',
          title: 'Privacy Policy',
          summary:
            'TranzGOO stores account information needed to provide wallet and telecom services.'
        },
        {
          id: 'refunds',
          title: 'Refund Policy',
          summary:
            'Failed wallet-backed transactions may be reviewed and reversed where applicable.'
        }
      ]
    });
  },
  {
    methods: ['GET']
  }
);
