import 'package:minata/core/configs/fonts.dart';
import 'package:minata/core/configs/theme/app_colors.dart';
import 'package:minata/l10n/app_localizations.dart';
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _PeriodDropdown(
            selected: period,
            onChanged: onPeriodChanged,
            theme: theme,
          ),
          const Spacer(),
          _NavButton(
            icon: Icons.chevron_left_rounded,
            onTap: onPrevious,
            theme: theme,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppFontSize.sm,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 8),
          _NavButton(
            icon: Icons.chevron_right_rounded,
            onTap: onNext,
            theme: theme,
          ),
          // const SizedBox(width: 8),
          // _NavButton(
          //   icon: Icons.calendar_today_outlined,
          //   onTap: () {},
          //   theme: theme,
          // ),
        ],
      ),
    );
  }
}

class _PeriodDropdown extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final ThemeData theme;

  const _PeriodDropdown({
    required this.selected,
    required this.onChanged,
    required this.theme,
  });

  String _labelFor(String p, AppLocalizations l) {
    switch (p) {
      case 'weekly':
        return l.weekly;
      case 'yearly':
        return l.yearly;
      default:
        return l.monthly;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return PopupMenuButton<String>(
      initialValue: selected,
      onSelected: onChanged,
      color: theme.cardTheme.color,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.dividerColor),
      ),
      offset: const Offset(0, 40),
      itemBuilder: (_) => ['weekly', 'monthly', 'yearly']
          .map(
            (p) => PopupMenuItem<String>(
              value: p,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _labelFor(p, l),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: p == selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: p == selected
                            ? AppColors.darkBackground
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _labelFor(selected, l),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppFontSize.sm,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.iconTheme.color,
              size: AppFontSize.md,
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
  final ThemeData theme;

  const _NavButton({
    required this.icon,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Icon(icon, size: AppFontSize.lg, color: theme.iconTheme.color),
      ),
    );
  }
}
