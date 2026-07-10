import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  Map<String, bool> preferences = {
    'accountUpdates': true,
    'transactions': true,
    'promotions': false,
    'securityAlerts': true,
  };
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getNotificationPreferences();

      if (!mounted) {
        return;
      }

      setState(() {
        preferences = {
          'accountUpdates': data['accountUpdates'] != false,
          'transactions': data['transactions'] != false,
          'promotions': data['promotions'] == true,
          'securityAlerts': data['securityAlerts'] != false,
        };
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load notification preferences.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> savePreferences() async {
    setState(() {
      isSaving = true;
    });

    try {
      final data = await _apiService.updateNotificationPreferences(preferences);

      if (!mounted) {
        return;
      }

      setState(() {
        preferences = {
          'accountUpdates': data['accountUpdates'] != false,
          'transactions': data['transactions'] != false,
          'promotions': data['promotions'] == true,
          'securityAlerts': data['securityAlerts'] != false,
        };
      });
      showMessage('Notification preferences updated.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to update notification preferences.');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void setPreference(String key, bool value) {
    setState(() {
      preferences[key] = value;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications', style: AppText.extraBold),
      ),
      body: isLoading
          ? const AppLoadingState(message: 'Loading preferences...')
          : errorMessage != null
          ? AppErrorState(message: errorMessage!, onRetry: loadPreferences)
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              children: [
                appSectionTitle('Notification Preferences'),
                const SizedBox(height: 16),
                preferenceTile(
                  title: 'Account Updates',
                  subtitle: 'Profile, wallet, and account messages',
                  value: preferences['accountUpdates'] ?? true,
                  onChanged: (value) => setPreference('accountUpdates', value),
                ),
                preferenceTile(
                  title: 'Transactions',
                  subtitle: 'Receipts and wallet activity',
                  value: preferences['transactions'] ?? true,
                  onChanged: (value) => setPreference('transactions', value),
                ),
                preferenceTile(
                  title: 'Promotions',
                  subtitle: 'Offers and service announcements',
                  value: preferences['promotions'] ?? false,
                  onChanged: (value) => setPreference('promotions', value),
                ),
                preferenceTile(
                  title: 'Security Alerts',
                  subtitle: 'Login and password activity',
                  value: preferences['securityAlerts'] ?? true,
                  onChanged: (value) => setPreference('securityAlerts', value),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onPressed: savePreferences,
                  label: 'Save Preferences',
                  isText: true,
                  isLoading: isSaving,
                  width: double.infinity,
                ),
              ],
            ),
    );
  }
}

Widget preferenceTile({
  required String title,
  required String subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return AppInfoCard(
    child: SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primaryColor,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppText.extraBold.copyWith(letterSpacing: 0.09),
      ),
      subtitle: Text(
        subtitle,
        style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
      ),
    ),
  );
}
