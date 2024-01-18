import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
                Text(
                  'Register',
                  style: AppText.extraBold.copyWith(fontSize: 19.sp),
                ),
                Text(
                  'Your all-in-one telecom solution! Buy \nairtime, data, pay bills, and convert \nairtime to cash effortlessly',
                  style: AppText.regularStyle.copyWith(fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 25,
                ),
                AppTextField(
                  controller: fullNameController,
                  icon: Image.asset('assets/icons/profileIcon.png'),
                  hintText: 'Full Name',
                ),
                AppTextField(
                  controller: emailController,
                  icon: Image.asset('assets/icons/emailIcon.png'),
                  hintText: 'Email',
                ),
                AppTextField(
                  controller: phoneController,
                  icon: Image.asset('assets/icons/phoneIcon.png'),
                  hintText: 'Phone',
                ),
                AppTextField(
                  controller: passwordController,
                  icon: Image.asset('assets/icons/passwordIcon.png'),
                  hintText: 'Password',
                  isObscure: true,
                ),
                AppTextField(
                  controller: confirmPasswordController,
                  icon: Image.asset('assets/icons/passwordIcon.png'),
                  hintText: 'Confirm Password',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('I already have an account'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loginView');
                      },
                      child: const Text('Sign in'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                AppButton(
                  onPressed: () {},
                  label: 'Submit',
                  isText: true,
                  labelColor: AppColors.whiteColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
