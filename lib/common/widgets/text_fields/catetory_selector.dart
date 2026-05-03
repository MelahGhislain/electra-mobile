import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:flutter/material.dart';

class CategorySelectField extends StatelessWidget {
  final String? label;
  final CategoryMeta selected;
  final VoidCallback onTap;

  const CategorySelectField({
    required this.selected,
    required this.onTap,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: const TextStyle(fontSize: AppFontSize.md)),
          const SizedBox(height: 6),
        ],

        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.onSurface : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: selected.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(selected.icon, size: 16, color: selected.color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selected.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppFontSize.xl,
                  color: theme.iconTheme.color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
