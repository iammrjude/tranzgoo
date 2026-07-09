import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
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
  String? resultMessage;
  bool isLoading = true;
  bool isSubmitting = false;
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

  Future<void> buyAirtime() async {
    if (selectedNetwork == null ||
        phoneController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      showMessage('Please select a network, phone number, and amount.');
      return;
    }

    setState(() {
      isSubmitting = true;
      resultMessage = null;
    });

    try {
      final result = await _apiService.buyAirtime(
        network: selectedNetwork!,
        phone: phoneController.text,
        amount: amountController.text,
      );
      final wallet = result['wallet'];
      final balance = wallet is Map ? wallet['balance']?.toString() : null;

      if (!mounted) {
        return;
      }

      setState(() {
        resultMessage = balance == null
            ? 'Airtime purchase successful.'
            : 'Airtime purchase successful. New balance: NGN $balance';
      });
      showMessage('Airtime purchase successful.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to complete airtime purchase.');
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
                    if (resultMessage != null)
                      ServiceResultCard(
                        title: 'Completed',
                        lines: [resultMessage!],
                      ),
                    AppButton(
                      onPressed: buyAirtime,
                      label: 'Buy Airtime',
                      isText: true,
                      isLoading: isSubmitting,
                      width: double.infinity,
                    ),
                  ],
                ),
    );
  }
}
