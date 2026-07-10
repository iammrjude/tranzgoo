import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/auth_service.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter your email and password.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _authService.login(
        email: email,
        password: password,
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
      body: AppResponsiveScrollView(
        centerVertically: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/tranzgooLogo.png',
              color: AppColors.primaryColor,
              height: 60,
              width: 110,
            ),
            Text(
              'Login',
              style: AppText.extraBold.copyWith(fontSize: 24),
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.forgotPasswordView,
                ),
                child: Text(
                  'Forgot password?',
                  style: AppText.extraBold.copyWith(
                    color: AppColors.primaryColor,
                    letterSpacing: 0.09,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AppButton(
              onPressed: login,
              label: 'Login',
              isText: true,
              isLoading: isLoading,
              labelColor: AppColors.whiteColor,
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/icons/fingerprint.png')
          ],
        ),
      ),
    );
  }
}
