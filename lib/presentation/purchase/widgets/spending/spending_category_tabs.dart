import 'package:qleo/core/utils/category_meta.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SpendingCategoryTabs extends StatelessWidget {
  final String? selectedCategory;
  final List<String> availableCategories;
  final ValueChanged<String?> onCategoryChanged;

  const SpendingCategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.availableCategories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Build tab list: "All" first, then one tab per available category
    final tabs = [
      _Tab(
        label: l.all,
        icon: Icons.grid_view_rounded,
        key: null,
        color: theme.colorScheme.secondary,
      ),
      ...availableCategories.map((key) {
        final meta = CategoryMeta.fromKey(key);
        return _Tab(
          label: meta.localizedLabel(l),
          icon: meta.icon,
          key: key,
          color: meta.color,
        );
      }),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final tab = tabs[i];
          final isSelected = tab.key == selectedCategory;
          final activeColor = tab.color ?? theme.colorScheme.onSurface;

          return GestureDetector(
            onTap: () => onCategoryChanged(tab.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: isDark ? 0.25 : 0.12)
                    : theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? activeColor : theme.dividerColor,
                  width: isSelected ? 1 : 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab.icon,
                    size: 14,
                    color: isSelected
                        ? activeColor
                        : theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? activeColor
                          : theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Tab {
  final String label;
  final IconData icon;
  final String? key; // null = "All"
  final Color? color; // null = use theme onSurface for "All" tab

  const _Tab({
    required this.label,
    required this.icon,
    required this.key,
    required this.color,
  });
}
