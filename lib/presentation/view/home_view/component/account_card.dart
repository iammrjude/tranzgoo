import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_clickable_surface.dart';

class AccountCard extends StatefulWidget {
  final String balance;
  final VoidCallback? onSend;
  final VoidCallback? onFund;

  const AccountCard({
    super.key,
    this.balance = '0.00',
    this.onSend,
    this.onFund,
  });

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
            style: AppText.extraBold.copyWith(
              color: AppColors.whiteColor,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  balanceText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.extraBold.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: toggleBalanceVisibility,
                tooltip: isBalanceVisible ? 'Hide balance' : 'Show balance',
                constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
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
            children: [
              Expanded(
                child: _AccountActionButton(
                  onTap:
                      widget.onSend ??
                      () => Navigator.pushNamed(context, '/sendView'),
                  semanticLabel: 'Send money',
                  icon: Image.asset('assets/icons/sendIcon.png'),
                  label: 'Send',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AccountActionButton(
                  onTap:
                      widget.onFund ??
                      () => Navigator.pushNamed(context, '/fundAccountView'),
                  semanticLabel: 'Fund account',
                  icon: Image.asset('assets/icons/addIcon.png'),
                  label: 'Fund Account',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String semanticLabel;
  final Widget icon;
  final String label;

  const _AccountActionButton({
    required this.onTap,
    required this.semanticLabel,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppClickableSurface(
      onTap: onTap,
      semanticLabel: semanticLabel,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.extraBold.copyWith(
                color: AppColors.primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
