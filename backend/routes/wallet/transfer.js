const mongoose = require('mongoose');
const { readJsonBody, sendSuccess, withApi } = require('../../src/lib/api');
const { requireAuth } = require('../../src/lib/auth');
const { connectDb } = require('../../src/lib/db');
const { ApiError } = require('../../src/lib/errors');
const { generateReference } = require('../../src/lib/ids');
const { formatKobo, parseAmountToKobo } = require('../../src/lib/money');
const { requireFields } = require('../../src/lib/validation');
const Transaction = require('../../src/models/Transaction');
const User = require('../../src/models/User');
const Wallet = require('../../src/models/Wallet');

module.exports = withApi(
  async function transfer(req, res) {
    const sender = await requireAuth(req);
    const body = await readJsonBody(req);

    requireFields(body, ['receiverTranzgoId', 'amount']);

    const receiverTranzgoId = String(body.receiverTranzgoId).trim().toUpperCase();
    const amountKobo = parseAmountToKobo(body.amount);

    if (receiverTranzgoId === sender.tranzgoId) {
      throw new ApiError(400, 'You cannot send money to yourself');
    }

    await connectDb();

    const receiver = await User.findOne({ tranzgoId: receiverTranzgoId });

    if (!receiver) {
      throw new ApiError(404, 'Receiver was not found');
    }

    const session = await mongoose.startSession();
    let debitTransaction;
    let senderWallet;

    try {
      await session.withTransaction(async () => {
        senderWallet = await Wallet.findOne({ user: sender._id }).session(session);
        const receiverWallet = await Wallet.findOne({ user: receiver._id }).session(
          session
        );

        if (!senderWallet || !receiverWallet) {
          throw new ApiError(404, 'Wallet not found');
        }

        if (senderWallet.balanceKobo < amountKobo) {
          throw new ApiError(400, 'Insufficient wallet balance');
        }

        senderWallet.balanceKobo -= amountKobo;
        receiverWallet.balanceKobo += amountKobo;

        await senderWallet.save({ session });
        await receiverWallet.save({ session });

        const reference = generateReference('TRF');
        const description = `Transfer to ${receiver.fullName}`;

        [debitTransaction] = await Transaction.create(
          [
            {
              user: sender._id,
              reference: `${reference}-D`,
              type: 'transfer_out',
              direction: 'debit',
              amountKobo,
              balanceAfterKobo: senderWallet.balanceKobo,
              status: 'successful',
              description,
              counterpartyUser: receiver._id,
              metadata: {
                receiverTranzgoId: receiver.tranzgoId,
                note: body.note || ''
              }
            },
            {
              user: receiver._id,
              reference: `${reference}-C`,
              type: 'transfer_in',
              direction: 'credit',
              amountKobo,
              balanceAfterKobo: receiverWallet.balanceKobo,
              status: 'successful',
              description: `Transfer from ${sender.fullName}`,
              counterpartyUser: sender._id,
              metadata: {
                senderTranzgoId: sender.tranzgoId,
                note: body.note || ''
              }
            }
          ],
          { session }
        );
      });
    } finally {
      await session.endSession();
    }

    return sendSuccess(
      res,
      201,
      {
        transaction: debitTransaction,
        wallet: {
          balance: formatKobo(senderWallet.balanceKobo),
          balanceKobo: senderWallet.balanceKobo,
          currency: senderWallet.currency
        }
      },
      'Transfer successful'
    );
  },
  {
    methods: ['POST']
  }
);
