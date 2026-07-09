import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/presentation/view/transactions/transaction_detail_screen.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_clickable_surface.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class HistoryComponent extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  const HistoryComponent({
    Key? key,
    required this.transactions,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const AppEmptyState(
        title: 'No history yet',
        message:
            'Your completed wallet and service transactions will appear here.',
      );
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionTile(transaction: transactions[index]);
      },
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionTile({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direction = transaction['direction']?.toString() ?? 'debit';
    final isCredit = direction == 'credit';
    final amountKobo = num.tryParse(
          transaction['amountKobo']?.toString() ?? '0',
        ) ??
        0;
    final amount = (amountKobo / 100).toStringAsFixed(2);
    final createdAt = DateTime.tryParse(
      transaction['createdAt']?.toString() ?? '',
    );
    final description = transaction['description']?.toString() ?? '';
    final type = transaction['type']?.toString() ?? 'Transaction';
    final dateLabel = createdAt == null
        ? '--'
        : '${monthLabel(createdAt.month)}\n${createdAt.day.toString().padLeft(2, '0')}';

    return AppClickableSurface(
      onTap: () {
        final id =
            transaction['_id']?.toString() ?? transaction['id']?.toString();

        if (id == null || id.isEmpty) {
          return;
        }

        Navigator.pushNamed(
          context,
          AppRoutes.transactionDetailView,
          arguments: TransactionDetailArguments(
            id: id,
            transaction: transaction,
          ),
        );
      },
      semanticLabel: 'View transaction receipt',
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(10),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            dateLabel,
            textAlign: TextAlign.center,
            style: AppText.lightStyle.copyWith(letterSpacing: 0.09),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description.isNotEmpty ? description : type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.extraBold.copyWith(letterSpacing: 0.09),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction['reference']?.toString() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.mediumStyle.copyWith(
                    color: AppColors.grey500,
                    fontSize: 11,
                    letterSpacing: 0.09,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 28.h,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryLightColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        transaction['status']?.toString() ?? 'pending',
                        style: AppText.extraBold.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 10,
                          letterSpacing: 0.09,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${isCredit ? '+' : '-'}NGN $amount',
            style: AppText.extraBold.copyWith(
              color: isCredit ? AppColors.primaryColor : Colors.red,
              letterSpacing: 0.09,
            ),
          ),
        ],
      ),
    );
  }
}

String monthLabel(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  if (month < 1 || month > 12) {
    return '--';
  }

  return months[month - 1];
}
