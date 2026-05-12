import 'package:electra/core/configs/fonts.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:electra/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsTrendSection extends StatelessWidget {
  final SpendingTrend trend;
  const InsightsTrendSection({super.key, required this.trend});

  List<FlSpot> _toSpots(List<TrendPoint> points) {
    if (points.isEmpty) return [];
    final base = points.first.date;
    return points
        .map((p) => FlSpot(p.date.difference(base).inDays.toDouble(), p.amount))
        .toList();
  }

  double get _maxY {
    final all = [
      ...trend.current.map((p) => p.amount),
      ...trend.previous.map((p) => p.amount),
    ];
    if (all.isEmpty) return 700;
    return (all.reduce((a, b) => a > b ? a : b) * 1.25).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final currentSpots = _toSpots(trend.current);
    final previousSpots = _toSpots(trend.previous);
    final maxX = currentSpots.isNotEmpty ? currentSpots.last.x : 30.0;
    final yInterval = (_maxY / 3).ceilToDouble();
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Daily average ────────────────────────────────────────────
                  Text(
                    l.averagePerDay,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: AppFontSize.xs,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fmt.format(trend.dailyAverage),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: AppFontSize.xl,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ── Legend ───────────────────────────────────────────────────
              Row(
                children: [
                  _LegendItem(
                    color: const Color(0xFF7C3AED),
                    label: l.thisPeriod,
                    dashed: false,
                  ),
                  const SizedBox(width: 16),
                  _LegendItem(
                    color: theme.textTheme.bodySmall?.color ?? Colors.grey,
                    label: l.previous,
                    dashed: true,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ── Chart ────────────────────────────────────────────────────
          SizedBox(
            height: 160,
            child: currentSpots.isEmpty && previousSpots.isEmpty
                ? Center(
                    child: Text(
                      l.noTrendDataAvailable,
                      style: theme.textTheme.bodySmall,
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: _maxY,
                      clipData: const FlClipData.all(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: yInterval,
                        getDrawingHorizontalLine: (_) =>
                            FlLine(color: theme.dividerColor, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 44,
                            interval: yInterval,
                            getTitlesWidget: (v, _) => Text(
                              v == 0 ? '\$0' : '\$${v.toInt()}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (v, _) {
                              if (trend.current.isEmpty) {
                                return const SizedBox();
                              }
                              final checkpoints = [
                                0.0,
                                (maxX / 3).roundToDouble(),
                                (maxX * 2 / 3).roundToDouble(),
                                maxX,
                              ];
                              if (!checkpoints.any(
                                (c) => (c - v).abs() < 0.5,
                              )) {
                                return const SizedBox();
                              }
                              final base = trend.current.first.date;
                              final date = base.add(Duration(days: v.toInt()));
                              return Text(
                                '${_monthAbbr(context, date.month)} ${date.day}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => const Color(0xFF1E1B4B),
                          getTooltipItems: (spots) => spots.map((s) {
                            if (s.barIndex != 0) return null;
                            if (trend.current.isEmpty) return null;
                            final base = trend.current.first.date;
                            final date = base.add(Duration(days: s.x.toInt()));
                            return LineTooltipItem(
                              '${_monthAbbr(context, date.month)} ${date.day}, ${date.year}\n${fmt.format(s.y)}',
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      lineBarsData: [
                        if (currentSpots.isNotEmpty)
                          LineChartBarData(
                            spots: currentSpots,
                            isCurved: true,
                            curveSmoothness: 0.3,
                            color: const Color(0xFF7C3AED),
                            barWidth: 2.5,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(
                                0xFF7C3AED,
                              ).withValues(alpha: 0.08),
                            ),
                          ),
                        if (previousSpots.isNotEmpty)
                          LineChartBarData(
                            spots: previousSpots,
                            isCurved: true,
                            curveSmoothness: 0.3,
                            color:
                                (theme.textTheme.bodySmall?.color ??
                                        Colors.grey)
                                    .withValues(alpha: 0.45),
                            barWidth: 1.5,
                            dashArray: [4, 4],
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _monthAbbr(BuildContext context, int month) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    return DateFormat.MMM(locale).format(DateTime(2026, month));
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.dashed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 2,
          child: dashed
              ? Row(
                  children: [
                    Container(width: 7, height: 2, color: color),
                    const SizedBox(width: 3),
                    Container(width: 7, height: 2, color: color),
                  ],
                )
              : Container(color: color),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
