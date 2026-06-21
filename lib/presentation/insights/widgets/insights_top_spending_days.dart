import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/domain/entities/insights/insights.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsTopSpendingDays extends StatelessWidget {
  final List<TopSpendingDay> days;
  final String currency;

  const InsightsTopSpendingDays({
    super.key,
    required this.days,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final fmt = NumberFormat.currency(
      symbol: currency == 'USD' ? r'$' : currency,
      decimalDigits: 2,
    );

    if (days.isEmpty) return const SizedBox.shrink();

    // Sort by date for the chart (chronological), keep original for peak detection
    final sorted = [...days]..sort((a, b) => a.date.compareTo(b.date));
    final peak = days.reduce((a, b) => a.amount > b.amount ? a : b);
    final maxAmount = peak.amount;

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
          // ── Header ───────────────────────────────────────────────────
          Text(
            '${l.youSpentTheMostOn} ${peak.dayLabel}',
            style: TextStyle(
              fontSize: AppFontSize.xs,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                fmt.format(peak.amount),
                style: TextStyle(
                  fontSize: AppFontSize.xl,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.bolt_rounded,
                size: 16,
                color: theme.textTheme.bodySmall?.color,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Bar chart ─────────────────────────────────────────────────
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: sorted.map((day) {
                final isPeak = day.date == peak.date;
                final ratio = maxAmount > 0 ? day.amount / maxAmount : 0.0;
                final barHeight = (ratio * 64).clamp(8.0, 64.0);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: isPeak
                                ? const Color(0xFFDC2626)
                                : const Color(0xFFDDD6FE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _shortDay(day.date),
                          style: TextStyle(
                            fontSize: 9,
                            color: isPeak
                                ? const Color(0xFFDC2626)
                                : theme.textTheme.bodySmall?.color,
                            fontWeight: isPeak
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns a short day label like "May 1", "May 11" from "2026-05-01"
  String _shortDay(String isoDate) {
    try {
      final dt = DateTime.parse('${isoDate}T00:00:00Z');
      return '${_monthAbbr(dt.month)} ${dt.day}';
    } catch (_) {
      return isoDate;
    }
  }

  String _monthAbbr(int month) {
    const abbrs = [
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
    return month >= 1 && month <= 12 ? abbrs[month - 1] : '';
  }
}
