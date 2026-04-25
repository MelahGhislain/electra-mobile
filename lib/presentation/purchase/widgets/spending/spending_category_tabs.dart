import 'package:flutter/material.dart';
import 'package:electra/core/configs/theme/app_colors.dart';

class _TabItem {
  final String label;
  final IconData icon;
  final String? categoryKey; // null = "All"

  const _TabItem({required this.label, required this.icon, this.categoryKey});
}

/// Horizontal scrollable category tab bar shown below the search field.
class SpendingCategoryTabs extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  static const _tabs = [
    _TabItem(label: 'All', icon: Icons.grid_view_rounded),
    _TabItem(
      label: 'Food',
      icon: Icons.restaurant_rounded,
      categoryKey: 'Food',
    ),
    _TabItem(
      label: 'Transport',
      icon: Icons.directions_car_rounded,
      categoryKey: 'Transport',
    ),
    _TabItem(
      label: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      categoryKey: 'Shopping',
    ),
    _TabItem(
      label: 'Health',
      icon: Icons.favorite_rounded,
      categoryKey: 'Health',
    ),
    _TabItem(
      label: 'Groceries',
      icon: Icons.shopping_basket_rounded,
      categoryKey: 'Groceries',
    ),
    _TabItem(
      label: 'Drinks',
      icon: Icons.local_drink_rounded,
      categoryKey: 'Drinks',
    ),
  ];

  const SpendingCategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final tab = _tabs[i];
          final isSelected = tab.categoryKey == selectedCategory;
          return _CategoryTab(
            tab: tab,
            isSelected: isSelected,
            onTap: () => onCategoryChanged(tab.categoryKey),
          );
        },
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final _TabItem tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.dividerLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tab.icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
