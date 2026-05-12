import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:electra/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsSpendingOverview extends StatelessWidget {
  final List<CategoryBreakdown> categories;
  final double total;
  final String currency;

  const InsightsSpendingOverview({
    super.key,
    required this.categories,
    required this.total,
    required this.currency,
  });

  /// Use CategoryMeta color so donut matches the rest of the app.
  Color _colorFor(CategoryBreakdown cat) {
    return CategoryMeta.fromKey(cat.normalizedName).color;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final symbol = currency == 'USD' ? r'$' : currency;
    final fmt = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    final displayed = categories.take(3).toList();
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Donut ──────────────────────────────────────────────
              SizedBox(
                width: 152,
                height: 152,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    categories.isEmpty
                        ? PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: 1,
                                  color: theme.dividerColor,
                                  radius: 32,
                                  title: '',
                                ),
                              ],
                              centerSpaceRadius: 44,
                              sectionsSpace: 0,
                            ),
                          )
                        : PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 44,
                              sections: List.generate(categories.length, (i) {
                                final cat = categories[i];
                                return PieChartSectionData(
                                  value: cat.percent,
                                  color: _colorFor(cat),
                                  radius: 32,
                                  title: cat.percent >= 10
                                      ? '${cat.percent.toStringAsFixed(0)}%'
                                      : '',
                                  titleStyle: TextStyle(
                                    fontSize: AppFontSize.xs,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                );
                              }),
                            ),
                          ),
                    // Center label
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.total,
                          style: TextStyle(fontSize: AppFontSize.xs),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _compactAmount(total, symbol),
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ── Legend ─────────────────────────────────────────────
              Expanded(
                child: categories.isEmpty
                    ? Center(
                        child: Text(
                          l.noDataThisPeriod,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(displayed.length, (i) {
                          final cat = displayed[i];
                          final color = _colorFor(cat);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 11,
                                  height: 11,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    cat.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: AppFontSize.sm,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      fmt.format(cat.amount),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontSize: AppFontSize.xs,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      '${cat.percent.toStringAsFixed(0)}%',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(fontSize: AppFontSize.xs),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
              ),
            ],
          ),

          // ── View all categories link ────────────────────────────────
          const SizedBox(height: 8),
          Divider(height: 1, color: theme.dividerColor),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  l.viewAllCategories,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.primary,
                  size: AppFontSize.md,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _compactAmount(double value, String symbol) {
    if (value >= 1000) {
      final whole = value.truncate();
      final thousands = whole ~/ 1000;
      final remainder = (whole % 1000).toString().padLeft(3, '0');
      return '$symbol$thousands,$remainder';
    }
    return '$symbol${value.toStringAsFixed(0)}';
  }
}
