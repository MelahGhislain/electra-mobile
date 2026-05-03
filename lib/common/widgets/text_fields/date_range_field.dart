import 'package:electra/core/configs/fonts.dart';
import 'package:flutter/material.dart';

class DateRangeField extends StatelessWidget {
  final String? label;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String hint;

  const DateRangeField({
    super.key,
    this.label,
    this.dateFrom,
    this.dateTo,
    required this.onTap,
    this.onClear,
    this.hint = 'Select date range',
  });

  bool get _hasRange => dateFrom != null && dateTo != null;

  String _fmt(DateTime d) {
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Optional label ─────────────────────────────────────────────
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: const TextStyle(
              fontSize: AppFontSize.sm,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
        ],

        // ── Field ──────────────────────────────────────────────────────
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.onSurface : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range_rounded,
                  size: 18,
                  color: theme.iconTheme.color,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _hasRange
                        ? '${_fmt(dateFrom!)}  →  ${_fmt(dateTo!)}'
                        : hint,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _hasRange ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
                if (_hasRange && onClear != null)
                  GestureDetector(
                    onTap: onClear,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
