import 'dart:math' as math;

import 'package:flutter/material.dart';
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
  final TextInputType? keyboardType;
  final Function(String)? validate;
  const AppTextField({
    super.key,
    required this.controller,
    this.textCenter = false,
    this.icon,
    this.validate,
    this.isObscure = false,
    required this.hintText,
    this.width,
    this.height,
    this.keyboardType,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final requestedWidth = widget.width ?? double.infinity;
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

        return Container(
          constraints: BoxConstraints(minHeight: widget.height ?? 48),
          width: effectiveWidth,
          margin: const EdgeInsets.only(bottom: 17),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textAlign: widget.textCenter ? TextAlign.center : TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            obscureText: widget.isObscure && !isPasswordVisible,
            validator: (e) {
              return widget.validate != null ? widget.validate!(e!) : null;
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintStyle: AppText.extraBold.copyWith(
                color: AppColors.primaryColor,
                fontSize: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: widget.icon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 18, right: 10),
                      child: SizedBox.square(
                        dimension: 22,
                        child: Center(child: widget.icon),
                      ),
                    ),
              prefixIconConstraints: const BoxConstraints(
                minHeight: 24,
                minWidth: 46,
              ),
              filled: true,
              fillColor: AppColors.whiteColor,
              suffixIcon: widget.isObscure
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: isPasswordVisible
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
                  : null,
            ),
          ),
        );
      },
    );
  }
}
