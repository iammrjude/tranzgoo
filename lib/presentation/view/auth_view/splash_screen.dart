import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigateTo() {
    Navigator.pushReplacementNamed(context, '/welcomeView');
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (mounted) {
          navigateTo();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset('assets/images/tranzgooLogo.png'),
      ),
    );
  }
}
