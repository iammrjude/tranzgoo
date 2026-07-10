import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppResponsiveScrollView(
        centerVertically: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tranzgooLogo.png',
              width: 110,
              height: 60,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Welcome to TranzGOO',
                  textAlign: TextAlign.center,
                  style: AppText.extraBold.copyWith(
                    fontSize: 30,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Your all-in-one telecom solution! Buy airtime, data, pay bills, and convert airtime to cash effortlessly. Your seamless telecom experience begins here. Enjoy!',
              textAlign: TextAlign.center,
              style: AppText.regularStyle.copyWith(
                fontSize: 16,
                height: 1.35,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            AppButton(
              isText: true,
              onPressed: () {
                Navigator.pushNamed(context, '/createAccountView');
              },
              label: 'Create Account',
            ),
            const SizedBox(
              height: 15,
            ),
            AppButton(
              isText: true,
              onPressed: () {
                Navigator.pushNamed(context, '/loginView');
              },
              label: 'Login',
            ),
          ],
        ),
      ),
    );
  }
}
