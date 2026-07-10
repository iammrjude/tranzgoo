import 'package:flutter/material.dart';

class AppClickableSurface extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final Border? border;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final String? semanticLabel;

  const AppClickableSurface({
    super.key,
    required this.child,
    required this.onTap,
    required this.color,
    required this.borderRadius,
    this.border,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            border: border,
            borderRadius: borderRadius,
          ),
          child: InkWell(
            onTap: onTap,
            mouseCursor: onTap == null
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            borderRadius: borderRadius,
            child: child,
          ),
        ),
      ),
    );

    if (semanticLabel == null) {
      return surface;
    }

    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: surface,
    );
  }
}
