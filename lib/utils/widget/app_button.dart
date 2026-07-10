import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String label;
  final Color? labelColor;
  final bool isText;
  final Widget? widget;
  final double? labelFontSize;
  final bool isLoading;
  final double? width;

  const AppButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.widget,
    required this.label,
    this.isText = false,
    this.isLoading = false,
    this.labelColor,
    this.width,
    this.labelFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final requestedWidth = width ?? double.infinity;
        final viewportSafeWidth = math.max(
          0.0,
          MediaQuery.sizeOf(context).width - 56,
        );
        final constrainedWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 360.0;
        final maxWidth = math.min(constrainedWidth, viewportSafeWidth);
        final effectiveWidth = requestedWidth.isFinite
            ? requestedWidth.clamp(0.0, maxWidth)
            : maxWidth;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 48,
            width: effectiveWidth,
            child: ElevatedButton(
              onPressed: isLoading ? () {} : onPressed,
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    side: const BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  backgroundColor ?? AppColors.primaryColor,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : isText
                  ? Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppText.extraBold.copyWith(
                        fontSize: labelFontSize ?? 16,
                        color: labelColor ?? Colors.white,
                      ),
                    )
                  : widget,
            ),
          ),
        );
      },
    );
  }
}
