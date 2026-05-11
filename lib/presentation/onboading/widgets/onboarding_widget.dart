import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/data/models/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final OnboardingData data;
  final int currentPage;
  final int totalPages;

  const OnboardingWidget({
    super.key,
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Background fill (shown around the image) ───────────────────
        Container(color: isDark ? Colors.black : Colors.white),

        // ── Background image (natural proportions, no stretch) ─────────
        Positioned.fill(
          top: data.topPosition, // adjust this value to move the image up
          child: Image.asset(
            data.image,
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stack) => Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(Icons.image, size: 100, color: Colors.white38),
              ),
            ),
          ),
        ),

        // ── Subtle top-to-bottom overlay for text readability ──────────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.01),
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.07),
                Colors.black.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),

        // ── Page indicator dots ────────────────────────────────────────
        Positioned(
          top: 80,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? isDark
                            ? AppColors.lightSurface
                            : AppColors.darkSurface
                      : Colors.white38,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
