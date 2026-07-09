import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/auth_service.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
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
  final AuthService _authService = AuthService();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _authService.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.baseView,
        (route) => false,
      );
    } on ApiException catch (error) {
      showMessage(error.message);
    } on FormatException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                  isObscure: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('I already have an account'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.loginView);
                      },
                      child: const Text('Sign in'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                AppButton(
                  onPressed: register,
                  label: 'Submit',
                  isText: true,
                  isLoading: isLoading,
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
