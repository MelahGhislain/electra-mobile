import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'feature_row.dart';

class FreePlanComparison extends StatelessWidget {
  const FreePlanComparison({super.key});

  static const _features = [
    'Manual expense tracking',
    'Up to 30 purchases/month',
    'Basic categories & summary',
    'Standard support',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceAlt
                      : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lock_open_rounded,
                  size: AppFontSize.md,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Free Plan',
                style: TextStyle(
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceAlt
                      : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Current plan',
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._features.map(
            (f) => FeatureRow(
              text: f,
              checkColor: !isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
            ),
          ),
        ],
      ),
    );
  }
}
