// FILE: presentation/insights/widgets/summary/insights_totals_card.dart

import 'package:minata/core/configs/fonts.dart';
import 'package:minata/core/configs/theme/app_colors.dart';
import 'package:minata/domain/entities/insights/insights.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsTotalsCard extends StatelessWidget {
  final SpendingTotals totals;
  final BudgetStatus? budget;
  final String periodLabel;

  const InsightsTotalsCard({
    super.key,
    required this.totals,
    this.budget,
    required this.periodLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final isDown = totals.trend == TrendDirection.down;
    final isNeutral = totals.trend == TrendDirection.neutral;
    final deltaColor = isDown
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    final arrowIcon = isDown
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
    final absPct = totals.deltaPercent.abs().toStringAsFixed(1);
    final prevFmt = fmt.format(totals.previousAmount);

    final shortLabel = periodLabel.split(' ').first;
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top row ──────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l.totalSpentIn(shortLabel),
                          style: const TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: AppFontSize.sm,
                          color: theme.iconTheme.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fmt.format(totals.amount),
                      style: const TextStyle(
                        fontSize: AppFontSize.xxl,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!isNeutral)
                      Row(
                        children: [
                          Icon(arrowIcon, size: 14, color: deltaColor),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              isDown
                                  ? l.lessThanPrevious(absPct, prevFmt)
                                  : l.moreThanPrevious(absPct, prevFmt),
                              style: TextStyle(
                                fontSize: AppFontSize.xs,
                                color: deltaColor,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Budget badge
              if (budget != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: budget!.isOnTrack
                        ? theme.colorScheme.primary.withValues(alpha: 0.07)
                        : theme.colorScheme.error.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.budgetStatus,
                        style: TextStyle(
                          fontSize: AppFontSize.xs,
                          color: budget!.isOnTrack
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            budget!.isOnTrack ? l.onTrack : l.overBudget,
                            style: TextStyle(
                              fontSize: AppFontSize.sm,
                              fontWeight: FontWeight.w500,
                              color: budget!.isOnTrack
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            budget!.isOnTrack
                                ? Icons.check_circle_rounded
                                : Icons.warning_rounded,
                            size: AppFontSize.lg,
                            color: budget!.isOnTrack
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // ── Budget progress bar ───────────────────────────────────────
          if (budget != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 26,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (budget!.progressPercent / 100).clamp(0.0, 1.0),
                      backgroundColor: AppColors.accentSoft,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.accent,
                      ),
                      minHeight: 26,
                    ),
                  ),

                  // Labels overlaid on top of the bar
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${budget!.progressPercent.toStringAsFixed(2)}%',
                            style: const TextStyle(
                              fontSize: AppFontSize.xs,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBackground,
                            ),
                          ),
                          Text(
                            l.ofBudget(fmt.format(budget!.monthlyBudget)),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: AppFontSize.xs,
                              color: AppColors.darkBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
