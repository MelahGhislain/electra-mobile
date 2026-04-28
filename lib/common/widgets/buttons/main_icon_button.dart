import 'package:flutter/material.dart';
import 'package:electra/core/configs/theme/app_colors.dart';

class MainIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget icon;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;

  const MainIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 36,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 10,
    this.margin,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: size,
            height: size,
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.lightSurface,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor ?? AppColors.dividerLight),
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
