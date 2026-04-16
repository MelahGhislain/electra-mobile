import 'package:flutter/material.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';

enum ButtonSize { small, medium, large }

class MainButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon;
  final ButtonSize size;
  final bool? isActive;
  final double? width;
  final bool? rounded;

  const MainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium, // ✅ default
    this.isActive = true,
    this.width,
    this.rounded = false,
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  double _scale = 1.0;
  double _opacity = 1.0;

  void _onTapDown() {
    setState(() {
      _scale = 0.96;
      _opacity = 0.7; // ✅ text fades
    });
  }

  void _onTapUp() {
    setState(() {
      _scale = 1.0;
      _opacity = 1.0;
    });
  }

  double get _height {
    switch (widget.size) {
      case ButtonSize.small:
        return 54;
      case ButtonSize.medium:
        return 62; // your current default
      case ButtonSize.large:
        return 70;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case ButtonSize.small:
        return AppFontSize.buttonTextSmall;
      case ButtonSize.medium:
        return AppFontSize.buttonText;
      case ButtonSize.large:
        return AppFontSize.buttonTextLarge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFullWidth = widget.width == double.infinity;

    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: _onTapUp,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: isFullWidth
            ? _buildButton()
            : IntrinsicWidth(
                child: _buildButton(),
              ), // ✅ fit content if not full
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: widget.width,
      height: _height,
      decoration: BoxDecoration(
        color: widget.isActive == true
            ? AppColors.lightText
            : AppColors.darkText,
        borderRadius: widget.rounded == true
            ? BorderRadius.circular(999)
            : BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                (widget.isActive == true
                        ? AppColors.lightBackground
                        : AppColors.darkBackground)
                    .withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: _opacity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.icon ?? const SizedBox.shrink(),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
                color: widget.isActive == true
                    ? AppColors.darkText
                    : AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
