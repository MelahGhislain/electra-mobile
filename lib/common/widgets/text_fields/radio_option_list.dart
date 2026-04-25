import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RadioOptionList<T> extends StatefulWidget {
  final List<RadioOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const RadioOptionList({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  State<RadioOptionList<T>> createState() => _RadioOptionListState<T>();
}

class _RadioOptionListState<T> extends State<RadioOptionList<T>> {
  late T _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: widget.options.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final option = widget.options[index];
        final isSelected = option.value == _selected;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() => _selected = option.value);
            widget.onSelected(option.value);
            Navigator.of(context).pop(option.value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Radio indicator
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : null,
                ),

                const SizedBox(width: 14),

                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: AppColors.lightText,
                        ),
                      ),
                      if (option.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Trailing icon
                if (option.trailing != null) option.trailing!,
              ],
            ),
          ),
        );
      },
    );
  }
}

class RadioOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? trailing;

  const RadioOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.trailing,
  });
}
