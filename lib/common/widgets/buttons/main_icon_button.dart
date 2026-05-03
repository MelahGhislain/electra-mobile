import 'package:flutter/material.dart';

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
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? Theme.of(context).dividerColor,
              ),
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
