import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/home_view/component/account_card.dart';
import 'package:tranzgoo/presentation/view/home_view/component/carousel_slider.dart';
import 'package:tranzgoo/presentation/view/home_view/component/history_component.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_clickable_surface.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  Map<String, dynamic>? user;
  Map<String, dynamic>? wallet;
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadHome();
  }

  Future<void> loadHome() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _apiService.getUser(),
        _apiService.getWallet(),
        _apiService.getTransactions(limit: 5),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        user = results[0] as Map<String, dynamic>;
        wallet = results[1] as Map<String, dynamic>;
        transactions = results[2] as List<Map<String, dynamic>>;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load your dashboard.';
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
    if (isLoading) {
      return const Scaffold(body: AppLoadingState(message: 'Loading home...'));
    }

    if (errorMessage != null) {
      return Scaffold(
        body: AppErrorState(
          message: errorMessage!,
          onRetry: loadHome,
        ),
      );
    }

    final fullName = user?['fullName']?.toString() ?? 'TranzGOO User';
    final firstName =
        fullName.split(' ').where((part) => part.isNotEmpty).isEmpty
            ? fullName
            : fullName.split(' ').first;
    final tranzgoId = user?['tranzgoId']?.toString() ?? '';
    final balance = wallet?['balance']?.toString() ?? '0.00';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: loadHome,
          color: AppColors.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(48),
                          child: Image.asset('assets/images/person.png'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  greeting(),
                                  style: AppText.extraBold.copyWith(
                                    fontSize: 16,
                                    letterSpacing: 0.092,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Image.asset('assets/icons/Group 9.png'),
                              ],
                            ),
                            Text(
                              firstName,
                              style: AppText.mediumStyle.copyWith(
                                fontSize: 16,
                                letterSpacing: 0.092,
                              ),
                            ),
                            Text(
                              tranzgoId,
                              style: AppText.lightStyle.copyWith(
                                color: AppColors.grey500,
                                letterSpacing: 0.092,
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    AppClickableSurface(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.notificationsView,
                      ),
                      semanticLabel: 'Open notifications',
                      height: 23.h,
                      width: 23.w,
                      color: AppColors.whiteColor,
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset('assets/icons/notification.png'),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                AccountCard(
                  balance: balance,
                  onSend: () => Navigator.pushNamed(context, AppRoutes.sendView)
                      .then((_) => loadHome()),
                  onFund: () => Navigator.pushNamed(
                    context,
                    AppRoutes.fundAccountView,
                  ).then((_) => loadHome()),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset('assets/icons/bolt.png'),
                    const SizedBox(width: 5),
                    Text(
                      'Quick Access',
                      style: AppText.extraBold.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    quickAccessContainer(
                      icon: Image.asset(
                        'assets/icons/phoneIcon.png',
                        height: 16,
                        width: 16,
                        color: AppColors.primaryColor,
                      ),
                      text: 'Airtime',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.airtimeView),
                    ),
                    quickAccessContainer(
                      icon: Image.asset(
                        'assets/icons/search.png',
                        color: AppColors.primaryColor,
                      ),
                      text: 'Data',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.dataView),
                    ),
                    quickAccessContainer(
                      icon: Image.asset(
                        'assets/icons/ph_swap-fill.png',
                        color: AppColors.primaryColor,
                      ),
                      text: 'Airtime2cash',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.airtimeToCashView,
                      ),
                    ),
                    quickAccessContainer(
                      icon: const Icon(
                        Icons.more_horiz,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      text: 'More',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.servicesView),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 316.h,
                  width: MediaQuery.of(context).size.width,
                  child: const CarouselComponent(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'History',
                      style: AppText.mediumStyle.copyWith(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.historyView),
                      child: Text(
                        'View all',
                        style: AppText.extraBold.copyWith(
                          color: AppColors.primaryColor,
                          letterSpacing: 0.09,
                        ),
                      ),
                    ),
                  ],
                ),
                HistoryComponent(transactions: transactions),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String greeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good morning';
  }

  if (hour < 17) {
    return 'Good afternoon';
  }

  return 'Good evening';
}

Widget quickAccessContainer({
  required Widget icon,
  required String text,
  required VoidCallback onTap,
}) {
  return AppClickableSurface(
    onTap: onTap,
    semanticLabel: text,
    height: 50.h,
    color: AppColors.whiteColor,
    border: Border.all(color: AppColors.primaryColor),
    borderRadius: BorderRadius.circular(10),
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.mediumStyle.copyWith(
            color: AppColors.primaryColor,
            letterSpacing: 0.092,
          ),
        )
      ],
    ),
  );
}
