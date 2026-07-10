import 'package:flutter/material.dart';
import 'package:tranzgoo/presentation/view/transactions/payment_flow_models.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class TransactionResultScreen extends StatelessWidget {
  const TransactionResultScreen({Key? key}) : super(key: key);

  TransactionResultArguments? _args(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    return routeArgs is TransactionResultArguments ? routeArgs : null;
  }

  @override
  Widget build(BuildContext context) {
    final result = _args(context);

    if (result == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const AppEmptyState(
          title: 'No receipt',
          message: 'There is no transaction receipt to show.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Receipt', style: AppText.extraBold),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
          child: Column(
            children: [
              Container(
                height: 74,
                width: 74,
                decoration: BoxDecoration(
                  color: result.isSuccess
                      ? AppColors.primaryLightColor
                      : Colors.red.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  result.isSuccess ? Icons.check_rounded : Icons.close_rounded,
                  color: result.isSuccess ? AppColors.primaryColor : Colors.red,
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                result.title,
                textAlign: TextAlign.center,
                style: AppText.extraBold.copyWith(
                  fontSize: 20,
                  letterSpacing: 0.09,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.message,
                textAlign: TextAlign.center,
                style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
              ),
              const SizedBox(height: 20),
              ...result.details.map(
                (item) => AppInfoCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppText.mediumStyle.copyWith(letterSpacing: 0.09),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          item.value,
                          textAlign: TextAlign.right,
                          style:
                              AppText.extraBold.copyWith(letterSpacing: 0.09),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (result.primaryActionRoute != null)
                AppButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    result.primaryActionRoute!,
                    arguments: result.primaryActionArguments,
                  ),
                  label: result.primaryActionLabel ?? 'View details',
                  isText: true,
                  width: double.infinity,
                ),
              const SizedBox(height: 10),
              AppButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.baseView,
                  (route) => false,
                ),
                label: 'Back Home',
                isText: true,
                backgroundColor: AppColors.whiteColor,
                labelColor: AppColors.primaryColor,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
