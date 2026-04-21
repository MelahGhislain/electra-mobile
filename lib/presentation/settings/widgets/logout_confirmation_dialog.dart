import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';
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

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthRepository>().logout(); // clears tokens
    if (!context.mounted) return;
    context
        .read<AppAuthCubit>()
        .onLogout(); // triggers GoRouter redirect → /sign-in
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.lightBackground,
      title: const Text(
        'Log out',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: const Text(
        'Are you sure you want to log out of your account?',
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
          onPressed: () => _logout(context),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.darkBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Log out'),
        ),
      ],
    );
  }
}
