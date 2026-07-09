import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class CableScreen extends StatefulWidget {
  const CableScreen({Key? key}) : super(key: key);

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
  String? resultMessage;
  bool isLoading = true;
  bool isValidating = false;
  bool isSubmitting = false;
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
      final loadedPackages =
          await _apiService.getCablePackages(provider: firstProvider ?? '');

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

    final loadedPackages =
        await _apiService.getCablePackages(provider: provider ?? '');

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

  Future<void> buyCable() async {
    if (selectedPackage == null || smartCardController.text.trim().isEmpty) {
      showMessage('Please select a package and enter a smart card number.');
      return;
    }

    setState(() {
      isSubmitting = true;
      resultMessage = null;
    });

    try {
      final result = await _apiService.buyCable(
        packageId: selectedPackage!,
        smartCardNumber: smartCardController.text,
      );
      final wallet = result['wallet'];
      final balance = wallet is Map ? wallet['balance']?.toString() : null;

      if (!mounted) {
        return;
      }

      setState(() {
        resultMessage = balance == null
            ? 'Cable subscription successful.'
            : 'Cable subscription successful. New balance: NGN $balance';
      });
      showMessage('Cable subscription successful.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to complete cable purchase.');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                  child: AppErrorState(
                    message: errorMessage!,
                    onRetry: loadData,
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
                    if (resultMessage != null)
                      ServiceResultCard(
                        title: 'Completed',
                        lines: [resultMessage!],
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
                            onPressed: buyCable,
                            label: 'Pay',
                            isText: true,
                            isLoading: isSubmitting,
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
