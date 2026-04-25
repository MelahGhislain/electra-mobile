import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SpendingDetailActionBar extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SpendingDetailActionBar({super.key, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.lightBackground,
        border: Border(top: BorderSide(color: AppColors.dividerLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.edit_rounded,
              label: 'Edit purchase',
              foreground: AppColors.primary,
              background: AppColors.primary.withValues(alpha: 0.08),
              onTap: onEdit,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.delete_outline_rounded,
              label: 'Delete purchase',
              foreground: const Color(0xFFEF4444),
              background: const Color(0xFFEF4444).withValues(alpha: 0.08),
              onTap: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: foreground),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
