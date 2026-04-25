import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SpendingDetailSectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const SpendingDetailSectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.lightText,
              letterSpacing: -0.2,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                trailing!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
