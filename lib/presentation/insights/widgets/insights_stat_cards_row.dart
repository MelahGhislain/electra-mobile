import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/domain/entities/insights/insights.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The row of 4 quick-stat cards shown below the health score for premium users.
/// Matches the design: Spending trend | Top category | Daily average | Potential savings
class InsightsStatCardsRow extends StatelessWidget {
  final SpendingInsights insights;

  const InsightsStatCardsRow({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fmt = NumberFormat.currency(
      symbol: insights.totals.currency == 'USD'
          ? r'$'
          : insights.totals.currency,
      decimalDigits: 2,
    );
    final absPct = insights.totals.deltaPercent.abs().toStringAsFixed(1);
    final isDown = insights.totals.trend == TrendDirection.down;

    final topCategory = insights.categoryBreakdown.isNotEmpty
        ? insights.categoryBreakdown.first
        : null;

    final potentialSavings =
        insights.savingsOpportunity?.projectedAnnualSavings;

    return SizedBox(
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // 1. Spending trend
          _StatCard(
            icon: Icons.show_chart_rounded,
            iconColor: const Color(0xFF7C3AED),
            iconBg: const Color(0xFFEDE9FE),
            topLabel: l.spendingTrend,
            mainValue: '$absPct%',
            mainColor: isDown
                ? const Color(0xFF16A34A)
                : const Color(0xFFDC2626),
            mainIcon: isDown
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            subLabel: l.vsPreviousPeriod,
          ),

          const SizedBox(width: 10),

          // 2. Top category
          _StatCard(
            icon: Icons.category_rounded,
            iconColor: const Color(0xFFD97706),
            iconBg: const Color(0xFFFEF3C7),
            topLabel: topCategory != null
                ? '${l.topCategory}\n${topCategory.name}'
                : l.topCategory,
            mainValue: topCategory != null
                ? '${topCategory.percent.toStringAsFixed(0)}%'
                : '--',
            subLabel: l.ofTotalSpend,
          ),

          const SizedBox(width: 10),

          // 3. Daily average
          _StatCard(
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF0284C7),
            iconBg: const Color(0xFFE0F2FE),
            topLabel: l.dailyAverage,
            mainValue: fmt.format(insights.trend.dailyAverage),
            subLabel: l.perDay,
          ),

          const SizedBox(width: 10),

          // 4. Potential savings
          _StatCard(
            icon: Icons.savings_rounded,
            iconColor: const Color(0xFF16A34A),
            iconBg: const Color(0xFFDCFCE7),
            topLabel: l.potentialSavings,
            mainValue: potentialSavings != null
                ? fmt.format(potentialSavings)
                : '--',
            subLabel: potentialSavings != null ? l.perYear : l.noOpportunity,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String topLabel;
  final String mainValue;
  final Color? mainColor;
  final IconData? mainIcon;
  final String subLabel;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.topLabel,
    required this.mainValue,
    this.mainColor,
    this.mainIcon,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueColor = mainColor ?? theme.textTheme.bodyLarge?.color;

    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon + label
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  topLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.textTheme.bodySmall?.color,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Main value
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (mainIcon != null) ...[
                Icon(mainIcon, size: 13, color: valueColor),
                const SizedBox(width: 2),
              ],
              Flexible(
                child: Text(
                  mainValue,
                  style: TextStyle(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Sub label
          Text(
            subLabel,
            style: TextStyle(
              fontSize: 10,
              color: theme.textTheme.bodySmall?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
