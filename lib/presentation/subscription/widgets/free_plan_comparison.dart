import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FreePlanComparison extends StatelessWidget {
  const FreePlanComparison({super.key});

  static const _rows = [
    _ComparisonRow('Purchases per month', '30 max', 'Unlimited'),
    _ComparisonRow('Receipt scanning', null, '✓ AI-powered'),
    _ComparisonRow('Voice input', null, '✓ Hands-free'),
    _ComparisonRow('Spending insights', 'Basic', 'Full AI insights'),
    _ComparisonRow('Budget alerts', null, '✓ + Forecasting'),
    _ComparisonRow('Support', 'Standard', 'Priority'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedBg = isDark ? AppColors.darkSurfaceAlt : AppColors.lightBorder;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          // ── Column headers ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            decoration: BoxDecoration(
              color: mutedBg.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Features',
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Free',
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Premium',
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: theme.dividerColor),

          // ── Rows ───────────────────────────────────────────────────
          ..._rows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            final isLast = i == _rows.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Feature name
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.feature,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: AppFontSize.sm,
                          ),
                        ),
                      ),

                      // Free value
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: row.freeValue != null
                              ? Text(
                                  row.freeValue!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: AppFontSize.xs,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withValues(alpha: 0.7),
                                ),
                        ),
                      ),

                      // Premium value
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            row.premiumValue,
                            style: TextStyle(
                              fontSize: AppFontSize.xs,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (!isLast)
                  Divider(
                    height: 1,
                    color: theme.dividerColor,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            );
          }),

          // ── Footer nudge ───────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Upgrade to unlock everything above',
                  style: TextStyle(
                    fontSize: AppFontSize.xs,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
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

class _ComparisonRow {
  final String feature;
  final String? freeValue; // null = show ✗ icon
  final String premiumValue;

  const _ComparisonRow(this.feature, this.freeValue, this.premiumValue);
}
