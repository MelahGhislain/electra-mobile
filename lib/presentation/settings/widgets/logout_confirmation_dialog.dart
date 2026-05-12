import 'package:electra/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  /// Call this static method from anywhere — returns true if user confirmed.
  static Future<bool> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const LogoutConfirmationDialog(),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.cardTheme.color,
      title: Text(
        l.logoutTitle,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.textTheme.titleLarge?.color,
        ),
      ),
      content: Text(l.logoutBody, style: TextStyle()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            l.cancel,
            style: TextStyle(color: theme.textTheme.titleLarge?.color),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: theme.appBarTheme.foregroundColor,
            foregroundColor: theme.appBarTheme.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(l.logoutTitle),
        ),
      ],
    );
  }
}
