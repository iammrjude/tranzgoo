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

class CableScreen extends StatefulWidget {
  const CableScreen({super.key});

  @override
  State<CableScreen> createState() => _CableScreenState();
}

class _CableScreenState extends State<CableScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController smartCardController = TextEditingController();
  List<Map<String, dynamic>> providers = [];
  List<Map<String, dynamic>> packages = [];
  String? selectedProvider;
  String? selectedPackage;
  Map<String, dynamic>? customer;
  bool isLoading = true;
  bool isValidating = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    smartCardController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedProviders = await _apiService.getCableProviders();
      final firstProvider = loadedProviders.isEmpty
          ? null
          : loadedProviders.first['id']?.toString();
      final loadedPackages = await _apiService.getCablePackages(
        provider: firstProvider ?? '',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        providers = loadedProviders;
        packages = loadedPackages;
        selectedProvider = firstProvider;
        selectedPackage = loadedPackages.isEmpty
            ? null
            : loadedPackages.first['id']?.toString();
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load cable packages.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadPackages(String? provider) async {
    setState(() {
      selectedProvider = provider;
      selectedPackage = null;
      customer = null;
    });

    final loadedPackages = await _apiService.getCablePackages(
      provider: provider ?? '',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      packages = loadedPackages;
      selectedPackage = loadedPackages.isEmpty
          ? null
          : loadedPackages.first['id']?.toString();
    });
  }

  Future<void> validateCustomer() async {
    if (selectedProvider == null || smartCardController.text.trim().isEmpty) {
      showMessage('Please select a provider and enter a smart card number.');
      return;
    }

    setState(() {
      isValidating = true;
      customer = null;
    });

    try {
      final data = await _apiService.validateCable(
        provider: selectedProvider!,
        smartCardNumber: smartCardController.text,
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
      showMessage('Unable to validate cable customer.');
    } finally {
      if (mounted) {
        setState(() {
          isValidating = false;
        });
      }
    }
  }

  Future<void> reviewCable() async {
    if (selectedPackage == null || smartCardController.text.trim().isEmpty) {
      showMessage('Please select a package and enter a smart card number.');
      return;
    }

    final cablePackage = packages.firstWhere(
      (item) => item['id']?.toString() == selectedPackage,
      orElse: () => <String, dynamic>{},
    );
    final packageName = cablePackage['name']?.toString() ?? selectedPackage!;
    final packageAmount = cablePackage['amount']?.toString() ?? '';

    Navigator.pushNamed(
      context,
      AppRoutes.paymentConfirmationView,
      arguments: PaymentConfirmationArguments(
        title: 'Confirm Cable Payment',
        subtitle: 'Review your smart card and package before payment.',
        amountLabel: 'NGN $packageAmount',
        details: [
          ReceiptLineItem(label: 'Package', value: packageName),
          ReceiptLineItem(
            label: 'Smart Card',
            value: smartCardController.text.trim(),
          ),
          if (customer != null)
            ReceiptLineItem(
              label: 'Customer',
              value: customer!['name']?.toString() ?? '',
            ),
        ],
        onConfirm: () async {
          final result = await _apiService.buyCable(
            packageId: selectedPackage!,
            smartCardNumber: smartCardController.text,
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
            title: 'Cable Subscription Successful',
            message: balance == null
                ? 'Your cable subscription has been completed.'
                : 'Your cable subscription has been completed. New balance: NGN $balance',
            details: [
              ReceiptLineItem(label: 'Amount', value: 'NGN $packageAmount'),
              ReceiptLineItem(label: 'Package', value: packageName),
              ReceiptLineItem(
                label: 'Smart Card',
                value: smartCardController.text.trim(),
              ),
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
      title: 'Cable TV',
      subtitle: 'Validate your smart card and renew your subscription.',
      child: isLoading
          ? const SizedBox(height: 260, child: AppLoadingState())
          : errorMessage != null
          ? SizedBox(
              height: 260,
              child: AppErrorState(message: errorMessage!, onRetry: loadData),
            )
          : Column(
              children: [
                ServiceDropdown(
                  hintText: 'Provider',
                  value: selectedProvider,
                  items: providers,
                  itemLabel: (item) => item['name']?.toString() ?? '',
                  onChanged: (value) {
                    loadPackages(value).catchError((_) {
                      showMessage('Unable to load packages.');
                    });
                  },
                ),
                ServiceDropdown(
                  hintText: 'Package',
                  value: selectedPackage,
                  items: packages,
                  itemLabel: (item) {
                    final name = item['name']?.toString() ?? '';
                    final amount = item['amount']?.toString() ?? '';
                    return amount.isEmpty ? name : '$name - NGN $amount';
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedPackage = value;
                    });
                  },
                ),
                AppTextField(
                  controller: smartCardController,
                  hintText: 'Smart Card Number',
                  keyboardType: TextInputType.number,
                  icon: const Icon(Icons.credit_card),
                ),
                if (customer != null)
                  ServiceResultCard(
                    title: 'Customer Found',
                    lines: [
                      'Name: ${customer!['name'] ?? ''}',
                      'Provider: ${customer!['provider'] ?? ''}',
                      'Card: ${customer!['smartCardNumber'] ?? ''}',
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: validateCustomer,
                        label: 'Validate',
                        isText: true,
                        isLoading: isValidating,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        onPressed: reviewCable,
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
