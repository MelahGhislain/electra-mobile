import 'package:electra/common/widgets/text_fields/radio_option_list.dart';
import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeBottomSheet {
  static Future<ThemeMode?> show(BuildContext context, ThemeMode current) {
    return AppBottomSheet.show<ThemeMode>(
      context,
      title: 'Theme',
      icon: Icons.palette_outlined,
      child: RadioOptionList<ThemeMode>(
        selectedValue: current,
        onSelected: (_) {},
        options: const [
          RadioOption(
            value: ThemeMode.system,
            label: 'System',
            trailing: Icon(Icons.brightness_auto, color: AppColors.lightText),
          ),
          RadioOption(
            value: ThemeMode.light,
            label: 'Light',
            trailing: Icon(Icons.wb_sunny_outlined, color: AppColors.lightText),
          ),
          RadioOption(
            value: ThemeMode.dark,
            label: 'Dark',
            trailing: Icon(Icons.nightlight_round, color: AppColors.lightText),
          ),
        ],
      ),
    );
  }
}
