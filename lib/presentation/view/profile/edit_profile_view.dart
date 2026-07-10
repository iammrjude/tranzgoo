import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = await _apiService.getUser();

      if (!mounted) {
        return;
      }

      fullNameController.text = user['fullName']?.toString() ?? '';
      emailController.text = user['email']?.toString() ?? '';
      phoneController.text = user['phone']?.toString() ?? '';
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load profile.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveProfile() async {
    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      showMessage('Please complete all profile fields.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _apiService.updateUser(
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );

      if (!mounted) {
        return;
      }

      showMessage('Profile updated.');
      Navigator.pop(context);
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to update profile.');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile', style: AppText.extraBold),
      ),
      body: isLoading
          ? const AppLoadingState(message: 'Loading profile...')
          : errorMessage != null
              ? AppErrorState(message: errorMessage!, onRetry: loadProfile)
              : AppResponsiveScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appSectionTitle('Personal Information'),
                      const SizedBox(height: 8),
                      Text(
                        'Update your account details.',
                        style:
                            AppText.mediumStyle.copyWith(letterSpacing: 0.09),
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: fullNameController,
                        hintText: 'Full Name',
                        icon: Image.asset('assets/icons/profileIcon.png'),
                      ),
                      AppTextField(
                        controller: emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        icon: Image.asset('assets/icons/emailIcon.png'),
                      ),
                      AppTextField(
                        controller: phoneController,
                        hintText: 'Phone',
                        keyboardType: TextInputType.phone,
                        icon: Image.asset('assets/icons/phoneIcon.png'),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        onPressed: saveProfile,
                        label: 'Save Changes',
                        isText: true,
                        isLoading: isSaving,
                        labelColor: AppColors.whiteColor,
                      ),
                    ],
                  ),
                ),
    );
  }
}
