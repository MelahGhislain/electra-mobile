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
    final theme = Theme.of(context);

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: theme.cardTheme.color,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge!.color,
            ),
          ),
          content: Text(description),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                cancelText,
                style: TextStyle(color: theme.textTheme.titleLarge!.color),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
                onConfirm?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: isDestructive
                    ? theme.colorScheme.error
                    : theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                confirmText,
                style: TextStyle(color: AppColors.darkText),
              ),
            ),
          ],
        );
      },
    );
  }
}
