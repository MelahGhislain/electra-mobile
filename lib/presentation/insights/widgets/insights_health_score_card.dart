import 'dart:math';
import 'package:minata/core/configs/fonts.dart';
import 'package:minata/domain/entities/insights/insights.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class InsightsHealthScoreCard extends StatelessWidget {
  final AiEnrichment aiEnrichment;
  final SpendingInsights insights;

  const InsightsHealthScoreCard({
    super.key,
    required this.aiEnrichment,
    required this.insights,
  });

  Color _scoreColor(int score) {
    if (score >= 80) return const Color(0xFF16A34A);
    if (score >= 60) return const Color(0xFF2563EB);
    if (score >= 40) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  void _openFullReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FullReportSheet(
        aiEnrichment: aiEnrichment,
        insights: insights,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = aiEnrichment.healthScore;
    final color = _scoreColor(score.score);
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Donut score ──────────────────────────────────────────────
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(80, 80),
                  painter: _ScoreArcPainter(
                    score: score.score,
                    color: color,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${score.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      score.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ── Right side ───────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.financialHealthScore,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Highlights
                ...score.highlights.take(2).map(
                      (h) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF16A34A),
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                h,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 8),
                // View full report button
                GestureDetector(
                  onTap: () => _openFullReport(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.viewFullReport,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
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

// ── Arc painter ───────────────────────────────────────────────────────────────

class _ScoreArcPainter extends CustomPainter {
  final int score;
  final Color color;

  const _ScoreArcPainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 7.0;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF374151)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Score arc
    final sweepAngle = (score / 100) * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ScoreArcPainter old) =>
      old.score != score || old.color != color;
}

// ── Full report bottom sheet ──────────────────────────────────────────────────

class _FullReportSheet extends StatelessWidget {
  final AiEnrichment aiEnrichment;
  final SpendingInsights insights;

  const _FullReportSheet({
    required this.aiEnrichment,
    required this.insights,
  });

  Color _scoreColor(int score) {
    if (score >= 80) return const Color(0xFF16A34A);
    if (score >= 60) return const Color(0xFF2563EB);
    if (score >= 40) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = aiEnrichment.healthScore;
    final color = _scoreColor(score.score);
    final l = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l.financialHealthReport,
                      style: TextStyle(
                        fontSize: AppFontSize.lg,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: AppFontSize.md,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 24, color: theme.dividerColor),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // ── Score section ─────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 72,
                            height: 72,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(72, 72),
                                  painter: _ScoreArcPainter(
                                    score: score.score,
                                    color: color,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${score.score}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      score.label,
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: score.highlights
                                  .map(
                                    (h) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: Color(0xFF16A34A),
                                            size: 14,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              h,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Period summary ────────────────────────────────
                    Text(
                      l.periodSummary,
                      style: TextStyle(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: l.totalSpent,
                      value:
                          '${insights.totals.currency} ${insights.totals.amount.toStringAsFixed(2)}',
                    ),
                    _SummaryRow(
                      label: l.vsLastPeriod,
                      value:
                          '${insights.totals.deltaPercent.abs().toStringAsFixed(1)}% ${insights.totals.trend == TrendDirection.down ? '↓' : '↑'}',
                      valueColor: insights.totals.trend == TrendDirection.down
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFDC2626),
                    ),
                    _SummaryRow(
                      label: l.dailyAverage,
                      value:
                          '${insights.totals.currency} ${insights.trend.dailyAverage.toStringAsFixed(2)}',
                    ),
                    if (insights.budget != null) ...[
                      _SummaryRow(
                        label: l.budget,
                        value:
                            '${insights.budget!.currency} ${insights.budget!.monthlyBudget.toStringAsFixed(2)}',
                      ),
                      _SummaryRow(
                        label: l.budgetStatus,
                        value: insights.budget!.isOnTrack
                            ? l.onTrack
                            : l.overBudget,
                        valueColor: insights.budget!.isOnTrack
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // ── Top category ──────────────────────────────────
                    if (insights.categoryBreakdown.isNotEmpty) ...[
                      Text(
                        l.topSpendingCategories,
                        style: TextStyle(
                          fontSize: AppFontSize.md,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...insights.categoryBreakdown.take(3).map(
                            (c) => _SummaryRow(
                              label: c.name,
                              value:
                                  '${c.currency} ${c.amount.toStringAsFixed(2)} (${c.percent.toStringAsFixed(0)}%)',
                            ),
                          ),
                      const SizedBox(height: 24),
                    ],

                    // ── AI generated at ───────────────────────────────
                    Text(
                      '${l.generatedAt}: ${_formatDate(aiEnrichment.generatedAt)}',
                      style: TextStyle(
                        fontSize: AppFontSize.xs,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
