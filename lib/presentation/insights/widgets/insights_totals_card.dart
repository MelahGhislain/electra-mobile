import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/insights/insights.dart';
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
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final isDown = totals.trend == TrendDirection.down;
    final deltaColor = isDown
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
    final arrowIcon = isDown
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
    final absPct = totals.deltaPercent.abs().toStringAsFixed(1);
    final absDelta = fmt.format(totals.previousAmount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: title + budget badge ──────────────────────────────
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
                          'Total spent in $periodLabel',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 14,
                          color: AppColors.lightTextSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fmt.format(totals.amount),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(arrowIcon, size: 14, color: deltaColor),
                        const SizedBox(width: 2),
                        Text(
                          '$absPct% ${isDown ? 'less' : 'more'} than previous ($absDelta)',
                          style: TextStyle(
                            fontSize: 12,
                            color: deltaColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Budget status badge
              if (budget != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: budget!.isOnTrack
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Budget status',
                        style: TextStyle(
                          fontSize: 11,
                          color: budget!.isOnTrack
                              ? const Color(0xFF15803D)
                              : const Color(0xFFB91C1C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            budget!.isOnTrack ? 'On track' : 'Over budget',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: budget!.isOnTrack
                                  ? const Color(0xFF15803D)
                                  : const Color(0xFFB91C1C),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            budget!.isOnTrack
                                ? Icons.check_circle_rounded
                                : Icons.warning_rounded,
                            size: 14,
                            color: budget!.isOnTrack
                                ? const Color(0xFF15803D)
                                : const Color(0xFFB91C1C),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (budget != null) ...[
            const SizedBox(height: 16),

            // ── Budget progress bar ────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: budget!.progressPercent / 100,
                backgroundColor: const Color(0xFFE9D5FF),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${budget!.progressPercent.toStringAsFixed(2)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C3AED),
                  ),
                ),
                Text(
                  'of ${fmt.format(budget!.monthlyBudget)} budget',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
