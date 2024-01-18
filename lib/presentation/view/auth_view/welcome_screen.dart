import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tranzgooLogo.png',
              width: 110.w,
              height: 60.08.h,
              color: AppColors.primaryColor,
            ),
            Text(
              'Welcome to TranzGOO',
              style: AppText.extraBold.copyWith(fontSize: 19.sp),
            ),
            Text(
              'Your all-in-one telecom solution! Buy airtime, data, \npay bills, and convert airtime to cash effortlessly. \nYour seamless telecom \nexperience begins here. Enjoy!',
              textAlign: TextAlign.center,
              style: AppText.regularStyle.copyWith(fontSize: 12.sp,letterSpacing: 0),
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
