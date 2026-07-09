import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
import 'package:tranzgoo/presentation/view/transactions/payment_flow_models.dart';
import 'package:tranzgoo/presentation/view/transactions/transaction_detail_screen.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
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
  bool isLoading = true;
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

  Future<void> reviewProduct() async {
    if (selectedProduct == null) {
      showMessage('Please select an education product.');
      return;
    }

    final product = products.firstWhere(
      (item) => item['id']?.toString() == selectedProduct,
      orElse: () => <String, dynamic>{},
    );
    final productName = product['name']?.toString() ?? selectedProduct!;
    final productAmount = product['amount']?.toString() ?? '';

    Navigator.pushNamed(
      context,
      AppRoutes.paymentConfirmationView,
      arguments: PaymentConfirmationArguments(
        title: 'Confirm Education Purchase',
        subtitle: 'Review the education product before purchase.',
        amountLabel: 'NGN $productAmount',
        details: [ReceiptLineItem(label: 'Product', value: productName)],
        onConfirm: () async {
          final result =
              await _apiService.buyEducationProduct(selectedProduct!);
          final transaction = result['transaction'] is Map<String, dynamic>
              ? result['transaction'] as Map<String, dynamic>
              : <String, dynamic>{};
          final wallet = result['wallet'];
          final balance = wallet is Map ? wallet['balance']?.toString() : null;
          final pin = result['pin']?.toString();
          final transactionId =
              transaction['_id']?.toString() ?? transaction['id']?.toString();

          return TransactionResultArguments(
            isSuccess: true,
            title: 'Education Purchase Successful',
            message: balance == null
                ? 'Your education product has been purchased.'
                : 'Your education product has been purchased. New balance: NGN $balance',
            details: [
              ReceiptLineItem(label: 'Amount', value: 'NGN $productAmount'),
              ReceiptLineItem(label: 'Product', value: productName),
              if (pin != null) ReceiptLineItem(label: 'PIN', value: pin),
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
                    AppButton(
                      onPressed: reviewProduct,
                      label: 'Review Product',
                      isText: true,
                      width: double.infinity,
                    ),
                  ],
                ),
    );
  }
}
