import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tranzgooLogo.png',
              color: AppColors.primaryColor,
              height: 60.08.h,
              width: 110.w,
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              onPressed: () {},
              label: '',
              backgroundColor: Colors.white,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/googleIcon.png',
                    width: 16.w,
                    height: 16.h,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Continue with Goggle',
                    style: AppText.extraBold.copyWith(
                        fontSize: 14.sp, color: AppColors.primaryColor),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              onPressed: () {},
              label: '',
              backgroundColor: Colors.white,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/appleIcon.png',
                    width: 16.w,
                    height: 16.h,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Continue with Apple',
                    style: AppText.extraBold.copyWith(
                        fontSize: 14.sp, color: AppColors.primaryColor),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              onPressed: () {},
              label: '',
              backgroundColor: Colors.white,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/microsoftIcon.png',
                    width: 16.w,
                    height: 16.h,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Continue with Microsoft',
                    style: AppText.extraBold.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.primaryColor,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registerView');
              },
              label: 'Sign Up',
              isText: true,
            ),
          ],
        ),
      ),
    );
  }
}
