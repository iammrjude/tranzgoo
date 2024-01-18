import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    Key? key,
    required this.onPressed,
    this.backgroundColor,
    this.widget,
    required this.label,
    this.isText = false,
    this.isLoading = false,
    this.labelColor,
    this.width,
    this.labelFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 33.h,
        width: width ?? 254.w,
        child: ElevatedButton(
          onPressed: isLoading ? () {} : onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(12))),
            backgroundColor: MaterialStateProperty.all<Color>(
                backgroundColor ?? AppColors.primaryColor),
          ),
          child: isLoading
              ? SizedBox(
                  height: 30.h,
                  width: 30.h,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : isText
                  ? Text(
                      label,
                      style: AppText.extraBold.copyWith(
                        fontSize: labelFontSize ?? 14.sp,
                        color: labelColor ?? Colors.white,
                      ),
                    )
                  : widget,
        ),
      ),
    );
  }
}
