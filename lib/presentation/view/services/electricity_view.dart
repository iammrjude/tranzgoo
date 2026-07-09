import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({Key? key}) : super(key: key);

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
  String? token;
  String? resultMessage;
  bool isLoading = true;
  bool isValidating = false;
  bool isSubmitting = false;
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

  Future<void> buyElectricity() async {
    if (selectedProvider == null ||
        meterController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      showMessage('Please select a provider, meter number, and amount.');
      return;
    }

    setState(() {
      isSubmitting = true;
      token = null;
      resultMessage = null;
    });

    try {
      final result = await _apiService.buyElectricity(
        provider: selectedProvider!,
        meterNumber: meterController.text,
        meterType: meterType,
        amount: amountController.text,
      );
      final wallet = result['wallet'];
      final balance = wallet is Map ? wallet['balance']?.toString() : null;

      if (!mounted) {
        return;
      }

      setState(() {
        token = result['token']?.toString();
        resultMessage = balance == null
            ? 'Electricity purchase successful.'
            : 'Electricity purchase successful. New balance: NGN $balance';
      });
      showMessage('Electricity purchase successful.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to complete electricity purchase.');
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
                          ButtonSegment(
                              value: 'prepaid', label: Text('Prepaid')),
                          ButtonSegment(
                              value: 'postpaid', label: Text('Postpaid')),
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
                    if (token != null || resultMessage != null)
                      ServiceResultCard(
                        title: 'Completed',
                        lines: [
                          if (token != null) 'Token: $token',
                          if (resultMessage != null) resultMessage!,
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
                            onPressed: buyElectricity,
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
