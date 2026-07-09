import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/presentation/view/transactions/payment_flow_models.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool isSubmitting = false;

  PaymentConfirmationArguments? get args {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    return routeArgs is PaymentConfirmationArguments ? routeArgs : null;
  }

  Future<void> confirm() async {
    final confirmation = args;

    if (confirmation == null) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    TransactionResultArguments result;

    try {
      result = await confirmation.onConfirm();
    } on ApiException catch (error) {
      result = TransactionResultArguments(
        isSuccess: false,
        title: 'Transaction Failed',
        message: error.message,
        details: confirmation.details,
      );
    } catch (_) {
      result = TransactionResultArguments(
        isSuccess: false,
        title: 'Transaction Failed',
        message: 'Something went wrong. Please try again.',
        details: confirmation.details,
      );
    }

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.transactionResultView,
      arguments: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    final confirmation = args;

    if (confirmation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const AppEmptyState(
          title: 'Nothing to confirm',
          message: 'Go back and start the transaction again.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Confirm Payment', style: AppText.extraBold),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appSectionTitle(confirmation.title),
              const SizedBox(height: 8),
              Text(
                confirmation.subtitle,
                style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
              ),
              const SizedBox(height: 20),
              AppInfoCard(
                color: AppColors.primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: AppText.mediumStyle.copyWith(
                        color: AppColors.whiteColor,
                        letterSpacing: 0.09,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      confirmation.amountLabel,
                      style: AppText.extraBold.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 26,
                        letterSpacing: 0.09,
                      ),
                    ),
                  ],
                ),
              ),
              ...confirmation.details.map(
                (item) => _receiptRow(item.label, item.value),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: () => Navigator.pop(context),
                      label: 'Cancel',
                      isText: true,
                      backgroundColor: AppColors.whiteColor,
                      labelColor: AppColors.primaryColor,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      onPressed: confirm,
                      label: 'Confirm',
                      isText: true,
                      isLoading: isSubmitting,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _receiptRow(String label, String value) {
  return AppInfoCard(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppText.extraBold.copyWith(letterSpacing: 0.09),
          ),
        ),
      ],
    ),
  );
}
