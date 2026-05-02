// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY SELECT FIELD
// ─────────────────────────────────────────────────────────────────────────────

import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:flutter/material.dart';

class CategorySelectField extends StatelessWidget {
  final CategoryMeta selected;
  final VoidCallback onTap;

  const CategorySelectField({
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: selected.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(selected.icon, size: 16, color: selected.color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selected.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightText,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
