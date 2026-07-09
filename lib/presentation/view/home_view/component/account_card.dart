import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_clickable_surface.dart';

class AccountCard extends StatefulWidget {
  final String balance;
  final VoidCallback? onSend;
  final VoidCallback? onFund;

  const AccountCard({
    Key? key,
    this.balance = '0.00',
    this.onSend,
    this.onFund,
  }) : super(key: key);

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool isBalanceVisible = true;

  void toggleBalanceVisibility() {
    setState(() {
      isBalanceVisible = !isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final balanceText = isBalanceVisible ? 'NGN ${widget.balance}' : 'NGN ****';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primaryColor,
        border: Border.all(color: AppColors.grey300, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Balance',
            style: AppText.extraBold
                .copyWith(color: AppColors.whiteColor, fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  balanceText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.extraBold
                      .copyWith(color: AppColors.whiteColor, fontSize: 20),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: toggleBalanceVisibility,
                tooltip: isBalanceVisible ? 'Hide balance' : 'Show balance',
                constraints: const BoxConstraints(
                  minHeight: 32,
                  minWidth: 32,
                ),
                padding: EdgeInsets.zero,
                icon: Icon(
                  isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  size: 16,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppClickableSurface(
                onTap: widget.onSend ??
                    () => Navigator.pushNamed(context, '/sendView'),
                semanticLabel: 'Send money',
                height: 39.h,
                width: 118.w,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/icons/sendIcon.png'),
                    const SizedBox(width: 10),
                    Text(
                      'Send',
                      style: AppText.extraBold.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              AppClickableSurface(
                onTap: widget.onFund ??
                    () => Navigator.pushNamed(context, '/fundAccountView'),
                semanticLabel: 'Fund account',
                height: 39.h,
                width: 151.w,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Image.asset('assets/icons/addIcon.png'),
                    const SizedBox(width: 10),
                    Text(
                      'Fund Account',
                      style: AppText.extraBold.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
