import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';

class AppResponsive {
  static const double desktopBreakpoint = 700;
  static const double appMaxWidth = 560;
  static const double formMaxWidth = 420;

  static bool isWide(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= desktopBreakpoint;
  }

  static double clampDouble(double value, double min, double max) {
    return math.min(math.max(value, min), max);
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 360 ? 20.0 : 28.0;
    return EdgeInsets.fromLTRB(horizontal, 20, horizontal, 30);
  }
}

class AppResponsiveFrame extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const AppResponsiveFrame({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    if (size.width < AppResponsive.desktopBreakpoint) {
      return child;
    }

    final framedWidth = math.min(size.width, AppResponsive.appMaxWidth);

    return ColoredBox(
      color: backgroundColor ?? AppColors.scaffoldLayoutColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppResponsive.appMaxWidth,
          ),
          child: MediaQuery(
            data: mediaQuery.copyWith(size: Size(framedWidth, size.height)),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AppResponsiveScrollView extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool centerVertically;
  final ScrollPhysics physics;

  const AppResponsiveScrollView({
    super.key,
    required this.child,
    this.maxWidth = AppResponsive.formMaxWidth,
    this.padding,
    this.centerVertically = false,
    this.physics = const BouncingScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = (padding ?? AppResponsive.pagePadding(context))
        .resolve(Directionality.of(context));

    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minHeight = math.max(
            0.0,
            constraints.maxHeight - resolvedPadding.vertical,
          );

          return SingleChildScrollView(
            physics: physics,
            child: Padding(
              padding: resolvedPadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Align(
                  alignment: centerVertically
                      ? Alignment.center
                      : Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
