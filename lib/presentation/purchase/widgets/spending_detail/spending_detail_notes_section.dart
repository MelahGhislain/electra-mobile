import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SpendingDetailNotesSection extends StatelessWidget {
  final String? notes;
  final VoidCallback? onEdit;

  const SpendingDetailNotesSection({super.key, this.notes, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notes_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notes ?? 'No notes added.',
              style: TextStyle(
                fontSize: 14,
                color: notes != null
                    ? AppColors.lightText
                    : AppColors.lightTextSecondary,
                fontStyle: notes == null ? FontStyle.italic : FontStyle.normal,
                height: 1.4,
              ),
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.lightTextSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
