import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

class AppLoadingState extends StatelessWidget {
  final String message;

  const AppLoadingState({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
          ),
          const SizedBox(height: 12),
          Text(message, style: AppText.mediumStyle),
        ],
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const AppEmptyState({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.extraBold.copyWith(
                color: AppColors.primaryColor,
                fontSize: 16,
                letterSpacing: 0.09,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
            ),
          ],
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryColor),
              ),
              child: Text(
                'Retry',
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

class AppInfoCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const AppInfoCard({
    super.key,
    required this.child,
    this.color = AppColors.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

Widget appSectionTitle(String title) {
  return Text(
    title,
    style: AppText.extraBold.copyWith(
      color: AppColors.primaryColor,
      fontSize: 16,
      letterSpacing: 0.09,
    ),
  );
}
