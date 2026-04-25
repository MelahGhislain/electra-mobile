import 'package:flutter/material.dart';
import 'package:electra/core/configs/theme/app_colors.dart';

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

  String _formatLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) {
      final month = _monthAbbr(date.month);
      return 'Today • $month ${date.day}, ${date.year}';
    }
    if (d == yesterday) return 'Yesterday';
    return '${_monthAbbr(date.month)} ${date.day}, ${date.year}';
  }

  String _monthAbbr(int m) {
    const months = [
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
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, right: 5, left: 5),
      child: Row(
        children: [
          Text(
            _formatLabel(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.lightText,
            ),
          ),
          // const Spacer(),
        ],
      ),
    );
  }
}
