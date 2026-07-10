import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/auth_service.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && tokenController.text.isEmpty) {
      tokenController.text = args;
    }
  }

  @override
  void dispose() {
    tokenController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (tokenController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showMessage('Please enter the reset code and new password.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await _authService.resetPassword(
        token: tokenController.text,
        newPassword: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      if (!mounted) {
        return;
      }

      showMessage('Password reset successful. Please log in.');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginView,
        (route) => false,
      );
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to reset password.');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppResponsiveScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appSectionTitle('Reset Password'),
            const SizedBox(height: 8),
            Text(
              'Enter the reset code and choose a new password.',
              style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: tokenController,
              hintText: 'Reset Code',
              icon: const Icon(Icons.key),
            ),
            AppTextField(
              controller: passwordController,
              hintText: 'New Password',
              isObscure: true,
              icon: Image.asset('assets/icons/passwordIcon.png'),
            ),
            AppTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              isObscure: true,
              icon: Image.asset('assets/icons/passwordIcon.png'),
            ),
            AppButton(
              onPressed: resetPassword,
              label: 'Reset Password',
              isText: true,
              isLoading: isSubmitting,
              labelColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
