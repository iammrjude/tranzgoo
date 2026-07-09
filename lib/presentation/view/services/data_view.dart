import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController phoneController = TextEditingController();
  List<Map<String, dynamic>> networks = [];
  List<Map<String, dynamic>> plans = [];
  String? selectedNetwork;
  String? selectedPlan;
  String? resultMessage;
  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedNetworks = await _apiService.getDataNetworks();
      final firstNetwork = loadedNetworks.isEmpty
          ? null
          : loadedNetworks.first['id']?.toString();
      final loadedPlans =
          await _apiService.getDataPlans(network: firstNetwork ?? '');

      if (!mounted) {
        return;
      }

      setState(() {
        networks = loadedNetworks;
        plans = loadedPlans;
        selectedNetwork = firstNetwork;
        selectedPlan =
            loadedPlans.isEmpty ? null : loadedPlans.first['id']?.toString();
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load data plans.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadPlans(String? network) async {
    setState(() {
      selectedNetwork = network;
      selectedPlan = null;
    });

    final loadedPlans = await _apiService.getDataPlans(network: network ?? '');

    if (!mounted) {
      return;
    }

    setState(() {
      plans = loadedPlans;
      selectedPlan =
          loadedPlans.isEmpty ? null : loadedPlans.first['id']?.toString();
    });
  }

  Future<void> buyData() async {
    if (selectedPlan == null || phoneController.text.trim().isEmpty) {
      showMessage('Please select a plan and enter a phone number.');
      return;
    }

    setState(() {
      isSubmitting = true;
      resultMessage = null;
    });

    try {
      final result = await _apiService.buyData(
        planId: selectedPlan!,
        phone: phoneController.text,
      );
      final wallet = result['wallet'];
      final balance = wallet is Map ? wallet['balance']?.toString() : null;

      if (!mounted) {
        return;
      }

      setState(() {
        resultMessage = balance == null
            ? 'Data purchase successful.'
            : 'Data purchase successful. New balance: NGN $balance';
      });
      showMessage('Data purchase successful.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to complete data purchase.');
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
      title: 'Data',
      subtitle: 'Choose a bundle and pay from your wallet.',
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
                      hintText: 'Network',
                      value: selectedNetwork,
                      items: networks,
                      itemLabel: (item) => item['name']?.toString() ?? '',
                      onChanged: (value) {
                        loadPlans(value).catchError((_) {
                          showMessage('Unable to load plans for this network.');
                        });
                      },
                    ),
                    ServiceDropdown(
                      hintText: 'Plan',
                      value: selectedPlan,
                      items: plans,
                      itemLabel: (item) {
                        final name = item['name']?.toString() ?? '';
                        final amount = item['amount']?.toString() ?? '';
                        return amount.isEmpty ? name : '$name - NGN $amount';
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedPlan = value;
                        });
                      },
                    ),
                    AppTextField(
                      controller: phoneController,
                      hintText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      icon: Image.asset('assets/icons/phoneIcon.png'),
                    ),
                    if (resultMessage != null)
                      ServiceResultCard(
                        title: 'Completed',
                        lines: [resultMessage!],
                      ),
                    AppButton(
                      onPressed: buyData,
                      label: 'Buy Data',
                      isText: true,
                      isLoading: isSubmitting,
                      width: double.infinity,
                    ),
                  ],
                ),
    );
  }
}
