import 'dart:math' as math;
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/presentation/home/utils/home_utils.dart';
import 'package:flutter/material.dart';

class TodaySpendingCard extends StatelessWidget {
  final TodaySummary todaySummary;

  /// Pass the monthly budget. If null or 0 we hardcode 100 as daily budget base.
  final double? monthlyBudget;

  const TodaySpendingCard({
    super.key,
    required this.todaySummary,
    this.monthlyBudget,
  });

  // ── Daily budget helpers ────────────────────────────────────────────────
  double get _dailyBudget {
    final monthly = (monthlyBudget != null && monthlyBudget! > 0)
        ? monthlyBudget!
        : 100.0; // hardcoded fallback
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return monthly / daysInMonth;
  }

  double get _progress =>
      (_dailyBudget > 0 ? todaySummary.todayTotal / _dailyBudget : 0.0).clamp(
        0.0,
        1.0,
      );

  int get _progressPct => (_progress * 100).toInt();

  Color get _accentColor {
    if (_progress >= 1.0) return const Color(0xFFEF4444);
    if (_progress >= 0.85) return const Color(0xFFF59E0B);
    return const Color(0xFF22C55E);
  }

  @override
  Widget build(BuildContext context) {
    final pct = todaySummary.percentVsYesterday;
    final accentColor = _accentColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row: title + donut ──────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        "Today's Spending",
                        style: TextStyle(
                          fontSize: AppFontSize.lg,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Big dollar amount
                      Text(
                        '\$${todaySummary.todayTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: AppFontSize.xxxxl,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1.5,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // % vs yesterday
                      if (pct != null)
                        Row(
                          children: [
                            Icon(
                              pct <= 0
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              size: 15,
                              color: pct <= 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${pct.abs().toStringAsFixed(0)}% vs yesterday',
                              style: TextStyle(
                                fontSize: AppFontSize.sm,
                                fontWeight: FontWeight.w600,
                                color: pct <= 0
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          todaySummary.hasTodayPurchases
                              ? 'No data for yesterday'
                              : 'Most recent purchase',
                          style: const TextStyle(fontSize: AppFontSize.sm),
                        ),
                    ],
                  ),
                ),

                // Right: donut ring
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(100, 100),
                        painter: _RingPainter(
                          progress: _progress,
                          color: accentColor,
                          strokeWidth: 6,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_progressPct%',
                            style: TextStyle(
                              fontSize: AppFontSize.sm,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Text(
                            'of daily\nbudget',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppFontSize.xs,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Daily budget row + progress bar ─────────────────────────
            const SizedBox(height: 1),

            const Divider(),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Daily budget label + amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily budget',
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '\$${todaySummary.todayTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                        Text(
                          ' / \$${_dailyBudget.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 84),

                // Right: progress bar fills remaining space
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFF3F4F6),
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = const Color(0xFFF3F4F6),
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
