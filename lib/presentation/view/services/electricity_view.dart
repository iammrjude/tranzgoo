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

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController meterController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  List<Map<String, dynamic>> providers = [];
  String? selectedProvider;
  String meterType = 'prepaid';
  Map<String, dynamic>? customer;
  bool isLoading = true;
  bool isValidating = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProviders();
  }

  @override
  void dispose() {
    meterController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> loadProviders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getElectricityProviders();

      if (!mounted) {
        return;
      }

      setState(() {
        providers = data;
        selectedProvider = data.isEmpty ? null : data.first['id']?.toString();
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load electricity providers.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> validateMeter() async {
    if (selectedProvider == null || meterController.text.trim().isEmpty) {
      showMessage('Please select a provider and enter a meter number.');
      return;
    }

    setState(() {
      isValidating = true;
      customer = null;
    });

    try {
      final data = await _apiService.validateMeter(
        provider: selectedProvider!,
        meterNumber: meterController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        customer = data;
      });
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to validate meter.');
    } finally {
      if (mounted) {
        setState(() {
          isValidating = false;
        });
      }
    }
  }

  Future<void> reviewElectricity() async {
    if (selectedProvider == null ||
        meterController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      showMessage('Please select a provider, meter number, and amount.');
      return;
    }

    final providerName = providers
        .firstWhere(
          (item) => item['id']?.toString() == selectedProvider,
          orElse: () => {'name': selectedProvider},
        )['name']
        ?.toString();

    Navigator.pushNamed(
      context,
      AppRoutes.paymentConfirmationView,
      arguments: PaymentConfirmationArguments(
        title: 'Confirm Electricity Purchase',
        subtitle: 'Review the meter and amount before payment.',
        amountLabel: 'NGN ${amountController.text.trim()}',
        details: [
          ReceiptLineItem(label: 'Provider', value: providerName ?? ''),
          ReceiptLineItem(label: 'Meter', value: meterController.text.trim()),
          ReceiptLineItem(label: 'Meter Type', value: meterType),
          if (customer != null)
            ReceiptLineItem(
              label: 'Customer',
              value: customer!['name']?.toString() ?? '',
            ),
        ],
        onConfirm: () async {
          final result = await _apiService.buyElectricity(
            provider: selectedProvider!,
            meterNumber: meterController.text,
            meterType: meterType,
            amount: amountController.text,
          );
          final transaction = result['transaction'] is Map<String, dynamic>
              ? result['transaction'] as Map<String, dynamic>
              : <String, dynamic>{};
          final wallet = result['wallet'];
          final balance = wallet is Map ? wallet['balance']?.toString() : null;
          final token = result['token']?.toString();
          final transactionId =
              transaction['_id']?.toString() ?? transaction['id']?.toString();

          return TransactionResultArguments(
            isSuccess: true,
            title: 'Electricity Purchase Successful',
            message: balance == null
                ? 'Your electricity purchase has been completed.'
                : 'Your electricity purchase has been completed. New balance: NGN $balance',
            details: [
              ReceiptLineItem(
                label: 'Amount',
                value: 'NGN ${amountController.text.trim()}',
              ),
              ReceiptLineItem(label: 'Provider', value: providerName ?? ''),
              ReceiptLineItem(
                label: 'Meter',
                value: meterController.text.trim(),
              ),
              if (token != null) ReceiptLineItem(label: 'Token', value: token),
              if (transaction['reference'] != null)
                ReceiptLineItem(
                  label: 'Reference',
                  value: transaction['reference'].toString(),
                ),
            ],
            primaryActionLabel: transactionId == null ? null : 'View Receipt',
            primaryActionRoute: transactionId == null
                ? null
                : AppRoutes.transactionDetailView,
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ServiceScreenShell(
      title: 'Electricity',
      subtitle: 'Validate your meter and buy electricity token.',
      child: isLoading
          ? const SizedBox(height: 260, child: AppLoadingState())
          : errorMessage != null
          ? SizedBox(
              height: 260,
              child: AppErrorState(
                message: errorMessage!,
                onRetry: loadProviders,
              ),
            )
          : Column(
              children: [
                ServiceDropdown(
                  hintText: 'Provider',
                  value: selectedProvider,
                  items: providers,
                  itemLabel: (item) => item['name']?.toString() ?? '',
                  onChanged: (value) {
                    setState(() {
                      selectedProvider = value;
                      customer = null;
                    });
                  },
                ),
                AppTextField(
                  controller: meterController,
                  hintText: 'Meter Number',
                  keyboardType: TextInputType.number,
                  icon: const Icon(Icons.electric_meter),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 17),
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'prepaid', label: Text('Prepaid')),
                      ButtonSegment(value: 'postpaid', label: Text('Postpaid')),
                    ],
                    selected: {meterType},
                    onSelectionChanged: (values) {
                      setState(() {
                        meterType = values.first;
                      });
                    },
                  ),
                ),
                AppTextField(
                  controller: amountController,
                  hintText: 'Amount',
                  keyboardType: TextInputType.number,
                  icon: const Icon(Icons.payments),
                ),
                if (customer != null)
                  ServiceResultCard(
                    title: 'Customer Found',
                    lines: [
                      'Name: ${customer!['name'] ?? ''}',
                      'Provider: ${customer!['provider'] ?? ''}',
                      'Meter: ${customer!['meterNumber'] ?? ''}',
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: validateMeter,
                        label: 'Validate',
                        isText: true,
                        isLoading: isValidating,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        onPressed: reviewElectricity,
                        label: 'Review',
                        isText: true,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
