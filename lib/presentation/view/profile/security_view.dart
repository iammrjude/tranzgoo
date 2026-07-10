import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/transactions/transaction_detail_screen.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  Map<String, dynamic>? security;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadSecurity();
  }

  Future<void> loadSecurity() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getSecurity();

      if (!mounted) {
        return;
      }

      setState(() {
        security = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load security details.';
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
    final data = security;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Security', style: AppText.extraBold),
      ),
      body: isLoading
          ? const AppLoadingState(message: 'Loading security...')
          : errorMessage != null
          ? AppErrorState(message: errorMessage!, onRetry: loadSecurity)
          : RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: loadSecurity,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                children: [
                  appSectionTitle('Account Security'),
                  const SizedBox(height: 16),
                  securityRow('Account Status', data?['accountStatus']),
                  securityRow('Last Login', formatDate(data?['lastLoginAt'])),
                  securityRow(
                    'Password Changed',
                    formatDate(data?['passwordChangedAt']),
                  ),
                  securityRow(
                    'Two-factor Authentication',
                    data?['twoFactorEnabled'] == true ? 'Enabled' : 'Off',
                  ),
                  securityRow(
                    'Active Sessions',
                    data?['activeSessions']?.toString(),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.changePasswordView,
                    ).then((_) => loadSecurity()),
                    label: 'Change Password',
                    isText: true,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
    );
  }
}

Widget securityRow(String label, dynamic value) {
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
            value?.toString().isNotEmpty == true ? value.toString() : 'Not set',
            textAlign: TextAlign.right,
            style: AppText.extraBold,
          ),
        ),
      ],
    ),
  );
}
