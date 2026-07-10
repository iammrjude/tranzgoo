import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/transactions/payment_flow_models.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class TransactionDetailArguments {
  final String id;
  final Map<String, dynamic>? transaction;

  const TransactionDetailArguments({
    required this.id,
    this.transaction,
  });
}

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({Key? key}) : super(key: key);

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  Map<String, dynamic>? transaction;
  bool isLoading = true;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (transaction == null && isLoading) {
      loadTransaction();
    }
  }

  TransactionDetailArguments? get args {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;

    if (routeArgs is TransactionDetailArguments) {
      return routeArgs;
    }

    if (routeArgs is Map<String, dynamic>) {
      final id = routeArgs['_id']?.toString() ?? routeArgs['id']?.toString();

      if (id == null || id.isEmpty) {
        return null;
      }

      return TransactionDetailArguments(id: id, transaction: routeArgs);
    }

    if (routeArgs is String && routeArgs.isNotEmpty) {
      return TransactionDetailArguments(id: routeArgs);
    }

    return null;
  }

  Future<void> loadTransaction() async {
    final details = args;

    if (details == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Transaction ID was not provided.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      transaction = details.transaction;
    });

    try {
      final data = await _apiService.getTransaction(details.id);

      if (!mounted) {
        return;
      }

      setState(() {
        transaction = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load transaction details.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = transaction;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Transaction Receipt', style: AppText.extraBold),
      ),
      body: isLoading && data == null
          ? const AppLoadingState(message: 'Loading receipt...')
          : errorMessage != null && data == null
              ? AppErrorState(message: errorMessage!, onRetry: loadTransaction)
              : RefreshIndicator(
                  onRefresh: loadTransaction,
                  color: AppColors.primaryColor,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                    children: [
                      appSectionTitle(data?['description']?.toString() ??
                          data?['type']?.toString() ??
                          'Transaction'),
                      const SizedBox(height: 12),
                      AppInfoCard(
                        color: AppColors.primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount',
                              style: AppText.mediumStyle.copyWith(
                                color: AppColors.whiteColor,
                                letterSpacing: 0.09,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatAmount(data?['amountKobo']),
                              style: AppText.extraBold.copyWith(
                                color: AppColors.whiteColor,
                                fontSize: 26,
                                letterSpacing: 0.09,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...receiptItems(data ?? {}).map(
                        (item) => AppInfoCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.label,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.mediumStyle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  item.value,
                                  textAlign: TextAlign.right,
                                  style: AppText.extraBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

List<ReceiptLineItem> receiptItems(Map<String, dynamic> transaction) {
  return [
    ReceiptLineItem(
      label: 'Reference',
      value: transaction['reference']?.toString() ?? '',
    ),
    ReceiptLineItem(
      label: 'Type',
      value: transaction['type']?.toString() ?? '',
    ),
    ReceiptLineItem(
      label: 'Direction',
      value: transaction['direction']?.toString() ?? '',
    ),
    ReceiptLineItem(
      label: 'Status',
      value: transaction['status']?.toString() ?? '',
    ),
    ReceiptLineItem(
      label: 'Balance After',
      value: formatAmount(transaction['balanceAfterKobo']),
    ),
    ReceiptLineItem(
      label: 'Date',
      value: formatDate(transaction['createdAt']),
    ),
  ].where((item) => item.value.isNotEmpty).toList();
}

String formatAmount(dynamic amountKobo) {
  final amount = num.tryParse(amountKobo?.toString() ?? '0') ?? 0;
  return 'NGN ${(amount / 100).toStringAsFixed(2)}';
}

String formatDate(dynamic rawDate) {
  final date = DateTime.tryParse(rawDate?.toString() ?? '');

  if (date == null) {
    return '';
  }

  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
