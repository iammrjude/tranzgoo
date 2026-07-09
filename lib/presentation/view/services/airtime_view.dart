import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
import 'package:tranzgoo/presentation/view/transactions/payment_flow_models.dart';
import 'package:tranzgoo/presentation/view/transactions/transaction_detail_screen.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({Key? key}) : super(key: key);

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  List<Map<String, dynamic>> networks = [];
  String? selectedNetwork;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadNetworks();
  }

  @override
  void dispose() {
    phoneController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> loadNetworks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getAirtimeNetworks();

      if (!mounted) {
        return;
      }

      setState(() {
        networks = data;
        selectedNetwork = data.isEmpty ? null : data.first['id']?.toString();
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load airtime networks.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> reviewAirtime() async {
    if (selectedNetwork == null ||
        phoneController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      showMessage('Please select a network, phone number, and amount.');
      return;
    }

    final networkName = networks
        .firstWhere(
          (network) => network['id']?.toString() == selectedNetwork,
          orElse: () => {'name': selectedNetwork},
        )['name']
        ?.toString();

    Navigator.pushNamed(
      context,
      AppRoutes.paymentConfirmationView,
      arguments: PaymentConfirmationArguments(
        title: 'Confirm Airtime Purchase',
        subtitle: 'Review the phone number and amount before purchase.',
        amountLabel: 'NGN ${amountController.text.trim()}',
        details: [
          ReceiptLineItem(label: 'Network', value: networkName ?? ''),
          ReceiptLineItem(label: 'Phone', value: phoneController.text.trim()),
        ],
        onConfirm: () async {
          final result = await _apiService.buyAirtime(
            network: selectedNetwork!,
            phone: phoneController.text,
            amount: amountController.text,
          );
          final transaction = result['transaction'] is Map<String, dynamic>
              ? result['transaction'] as Map<String, dynamic>
              : <String, dynamic>{};
          final wallet = result['wallet'];
          final balance = wallet is Map ? wallet['balance']?.toString() : null;
          final transactionId =
              transaction['_id']?.toString() ?? transaction['id']?.toString();

          return TransactionResultArguments(
            isSuccess: true,
            title: 'Airtime Purchase Successful',
            message: balance == null
                ? 'Your airtime purchase has been completed.'
                : 'Your airtime purchase has been completed. New balance: NGN $balance',
            details: [
              ReceiptLineItem(
                  label: 'Amount',
                  value: 'NGN ${amountController.text.trim()}'),
              ReceiptLineItem(label: 'Network', value: networkName ?? ''),
              ReceiptLineItem(
                  label: 'Phone', value: phoneController.text.trim()),
              if (transaction['reference'] != null)
                ReceiptLineItem(
                  label: 'Reference',
                  value: transaction['reference'].toString(),
                ),
            ],
            primaryActionLabel: transactionId == null ? null : 'View Receipt',
            primaryActionRoute:
                transactionId == null ? null : AppRoutes.transactionDetailView,
            primaryActionArguments: transactionId == null
                ? null
                : TransactionDetailArguments(
                    id: transactionId,
                    transaction: transaction,
                  ),
          );
        },
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ServiceScreenShell(
      title: 'Airtime',
      subtitle: 'Buy airtime directly from your TranzGOO wallet.',
      child: isLoading
          ? const SizedBox(height: 260, child: AppLoadingState())
          : errorMessage != null
              ? SizedBox(
                  height: 260,
                  child: AppErrorState(
                    message: errorMessage!,
                    onRetry: loadNetworks,
                  ),
                )
              : Column(
                  children: [
                    ServiceDropdown(
                      hintText: 'Network',
                      value: selectedNetwork,
                      items: networks,
                      itemLabel: (item) => item['name']?.toString() ?? '',
                      onChanged: (value) {
                        setState(() {
                          selectedNetwork = value;
                        });
                      },
                    ),
                    AppTextField(
                      controller: phoneController,
                      hintText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      icon: Image.asset('assets/icons/phoneIcon.png'),
                    ),
                    AppTextField(
                      controller: amountController,
                      hintText: 'Amount',
                      keyboardType: TextInputType.number,
                      icon: const Icon(Icons.payments),
                    ),
                    AppButton(
                      onPressed: reviewAirtime,
                      label: 'Review Airtime',
                      isText: true,
                      width: double.infinity,
                    ),
                  ],
                ),
    );
  }
}
