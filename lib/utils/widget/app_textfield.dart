import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final Widget? icon;
  final bool isObscure;
  final String hintText;
  final double? width;
  final bool textCenter;
  final double? height;
  final Function(String)? validate;
  const AppTextField({
    Key? key,
    required this.controller,
    this.textCenter = false,
    this.icon,
    this.validate,
    this.isObscure = false,
    required this.hintText,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isPassword = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 33.h,
      width: widget.width ?? double.infinity,
      margin: const EdgeInsets.only(
        bottom: 17,
      ),
      child: TextFormField(
        controller: widget.controller,
        textAlign: widget.textCenter ? TextAlign.center : TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        obscureText: widget.isObscure ? isPassword : !isPassword,
        validator: (e) {
          return widget.validate != null ? widget.validate!(e!) : null;
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintStyle: AppText.extraBold
              .copyWith(color: AppColors.primaryColor, fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: AppColors.primaryColor, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 30, right: 10),
            child: widget.icon ?? const SizedBox(),
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
          suffixIcon: widget.isObscure
              ? IconButton(
                  onPressed: () {
                    setState(
                      () {
                        isPassword = !isPassword;
                      },
                    );
                  },
                  icon: isPassword
                      ? const Icon(
                          Icons.visibility_off,
                          color: AppColors.primaryColor,
                          size: 17,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: AppColors.primaryColor,
                          size: 17,
                        ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
