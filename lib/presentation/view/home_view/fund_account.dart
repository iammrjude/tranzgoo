import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_clickable_surface.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class FundAccount extends StatefulWidget {
  const FundAccount({Key? key}) : super(key: key);

  @override
  State<FundAccount> createState() => _FundAccountState();
}

class _FundAccountState extends State<FundAccount> {
  final TranzgooApiService _apiService = TranzgooApiService();
  List<Map<String, dynamic>> accounts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getFundingAccounts();

      if (!mounted) {
        return;
      }

      setState(() {
        accounts = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load funding accounts.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void copyAccount(String accountNumber) {
    Clipboard.setData(ClipboardData(text: accountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account number copied.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fund Account', style: AppText.extraBold),
        actions: [
          Container(
            height: 23.h,
            width: 23.w,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(6),
              color: AppColors.whiteColor,
            ),
            child: Image.asset('assets/icons/notification.png'),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: isLoading
            ? const AppLoadingState(message: 'Loading funding accounts...')
            : errorMessage != null
                ? AppErrorState(message: errorMessage!, onRetry: loadAccounts)
                : RefreshIndicator(
                    onRefresh: loadAccounts,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      children: [
                        Text(
                          'Transfer to any of the account numbers below to fund your account.',
                          textAlign: TextAlign.center,
                          style:
                              AppText.mediumStyle.copyWith(letterSpacing: 0.09),
                        ),
                        const SizedBox(height: 10),
                        if (accounts.isEmpty)
                          const AppEmptyState(
                            title: 'No funding account',
                            message:
                                'Funding account details will appear here when available.',
                          )
                        else
                          ...accounts.map(
                            (account) => fundAccountContainer(
                              bankName: account['bankName']?.toString() ?? '',
                              accountName:
                                  account['accountName']?.toString() ?? '',
                              accountNumber:
                                  account['accountNumber']?.toString() ?? '',
                              onCopy: () => copyAccount(
                                account['accountNumber']?.toString() ?? '',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

Widget fundAccountContainer({
  required String bankName,
  required String accountName,
  required String accountNumber,
  required VoidCallback onCopy,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.grey300, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bankName,
          style: AppText.extraBold.copyWith(color: AppColors.whiteColor),
        ),
        const SizedBox(height: 8),
        Text(
          accountName,
          style: AppText.mediumStyle.copyWith(
            color: AppColors.whiteColor,
            letterSpacing: 0.09,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Account no.'),
                Text(
                  accountNumber,
                  style:
                      AppText.extraBold.copyWith(color: AppColors.whiteColor),
                ),
              ],
            ),
            AppClickableSurface(
              onTap: onCopy,
              semanticLabel: 'Copy account number',
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.all(6),
              child: const Column(
                children: [
                  Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: AppColors.whiteColor,
                  ),
                  Text(
                    'Copy',
                    style: TextStyle(color: AppColors.whiteColor),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}
