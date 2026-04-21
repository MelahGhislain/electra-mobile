import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BlurredPopup extends StatelessWidget {
  final Widget child;
  final double widthFactor; // e.g., 0.88 = 88% of screen width
  final double? maxHeightFactor;

  static const double borderRadius = 32.0;

  const BlurredPopup({
    super.key,
    required this.child,
    this.widthFactor = 0.88,
    this.maxHeightFactor,
  });

  // Show centered popup
  static void show(BuildContext context, {required Widget child}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) => BlurredPopup(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: screenWidth * widthFactor,
          constraints: BoxConstraints(
            maxWidth: 420, // Prevents it from getting too wide on tablets
            maxHeight: maxHeightFactor != null
                ? screenHeight * maxHeightFactor!
                : screenHeight * 0.75,
          ),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: child,
          ),
        ),
      ),
    );
  }
}
