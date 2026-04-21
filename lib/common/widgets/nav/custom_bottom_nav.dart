import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
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
        colors: [
          AppColors.secondaryDark.withAlpha(64),
          AppColors.secondaryDark.withAlpha(64),
        ],
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
              onTap: () => onDestinationSelected(0),
            ),
            _NavItem(
              icon: Icons.insert_chart_outlined,
              isSelected: selectedIndex == 1,
              onTap: () => onDestinationSelected(1),
            ),

            // Center Camera Button
            GestureDetector(
              onTap: () => context.pushNamed(RouteNames.expenseRecorder),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    // colors: [Color(0xFF22D3EE), Color(0xFF06B6D4)],
                    colors: [
                      AppColors.primary.withValues(alpha: 0.6),
                      AppColors.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      // color: const Color(0xFF22D3EE).withValues(alpha: 0.6),
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.center_focus_weak,
                  color: AppColors.darkText,
                  size: 32,
                ),
              ),
            ),

            _NavItem(
              icon: Icons.receipt_long_outlined,
              isSelected: selectedIndex == 2,
              onTap: () => onDestinationSelected(2),
            ),
            _NavItem(
              icon: Icons.person_outline_rounded,
              isSelected: selectedIndex == 3,
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
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? AppColors.primary : Colors.white60,
      ),
    );
  }
}
