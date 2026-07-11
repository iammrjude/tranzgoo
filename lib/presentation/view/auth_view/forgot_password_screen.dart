import 'dart:async';

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

enum _ForgotPasswordStep { email, code, password }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const int _resendCooldownSeconds = 60;

  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  _ForgotPasswordStep step = _ForgotPasswordStep.email;
  String? developmentResetToken;
  Timer? resendTimer;
  int resendSecondsRemaining = 0;
  bool isRequestingCode = false;
  bool isVerifyingCode = false;
  bool isResettingPassword = false;

  @override
  void dispose() {
    resendTimer?.cancel();
    emailController.dispose();
    tokenController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> requestResetCode({bool isResend = false}) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('Please enter your email address.');
      return;
    }

    setState(() {
      isRequestingCode = true;
      developmentResetToken = null;
      if (isResend) {
        tokenController.clear();
      }
    });

    try {
      final data = await _authService.forgotPassword(email);

      if (!mounted) {
        return;
      }

      setState(() {
        developmentResetToken = data['resetToken']?.toString();
        step = _ForgotPasswordStep.code;
      });
      startResendCountdown();
      showMessage(isResend ? 'New reset code sent.' : 'Reset code sent.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to start password reset.');
    } finally {
      if (mounted) {
        setState(() {
          isRequestingCode = false;
        });
      }
    }
  }

  void startResendCountdown() {
    resendTimer?.cancel();
    setState(() {
      resendSecondsRemaining = _resendCooldownSeconds;
    });

    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (resendSecondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          resendSecondsRemaining = 0;
        });
        return;
      }

      setState(() {
        resendSecondsRemaining -= 1;
      });
    });
  }

  Future<void> continueToPassword() async {
    if (tokenController.text.trim().isEmpty) {
      showMessage('Please enter the reset code.');
      return;
    }

    setState(() {
      isVerifyingCode = true;
    });

    try {
      await _authService.verifyResetCode(tokenController.text);

      if (!mounted) {
        return;
      }

      setState(() {
        step = _ForgotPasswordStep.password;
      });
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to verify reset code.');
    } finally {
      if (mounted) {
        setState(() {
          isVerifyingCode = false;
        });
      }
    }
  }

  Future<void> resetPassword() async {
    if (tokenController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showMessage('Please enter the reset code and new password.');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showMessage('Passwords do not match.');
      return;
    }

    setState(() {
      isResettingPassword = true;
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
          isResettingPassword = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String formatCountdown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          icon: Image.asset('assets/icons/emailIcon.png'),
        ),
        AppButton(
          onPressed: requestResetCode,
          label: 'Send Reset Code',
          isText: true,
          isLoading: isRequestingCode,
        ),
      ],
    );
  }

  Widget buildCodeStep() {
    final canResend = resendSecondsRemaining == 0 && !isRequestingCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInfoCard(
          color: AppColors.primaryLightColor,
          child: Text(
            'We sent a reset code to ${emailController.text.trim()}.',
            style: AppText.mediumStyle.copyWith(
              color: AppColors.primaryColor,
              letterSpacing: 0.09,
            ),
          ),
        ),
        AppTextField(
          controller: tokenController,
          hintText: 'Reset Code',
          icon: const Icon(Icons.key),
        ),
        AppButton(
          onPressed: continueToPassword,
          label: 'Continue',
          isText: true,
          isLoading: isVerifyingCode,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                resendSecondsRemaining > 0
                    ? 'Resend code in ${formatCountdown(resendSecondsRemaining)}'
                    : 'Did not receive a code?',
                style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
              ),
            ),
            TextButton(
              onPressed: canResend
                  ? () => requestResetCode(isResend: true)
                  : null,
              child: Text(
                'Resend',
                style: AppText.extraBold.copyWith(
                  color: canResend ? AppColors.primaryColor : AppColors.grey400,
                  letterSpacing: 0.09,
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            setState(() {
              step = _ForgotPasswordStep.email;
              developmentResetToken = null;
            });
          },
          child: Text(
            'Use a different email',
            style: AppText.extraBold.copyWith(
              color: AppColors.primaryColor,
              letterSpacing: 0.09,
            ),
          ),
        ),
        if (developmentResetToken != null) buildDevelopmentCodeCard(),
      ],
    );
  }

  Widget buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          isLoading: isResettingPassword,
          labelColor: AppColors.whiteColor,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              step = _ForgotPasswordStep.code;
            });
          },
          child: Text(
            'Back to reset code',
            style: AppText.extraBold.copyWith(
              color: AppColors.primaryColor,
              letterSpacing: 0.09,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDevelopmentCodeCard() {
    return AppInfoCard(
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
          SelectableText(developmentResetToken!),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: developmentResetToken!));
              showMessage('Reset code copied.');
            },
            child: const Text('Copy code'),
          ),
        ],
      ),
    );
  }

  Widget buildActiveStep() {
    switch (step) {
      case _ForgotPasswordStep.email:
        return buildEmailStep();
      case _ForgotPasswordStep.code:
        return buildCodeStep();
      case _ForgotPasswordStep.password:
        return buildPasswordStep();
    }
  }

  String get subtitle {
    switch (step) {
      case _ForgotPasswordStep.email:
        return 'Enter your email address and we will send a reset code.';
      case _ForgotPasswordStep.code:
        return 'Enter the reset code sent to your email.';
      case _ForgotPasswordStep.password:
        return 'Choose a new password for your account.';
    }
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
              subtitle,
              style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
            ),
            const SizedBox(height: 24),
            buildActiveStep(),
          ],
        ),
      ),
    );
  }
}
