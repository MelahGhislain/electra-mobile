import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppConfirmDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.lightSurface,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.lightText,
            ),
          ),
          content: Text(
            description,
            style: const TextStyle(color: AppColors.lightTextSecondary),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                cancelText,
                style: const TextStyle(color: AppColors.lightTextSecondary),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
                onConfirm?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: isDestructive
                    ? const Color(0xFFEF4444)
                    : AppColors.darkBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
