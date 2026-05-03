import 'package:electra/core/configs/fonts.dart';
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
    double? maxHeightPct,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AppBottomSheetContent(
        title: title,
        icon: icon,
        maxHeight: maxHeightPct != null
            ? MediaQuery.of(context).size.height * maxHeightPct
            : MediaQuery.of(context).size.height * 0.75,
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
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: theme.dividerColor),
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
              color: theme.dividerColor,
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
                  Icon(
                    icon,
                    color: Theme.of(context).iconTheme.color,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                ],
                if (title != null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: AppFontSize.lg,
                      fontWeight: FontWeight.bold,
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
          const Divider(height: 0.5),
          const SizedBox(height: 8),

          // Content
          Flexible(child: child),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
