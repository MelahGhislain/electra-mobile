import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/insights/insights.dart';
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
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final currentSpots = _toSpots(trend.current);
    final previousSpots = _toSpots(trend.previous);
    final maxX = currentSpots.isNotEmpty ? currentSpots.last.x : 30.0;
    final yInterval = (_maxY / 3).ceilToDouble();

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
          // ── Daily average ────────────────────────────────────────────
          Text(
            'Average per day',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            fmt.format(trend.dailyAverage),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.lightText,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          // ── Legend ──────────────────────────────────────────────────
          Row(
            children: [
              _LegendItem(
                color: const Color(0xFF7C3AED),
                label: 'This period',
                dashed: false,
              ),
              const SizedBox(width: 16),
              _LegendItem(
                color: AppColors.lightTextSecondary,
                label: 'Previous',
                dashed: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Chart ───────────────────────────────────────────────────
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: _maxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: yInterval,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.dividerLight, strokeWidth: 1),
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
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (v, _) {
                        if (trend.current.isEmpty) return const SizedBox();
                        // Show at start, ≈1/3, ≈2/3, end
                        final checkpoints = [
                          0.0,
                          (maxX / 3).roundToDouble(),
                          (maxX * 2 / 3).roundToDouble(),
                          maxX,
                        ];
                        if (!checkpoints.any((c) => (c - v).abs() < 0.5)) {
                          return const SizedBox();
                        }
                        final base = trend.current.first.date;
                        final date = base.add(Duration(days: v.toInt()));
                        return Text(
                          '${_monthAbbr(date.month)} ${date.day}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.lightTextSecondary,
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
                        '${_monthAbbr(date.month)} ${date.day}, ${date.year}\n${fmt.format(s.y)}',
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
                  // Current period — solid purple
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
                        color: const Color(0xFF7C3AED).withOpacity(0.08),
                      ),
                    ),
                  // Previous period — dashed grey
                  if (previousSpots.isNotEmpty)
                    LineChartBarData(
                      spots: previousSpots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: AppColors.lightTextSecondary.withOpacity(0.45),
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

  String _monthAbbr(int month) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return m[month - 1];
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
