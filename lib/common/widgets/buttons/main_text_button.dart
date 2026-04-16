import 'package:flutter/material.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';

class MainTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const MainTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<MainTextButton> createState() => _MainTextButtonState();
}

class _MainTextButtonState extends State<MainTextButton> {
  double _scale = 1.0;
  double _opacity = 1.0;

  void _onTapDown() {
    setState(() {
      _scale = 0.96;
      _opacity = 0.6;
    });
  }

  void _onTapUp() {
    setState(() {
      _scale = 1.0;
      _opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // better tap area
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: _onTapUp,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: _opacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
