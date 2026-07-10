import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/transactions/transaction_detail_screen.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class AirtimeToCashDetailScreen extends StatefulWidget {
  const AirtimeToCashDetailScreen({super.key});

  @override
  State<AirtimeToCashDetailScreen> createState() =>
      _AirtimeToCashDetailScreenState();
}

class _AirtimeToCashDetailScreenState extends State<AirtimeToCashDetailScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  Map<String, dynamic>? request;
  bool isLoading = true;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (request == null && isLoading) {
      loadRequest();
    }
  }

  String? get requestId {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is String) {
      return args;
    }

    if (args is Map<String, dynamic>) {
      return args['_id']?.toString() ?? args['id']?.toString();
    }

    return null;
  }

  Future<void> loadRequest() async {
    final id = requestId;

    if (id == null || id.isEmpty) {
      setState(() {
        errorMessage = 'Airtime-to-cash request ID was not provided.';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getAirtimeToCashRequest(id);

      if (!mounted) {
        return;
      }

      setState(() {
        request = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load airtime-to-cash request.';
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
    final data = request;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Airtime2Cash Request', style: AppText.extraBold),
      ),
      body: isLoading && data == null
          ? const AppLoadingState(message: 'Loading request...')
          : errorMessage != null && data == null
          ? AppErrorState(message: errorMessage!, onRetry: loadRequest)
          : RefreshIndicator(
              onRefresh: loadRequest,
              color: AppColors.primaryColor,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                children: [
                  appSectionTitle('Request ${data?['requestCode'] ?? ''}'),
                  const SizedBox(height: 12),
                  AppInfoCard(
                    color: AppColors.primaryLightColor,
                    child: Text(
                      data?['instructions']?.toString() ??
                          'Follow the provided transfer instructions.',
                      style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
                    ),
                  ),
                  detailRow('Network', data?['network']),
                  detailRow('Phone', data?['phone']),
                  detailRow(
                    'Airtime Amount',
                    formatAmount(data?['amountKobo']),
                  ),
                  detailRow(
                    'Wallet Payout',
                    formatAmount(data?['payoutAmountKobo']),
                  ),
                  detailRow('Rate', data?['rate']),
                  detailRow('Status', data?['status']),
                  detailRow('Created', formatDate(data?['createdAt'])),
                ],
              ),
            ),
    );
  }
}

Widget detailRow(String label, dynamic value) {
  final text = value?.toString() ?? '';

  if (text.isEmpty) {
    return const SizedBox.shrink();
  }

  return AppInfoCard(
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.mediumStyle,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: AppText.extraBold,
          ),
        ),
      ],
    ),
  );
}
