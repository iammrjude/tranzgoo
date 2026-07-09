const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const Wallet = require('../../src/models/Wallet');

function getDefaultFundingAccounts(user) {
  if (process.env.FUNDING_ACCOUNTS_JSON) {
    return JSON.parse(process.env.FUNDING_ACCOUNTS_JSON);
  }

  return [
    {
      bankName: 'Moniepoint',
      accountNumber: '1234567890',
      accountName: `TranzGOO ${user.fullName}`
    },
    {
      bankName: 'Wema Bank',
      accountNumber: '1234567890',
      accountName: `TranzGOO ${user.fullName}`
    },
    {
      bankName: 'Fidelity Bank',
      accountNumber: '1234567890',
      accountName: `TranzGOO ${user.fullName}`
    }
  ];
}

module.exports = withApi(
  async function fundingAccounts(req, res) {
    const user = await requireAuth(req);
    const wallet = await Wallet.findOne({ user: user._id });
    const accounts = wallet.fundingAccounts.length
      ? wallet.fundingAccounts
      : getDefaultFundingAccounts(user);

    return sendSuccess(res, 200, {
      fundingAccounts: accounts
    });
  },
  {
    methods: ['GET']
  }
);
