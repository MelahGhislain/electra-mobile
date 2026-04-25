import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  /// Call this static method from anywhere — returns true if user confirmed.
  static Future<bool> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LogoutConfirmationDialog(),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.lightBackground,
      title: const Text(
        'Logout',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
      ),
      content: const Text(
        'Are you sure you want to logout of your account?',
        style: TextStyle(color: AppColors.lightTextSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.lightTextSecondary),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.darkBackground,
            foregroundColor: AppColors.darkText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
