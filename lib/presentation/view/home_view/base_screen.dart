import 'package:flutter/material.dart';
import 'package:tranzgoo/presentation/view/history/history_view.dart';
import 'package:tranzgoo/presentation/view/home_view/home_screen.dart';
import 'package:tranzgoo/presentation/view/profile/profile_view.dart';
import 'package:tranzgoo/presentation/view/services/services_view.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';

class BaseView extends StatefulWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int selectedItem = 0;
  final List<BottomNavigationBarItem> bottomNavItem = [
    BottomNavigationBarItem(
        icon: Image.asset('assets/icons/homeIcon.png'), label: 'Home'),
    BottomNavigationBarItem(
        icon: Image.asset('assets/icons/service.png'), label: 'Service'),
    BottomNavigationBarItem(
        icon: Image.asset('assets/icons/history.png'), label: 'History'),
    BottomNavigationBarItem(
        icon: Image.asset('assets/icons/profile2.png'), label: 'Profile'),
  ];
  List<Widget> navigationItems = [
    const HomeScreen(),
    const ServiceScreen(),
    const HistoryScreen(),
    const ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.scaffoldLayoutColor,
        fixedColor: AppColors.primaryColor,
        items: bottomNavItem,
        currentIndex: selectedItem,
        onTap: (value) {
          setState(
            () {
              selectedItem = value;
            },
          );
        },
      ),
      body: navigationItems.elementAt(selectedItem),
    );
  }
}
