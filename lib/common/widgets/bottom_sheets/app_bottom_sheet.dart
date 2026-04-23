import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppBottomSheet {
  /// Show a reusable bottom sheet across the app.
  /// Pass any widget as [child].
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    IconData? icon,
    required Widget child,
    bool isDismissible = true,
    double? maxHeight,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AppBottomSheetContent(
        title: title,
        icon: icon,
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.75,
        child: child,
      ),
    );
  }
}

class _AppBottomSheetContent extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final double maxHeight;

  const _AppBottomSheetContent({
    this.title,
    this.icon,
    required this.child,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primary, size: 24),
                  const SizedBox(width: 10),
                ],
                if (title != null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
                if (title == null && icon == null) ...[
                  const SizedBox(width: 34), // Spacer to maintain layout
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.dividerLight),
          const SizedBox(height: 8),

          // Content
          Flexible(child: child),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
