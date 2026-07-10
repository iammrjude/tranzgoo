import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showMessage('Please complete all password fields.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await _apiService.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      if (!mounted) {
        return;
      }

      showMessage('Password changed successfully.');
      Navigator.pop(context);
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to change password.');
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Change Password', style: AppText.extraBold),
      ),
      body: AppResponsiveScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appSectionTitle('Secure Your Account'),
            const SizedBox(height: 8),
            Text(
              'Use a strong password that is hard to guess.',
              style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: currentPasswordController,
              hintText: 'Current Password',
              isObscure: true,
              icon: Image.asset('assets/icons/passwordIcon.png'),
            ),
            AppTextField(
              controller: newPasswordController,
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
            const SizedBox(height: 14),
            AppButton(
              onPressed: changePassword,
              label: 'Update Password',
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
