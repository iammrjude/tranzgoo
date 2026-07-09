import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class Airtime2cash extends StatefulWidget {
  const Airtime2cash({Key? key}) : super(key: key);

  @override
  State<Airtime2cash> createState() => _Airime2cashState();
}

class _Airime2cashState extends State<Airtime2cash> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  List<Map<String, dynamic>> networks = [];
  String? selectedNetwork;
  Map<String, dynamic>? quote;
  Map<String, dynamic>? request;
  bool isLoading = true;
  bool isQuoting = false;
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
        errorMessage = 'Unable to load networks.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> getQuote() async {
    if (amountController.text.trim().isEmpty) {
      showMessage('Please enter the airtime amount.');
      return;
    }

    setState(() {
      isQuoting = true;
      quote = null;
    });

    try {
      final data =
          await _apiService.getAirtimeToCashQuote(amountController.text);

      if (!mounted) {
        return;
      }

      setState(() {
        quote = data;
      });
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to get airtime-to-cash quote.');
    } finally {
      if (mounted) {
        setState(() {
          isQuoting = false;
        });
      }
    }
  }

  Future<void> submitRequest() async {
    if (selectedNetwork == null ||
        phoneController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      showMessage('Please select a network, phone number, and amount.');
      return;
    }

    setState(() {
      isSubmitting = true;
      request = null;
    });

    try {
      final data = await _apiService.submitAirtimeToCash(
        network: selectedNetwork!,
        phone: phoneController.text,
        amount: amountController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        request = data['request'] is Map<String, dynamic>
            ? data['request'] as Map<String, dynamic>
            : <String, dynamic>{};
        quote = data['quote'] is Map<String, dynamic>
            ? data['quote'] as Map<String, dynamic>
            : quote;
      });
      showMessage('Airtime-to-cash request submitted.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to submit airtime-to-cash request.');
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
      title: 'Airtime2Cash',
      subtitle: 'Convert airtime value into wallet cash after confirmation.',
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
                      hintText: 'Airtime Amount',
                      keyboardType: TextInputType.number,
                      icon: const Icon(Icons.payments),
                    ),
                    if (quote != null)
                      ServiceResultCard(
                        title: 'Quote',
                        lines: [
                          'Airtime: NGN ${quote!['amount'] ?? ''}',
                          'Wallet payout: NGN ${quote!['payoutAmount'] ?? ''}',
                          'Rate: ${quote!['rate'] ?? ''}',
                        ],
                      ),
                    if (request != null)
                      ServiceResultCard(
                        title: 'Request Submitted',
                        lines: [
                          'Code: ${request!['requestCode'] ?? ''}',
                          'Status: ${request!['status'] ?? ''}',
                          '${request!['instructions'] ?? ''}',
                        ],
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onPressed: getQuote,
                            label: 'Get Quote',
                            isText: true,
                            isLoading: isQuoting,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppButton(
                            onPressed: submitRequest,
                            label: 'Submit',
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
