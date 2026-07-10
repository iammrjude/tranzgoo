import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({super.key});

  @override
  State<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends State<ReferralsScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController recipientController = TextEditingController();
  Map<String, dynamic>? referrals;
  bool isLoading = true;
  bool isSending = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadReferrals();
  }

  @override
  void dispose() {
    recipientController.dispose();
    super.dispose();
  }

  Future<void> loadReferrals() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getReferrals();

      if (!mounted) {
        return;
      }

      setState(() {
        referrals = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load referral details.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> sendInvite() async {
    if (recipientController.text.trim().isEmpty) {
      showMessage('Please enter an email or phone number.');
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      await _apiService.sendReferralInvite(recipientController.text);
      recipientController.clear();
      showMessage('Referral invite accepted for processing.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to send referral invite.');
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  void copyInvite() {
    final message = referrals?['inviteMessage']?.toString() ?? '';

    if (message.isEmpty) {
      return;
    }

    Clipboard.setData(ClipboardData(text: message));
    showMessage('Referral message copied.');
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
        title: const Text('Referrals', style: AppText.extraBold),
      ),
      body: isLoading
          ? const AppLoadingState(message: 'Loading referrals...')
          : errorMessage != null
          ? AppErrorState(message: errorMessage!, onRetry: loadReferrals)
          : AppResponsiveScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appSectionTitle('Invite Friends'),
                  const SizedBox(height: 8),
                  Text(
                    'Share your referral code and track invites.',
                    style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
                  ),
                  const SizedBox(height: 20),
                  AppInfoCard(
                    color: AppColors.primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Referral Code',
                          style: AppText.mediumStyle.copyWith(
                            color: AppColors.whiteColor,
                            letterSpacing: 0.09,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          referrals?['referralCode']?.toString() ?? '',
                          style: AppText.extraBold.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 24,
                            letterSpacing: 0.09,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Referred users: ${referrals?['referredCount'] ?? 0}',
                          style: AppText.mediumStyle.copyWith(
                            color: AppColors.whiteColor,
                            letterSpacing: 0.09,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppInfoCard(
                    child: Text(
                      referrals?['inviteMessage']?.toString() ?? '',
                      style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
                    ),
                  ),
                  AppButton(
                    onPressed: copyInvite,
                    label: 'Copy Invite Message',
                    isText: true,
                  ),
                  const SizedBox(height: 18),
                  AppTextField(
                    controller: recipientController,
                    hintText: 'Friend email or phone',
                    icon: Image.asset('assets/icons/emailIcon.png'),
                  ),
                  AppButton(
                    onPressed: sendInvite,
                    label: 'Send Invite',
                    isText: true,
                    isLoading: isSending,
                  ),
                ],
              ),
            ),
    );
  }
}
