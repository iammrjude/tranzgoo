import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/auth_service.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  String? resetToken;
  bool isSubmitting = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (emailController.text.trim().isEmpty) {
      showMessage('Please enter your email address.');
      return;
    }

    setState(() {
      isSubmitting = true;
      resetToken = null;
    });

    try {
      final data = await _authService.forgotPassword(emailController.text);

      if (!mounted) {
        return;
      }

      setState(() {
        resetToken = data['resetToken']?.toString();
      });
      showMessage('Password reset instructions sent.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to start password reset.');
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
            appSectionTitle('Forgot Password'),
            const SizedBox(height: 8),
            Text(
              'Enter your email address and we will send a reset code.',
              style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              icon: Image.asset('assets/icons/emailIcon.png'),
            ),
            AppButton(
              onPressed: submit,
              label: 'Send Reset Code',
              isText: true,
              isLoading: isSubmitting,
            ),
            const SizedBox(height: 16),
            if (resetToken != null)
              AppInfoCard(
                color: AppColors.primaryLightColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Development reset code',
                      style: AppText.extraBold.copyWith(
                        color: AppColors.primaryColor,
                        letterSpacing: 0.09,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(resetToken!),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: resetToken!));
                        showMessage('Reset code copied.');
                      },
                      child: const Text('Copy code'),
                    ),
                  ],
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.resetPasswordView,
                arguments: resetToken,
              ),
              child: Text(
                'I have a reset code',
                style: AppText.extraBold.copyWith(
                  color: AppColors.primaryColor,
                  letterSpacing: 0.09,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
