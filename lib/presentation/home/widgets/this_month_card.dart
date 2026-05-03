import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/home/utils/home_summary.dart';
import 'package:electra/presentation/home/utils/home_utils.dart';
import 'package:flutter/material.dart';

class ThisMonthCard extends StatelessWidget {
  final HomeSummary summary;

  const ThisMonthCard({super.key, required this.summary});

  bool get _hasBudget => summary.hasBudget;

  bool get _isOver => summary.progress >= 1.0;
  bool get _isWarning => summary.progress >= 0.85 && !_isOver;

  Color get _barColor {
    if (_isOver) return const Color(0xFFEF4444);
    if (_isWarning) return const Color(0xFFF59E0B);
    return const Color(0xFF22C55E);
  }

  Color get _badgeBg {
    if (_isOver) return const Color(0xFFFFD9D9);
    if (_isWarning) return const Color(0xFFFCEEB6);
    return const Color(0xFFCBFCDC);
  }

  String get _badge {
    if (_isOver) return 'Over budget';
    if (_isWarning) return 'Heads up';
    return 'On track';
  }

  @override
  Widget build(BuildContext context) {
    // Show with hardcoded budget=100 if not set (user asked to hardcode 100)
    final effectiveBudget = _hasBudget ? summary.budget : 100.0;
    final effectiveProgress = _hasBudget
        ? summary.progress
        : (summary.spentThisMonth / 100.0).clamp(0.0, 1.0);

    final extras = MonthExtras.compute(
      budget: effectiveBudget,
      spentThisMonth: summary.spentThisMonth,
    );

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
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ───────────────────────────────────────────────
            Row(
              children: [
                const Text(
                  'This Month',
                  style: TextStyle(
                    fontSize: AppFontSize.lg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _badgeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _badge,
                    style: TextStyle(
                      fontSize: AppFontSize.xs,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightText,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.more_horiz_rounded,
                  color: Theme.of(context).iconTheme.color,
                  size: 22,
                ),
              ],
            ),

            const SizedBox(height: 4),

            // ── Amount ────────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$${summary.spentThisMonth.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: AppFontSize.xxxl,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  ' / \$${effectiveBudget.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: AppFontSize.xl,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // ── Progress bar + % ──────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: effectiveProgress,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFF3F4F6),
                      valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(effectiveProgress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── 3 stat chips ──────────────────────────────────────────────
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _StatChip(
                        iconBg: const Color(0xFFDCFCE7),
                        icon: Icons.trending_up_rounded,
                        iconColor: AppColors.primary,
                        label: 'Avg. daily spend',
                        value: '\$${summary.avgDaily.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  VerticalDivider(width: 1, thickness: 1),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _StatChip(
                        iconBg: const Color(0xFFDEEBFF),
                        icon: Icons.calendar_today_rounded,
                        iconColor: AppColors.accent,
                        label: 'Days left',
                        value: '${extras.daysLeft}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatChip({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
          child: Icon(icon, size: 15),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: AppFontSize.sm)),
            Text(
              value,
              style: TextStyle(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
