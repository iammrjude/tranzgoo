import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

import 'profile_view.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings', style: AppText.extraBold),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        children: [
          appSectionTitle('Account Settings'),
          const SizedBox(height: 16),
          settingsWidget(
            child: const Icon(Icons.security),
            title: 'Security',
            subTitle: 'Review your account security',
            onTap: () => Navigator.pushNamed(context, AppRoutes.securityView),
          ),
          settingsWidget(
            child: const Icon(Icons.lock),
            title: 'Change Password',
            subTitle: 'Update your login password',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.changePasswordView),
          ),
          settingsWidget(
            child: const Icon(Icons.notifications),
            title: 'Notification Preferences',
            subTitle: 'Choose what updates you receive',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.notificationPreferencesView,
            ),
          ),
          settingsWidget(
            child: const Icon(Icons.description),
            title: 'Legal',
            subTitle: 'Terms, privacy, and refund policy',
            onTap: () => Navigator.pushNamed(context, AppRoutes.legalView),
          ),
        ],
      ),
    );
  }
}
