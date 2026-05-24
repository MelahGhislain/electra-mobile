import 'package:minata/common/widgets/buttons/main_button.dart';
import 'package:minata/core/configs/fonts.dart';
import 'package:minata/core/configs/theme/app_colors.dart';
import 'package:minata/domain/entities/insights/insights.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// ── Loading ───────────────────────────────────────────────────────────────────

class InsightsLoadingState extends StatelessWidget {
  const InsightsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: CircularProgressIndicator(
        color: isDark ? AppColors.lightBackground : AppColors.darkBackground,
        strokeWidth: 2.5,
      ),
    );
  }
}

// ── Saving ───────────────────────────────────────────────────────────────────
class InsightsSavingsCard extends StatelessWidget {
  final SavingsOpportunity opportunity;

  const InsightsSavingsCard({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: Color(0xFF7C3AED),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.savingsOpportunity,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C3AED),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  opportunity.message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightText,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF7C3AED)),
                      foregroundColor: const Color(0xFF7C3AED),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      l.setBudget,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class InsightsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const InsightsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.somethingWentWrong,
              style: TextStyle(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                letterSpacing: -0.3,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 140,
              child: MainButton(
                text: l.tryAgain,
                onPressed: onRetry,
                width: double.infinity,
                size: ButtonSize.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
