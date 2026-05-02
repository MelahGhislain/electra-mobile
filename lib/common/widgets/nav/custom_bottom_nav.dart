import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAddTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onAddTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 30,
      blur: 20,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lightSurface, AppColors.lightSurface],
      ),
      borderGradient: const LinearGradient(
        colors: [Colors.white24, Colors.transparent],
      ),
      border: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              isSelected: selectedIndex == 0,
              label: 'Home',
              onTap: () => onDestinationSelected(0),
            ),
            _NavItem(
              icon: Icons.receipt_long_outlined,
              isSelected: selectedIndex == 1,
              label: 'Spending',
              onTap: () => onDestinationSelected(1),
            ),

            // Center Camera Button
            GestureDetector(
              onTap: onAddTapped,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkBackground,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBackground.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.darkText,
                  size: 28,
                ),
              ),
            ),

            _NavItem(
              icon: Icons.insert_chart_outlined,
              isSelected: selectedIndex == 2,
              label: 'Insights',
              onTap: () => onDestinationSelected(2),
            ),
            _NavItem(
              icon: Icons.person_outline_rounded,
              isSelected: selectedIndex == 3,
              label: 'Profile',
              onTap: () => onDestinationSelected(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected
                ? AppColors.primary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.lightTextSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
