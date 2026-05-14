import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ChipSelector<T> extends StatelessWidget {
  final String label;
  final String? emptyMessage;
  final List<ChipSelectorOption<T>> options;
  final T? selected;
  final ValueChanged<T?> onSelected;

  const ChipSelector({
    super.key,
    required this.label,
    this.emptyMessage,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase()),
        const SizedBox(height: 10),
        emptyMessage != null
            ? _EmptyOption(label: emptyMessage!)
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((opt) {
                  final isSelected = opt.value == selected;
                  return GestureDetector(
                    onTap: () => onSelected(opt.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.darkBackground
                            : isDark
                            ? colorScheme.onSurface
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? theme.primaryColor
                              : theme.dividerColor,
                        ),
                      ),
                      child: Text(
                        opt.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: AppFontSize.sm,
                          fontWeight: isSelected ? FontWeight.w500 : null,
                          color: !isDark && isSelected
                              ? theme.colorScheme.surface
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}

class ChipSelectorOption<T> {
  final T value;
  final String label;

  const ChipSelectorOption({required this.value, required this.label});
}

class _EmptyOption extends StatelessWidget {
  final String label;
  const _EmptyOption({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.lightTextSecondary,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
