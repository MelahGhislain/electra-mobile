import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpendingDayHeader extends StatelessWidget {
  final DateTime date;
  final int count;
  final double total;

  const SpendingDayHeader({
    super.key,
    required this.date,
    required this.count,
    required this.total,
  });

  String _formatLabel(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    if (d == today) {
      final month = monthAbbr(date.month, locale);
      return '${l.today} • $month ${date.day}, ${date.year}';
    }
    if (d == yesterday) return l.yesterday;
    return '${monthAbbr(date.month, locale)} ${date.day}, ${date.year}';
  }

  String monthAbbr(int month, Locale locale) {
    final date = DateTime(2024, month, 1);
    return DateFormat.MMM(locale.toString()).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, right: 5, left: 5),
      child: Row(
        children: [
          Text(
            _formatLabel(context),
            style: const TextStyle(
              fontSize: AppFontSize.md,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
