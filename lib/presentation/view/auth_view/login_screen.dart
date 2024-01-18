import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/tranzgooLogo.png',
                  color: AppColors.primaryColor,
                  height: 60,
                  width: 110,
                ),
                Text(
                  'Login',
                  style: AppText.extraBold.copyWith(fontSize: 19.sp),
                ),
                const SizedBox(
                  height: 13,
                ),
                AppTextField(
                    controller: emailController,
                    icon: Image.asset('assets/icons/emailIcon.png'),
                    hintText: 'Email'),
                AppTextField(
                    controller: passwordController,
                    isObscure: true,
                    icon: Image.asset('assets/icons/passwordIcon.png'),
                    hintText: 'Password'),
                const SizedBox(
                  height: 10,
                ),
                AppButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/baseView');
                  },
                  label: 'Login',
                  isText: true,
                  labelColor: AppColors.whiteColor,
                  width: 322.w,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onLongPress: () {},
                    child: Image.asset('assets/icons/fingerprint.png'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
