import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/settings/blocs/user_cubit.dart';
import 'package:electra/presentation/settings/blocs/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountDialog extends StatefulWidget {
  final String userId;

  const DeleteAccountDialog({super.key, required this.userId});

  /// Returns true if the account was deleted.
  static Future<bool> show(BuildContext context, String userId) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<UserCubit>(),
        child: DeleteAccountDialog(userId: userId),
      ),
    );
    return result ?? false;
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _ctrl = TextEditingController();
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(
      () => setState(() => _confirmed = _ctrl.text.trim() == 'DELETE'),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _delete(BuildContext context) async {
    await context.read<UserCubit>().deleteAccount(widget.userId);
    if (context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserFailure) {
          Navigator.of(context).pop(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: theme.cardTheme.color,
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                color: theme.colorScheme.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Delete Account',
              style: TextStyle(
                fontSize: AppFontSize.xxl,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action is permanent and cannot be undone. '
              'All your data, purchases, and settings will be deleted.',
              style: TextStyle(
                fontSize: AppFontSize.md,
                height: 1.5,
                color: theme.textTheme.bodySmall!.color!,
              ),
            ),
            const SizedBox(height: 20),

            // Warning box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: Colors.red.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Type DELETE below to confirm you understand this is irreversible.',
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        color: Colors.red.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Confirmation field
            TextField(
              controller: _ctrl,
              autocorrect: false,
              cursorColor: Colors.red.shade700,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
                letterSpacing: 1,
              ),
              decoration: InputDecoration(
                hintText: 'Type DELETE here',
                hintStyle: TextStyle(
                  color: AppColors.lightTextSecondary,
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                ),
                filled: true,
                fillColor: const Color(0xFFFFF5F5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red.shade500,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      final isDeleting = state is UserLoading;
                      return FilledButton(
                        onPressed: (_confirmed && !isDeleting)
                            ? () => _delete(context)
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          disabledBackgroundColor: Colors.red.shade200,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isDeleting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Delete',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
