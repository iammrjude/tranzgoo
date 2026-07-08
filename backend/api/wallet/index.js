const { sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const { formatKobo } = require('../../src/lib/money');
const Wallet = require('../../src/models/Wallet');

module.exports = withApi(
  async function walletIndex(req, res) {
    const user = await requireAuth(req);
    const wallet = await Wallet.findOne({ user: user._id });

    return sendSuccess(res, 200, {
      wallet: {
        currency: wallet.currency,
        balance: formatKobo(wallet.balanceKobo),
        balanceKobo: wallet.balanceKobo,
        lockedBalance: formatKobo(wallet.lockedBalanceKobo),
        lockedBalanceKobo: wallet.lockedBalanceKobo
      }
    });
  },
  {
    methods: ['GET']
  }
);
