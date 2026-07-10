import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/session_storage.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_clickable_surface.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final SessionStorage _sessionStorage = SessionStorage();
  Map<String, dynamic>? user;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getUser();

      if (!mounted) {
        return;
      }

      setState(() {
        user = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load profile.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> logout() async {
    await _sessionStorage.clear();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginView,
      (route) => false,
    );
  }

  Future<void> openAndReload(String route) async {
    await Navigator.pushNamed(context, route);
    if (mounted) {
      loadProfile();
    }
  }

  void goHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.baseView,
      (route) => false,
    );
  }

  void goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    goHome();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: AppLoadingState(message: 'Loading profile...'),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: AppErrorState(message: errorMessage!, onRetry: loadProfile),
      );
    }

    final fullName = user?['fullName']?.toString() ?? 'TranzGOO User';
    final email = user?['email']?.toString() ?? '';
    final tranzgoId = user?['tranzgoId']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
        ),
        title: Text(
          'Profile',
          style: AppText.extraBold.copyWith(fontSize: 28, letterSpacing: 2),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Go home',
            onPressed: goHome,
            icon: const Icon(
              Icons.home,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadProfile,
        color: AppColors.primaryColor,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: AppText.extraBold.copyWith(
                          fontSize: 20,
                          letterSpacing: 0.09,
                        ),
                      ),
                      Text(
                        'Manage your TranzGOO account from here',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.regularStyle.copyWith(
                          fontSize: 18,
                          letterSpacing: 0.09,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => openAndReload(AppRoutes.editProfileView),
                  icon: Image.asset('assets/icons/edit.png'),
                ),
              ],
            ),
            const SizedBox(height: 58),
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(46),
                child: Image.asset(
                  'assets/images/person.png',
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.extraBold.copyWith(
                          fontSize: 22,
                          letterSpacing: 0.09,
                        ),
                      ),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.regularStyle.copyWith(
                          fontSize: 18,
                          letterSpacing: 0.09,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      'TG ID',
                      style: AppText.bold.copyWith(
                        fontSize: 18,
                        letterSpacing: 0.09,
                      ),
                    ),
                    Text(
                      tranzgoId,
                      style: AppText.lightStyle.copyWith(
                        fontSize: 13,
                        letterSpacing: 0.09,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'General settings',
              style: AppText.mediumStyle.copyWith(
                fontSize: 18,
                letterSpacing: 0.09,
              ),
            ),
            const SizedBox(height: 15),
            settingsWidget(
              child: Image.asset(
                'assets/icons/Group 3.png',
                height: 32,
                width: 32,
              ),
              title: 'Personal Information',
              subTitle: 'Edit your information',
              onTap: () => openAndReload(AppRoutes.editProfileView),
            ),
            settingsWidget(
              child: Image.asset('assets/icons/notification.png'),
              title: 'Notifications',
              subTitle: 'Read account updates',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.notificationsView),
            ),
            settingsWidget(
              child: Image.asset('assets/icons/mdi_talk.png'),
              title: 'Refer a friend',
              subTitle: 'Get rewards when you tell a friend',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.referralsView),
            ),
            settingsWidget(
              child: Image.asset('assets/icons/Vector.png'),
              title: 'Settings',
              subTitle: 'Security, password, notifications',
              onTap: () => Navigator.pushNamed(context, AppRoutes.settingsView),
            ),
            settingsWidget(
              child: Image.asset('assets/icons/bx_support.png'),
              title: 'Support',
              subTitle: 'Contact us',
              onTap: () => Navigator.pushNamed(context, AppRoutes.supportView),
            ),
            settingsWidget(
              child: Image.asset('assets/icons/ant-design_read-filled.png'),
              title: 'Legal',
              subTitle: 'Application rules, legal and policies',
              onTap: () => Navigator.pushNamed(context, AppRoutes.legalView),
            ),
            settingsWidget(
              child: Image.asset('assets/icons/solar_logout-2-bold.png'),
              title: 'Logout',
              icon: const SizedBox(),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}

Widget settingsWidget({
  Widget? child,
  String? title,
  String? subTitle,
  Widget? icon,
  VoidCallback? onTap,
}) {
  return AppClickableSurface(
    onTap: onTap,
    semanticLabel: title,
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: child,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bold.copyWith(
                        fontSize: 14,
                        letterSpacing: 0.09,
                      ),
                    ),
                    Text(
                      subTitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.mediumStyle.copyWith(
                        fontSize: 11,
                        letterSpacing: 0.09,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        icon ??
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.primaryColor,
            ),
      ],
    ),
  );
}
