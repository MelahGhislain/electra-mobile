import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class InsightsHeader extends StatelessWidget {
  final String period;
  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<String> onPeriodChanged;

  const InsightsHeader({
    super.key,
    required this.period,
    required this.label,
    required this.onPrevious,
    required this.onNext,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Period dropdown
          _PeriodDropdown(selected: period, onChanged: onPeriodChanged),

          const Spacer(),

          // Previous arrow
          _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),

          const SizedBox(width: 8),

          // Current period label
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.lightText,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(width: 8),

          // Next arrow
          _NavButton(icon: Icons.chevron_right_rounded, onTap: onNext),

          const SizedBox(width: 8),

          // Calendar icon
          _NavButton(icon: Icons.calendar_today_outlined, onTap: () {}),
        ],
      ),
    );
  }
}

class _PeriodDropdown extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PeriodDropdown({required this.selected, required this.onChanged});

  String get _label {
    switch (selected) {
      case 'weekly':
        return 'Weekly';
      case 'yearly':
        return 'Yearly';
      default:
        return 'Monthly';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.lightText,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.lightText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.only(bottom: 24),
        decoration: const BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            for (final p in ['weekly', 'monthly', 'yearly'])
              ListTile(
                title: Text(
                  p[0].toUpperCase() + p.substring(1),
                  style: TextStyle(
                    fontWeight: p == selected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: p == selected
                        ? const Color(0xFF7C3AED)
                        : AppColors.lightText,
                  ),
                ),
                trailing: p == selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF7C3AED),
                        size: 18,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onChanged(p);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Icon(icon, size: 18, color: AppColors.lightText),
      ),
    );
  }
}
