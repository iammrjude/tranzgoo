import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  List<Map<String, dynamic>> products = [];
  String? selectedProduct;
  String? pin;
  String? resultMessage;
  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getEducationProducts();

      if (!mounted) {
        return;
      }

      setState(() {
        products = data;
        selectedProduct = data.isEmpty ? null : data.first['id']?.toString();
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load education products.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> buyProduct() async {
    if (selectedProduct == null) {
      showMessage('Please select an education product.');
      return;
    }

    setState(() {
      isSubmitting = true;
      pin = null;
      resultMessage = null;
    });

    try {
      final result = await _apiService.buyEducationProduct(selectedProduct!);
      final wallet = result['wallet'];
      final balance = wallet is Map ? wallet['balance']?.toString() : null;

      if (!mounted) {
        return;
      }

      setState(() {
        pin = result['pin']?.toString();
        resultMessage = balance == null
            ? 'Education product purchase successful.'
            : 'Education product purchase successful. New balance: NGN $balance';
      });
      showMessage('Education product purchase successful.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to complete education purchase.');
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
      title: 'Education',
      subtitle: 'Purchase exam pins and education products.',
      child: isLoading
          ? const SizedBox(height: 260, child: AppLoadingState())
          : errorMessage != null
              ? SizedBox(
                  height: 260,
                  child: AppErrorState(
                    message: errorMessage!,
                    onRetry: loadProducts,
                  ),
                )
              : Column(
                  children: [
                    ServiceDropdown(
                      hintText: 'Product',
                      value: selectedProduct,
                      items: products,
                      itemLabel: (item) {
                        final name = item['name']?.toString() ?? '';
                        final amount = item['amount']?.toString() ?? '';
                        return amount.isEmpty ? name : '$name - NGN $amount';
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedProduct = value;
                        });
                      },
                    ),
                    if (pin != null || resultMessage != null)
                      ServiceResultCard(
                        title: 'Completed',
                        lines: [
                          if (pin != null) 'PIN: $pin',
                          if (resultMessage != null) resultMessage!,
                        ],
                      ),
                    AppButton(
                      onPressed: buyProduct,
                      label: 'Buy Product',
                      isText: true,
                      isLoading: isSubmitting,
                      width: double.infinity,
                    ),
                  ],
                ),
    );
  }
}
