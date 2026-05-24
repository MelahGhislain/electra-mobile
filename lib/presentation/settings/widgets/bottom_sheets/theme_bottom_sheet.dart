import 'package:minata/common/widgets/text_fields/radio_option_list.dart';
import 'package:minata/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ThemeBottomSheet {
  static Future<ThemeMode?> show(BuildContext context, ThemeMode current) {
    final l = AppLocalizations.of(context);
    return AppBottomSheet.show<ThemeMode>(
      context,
      title: l.settingsTheme,
      icon: Icons.palette_outlined,
      child: RadioOptionList<ThemeMode>(
        selectedValue: current,
        onSelected: (value) {
          Navigator.of(context, rootNavigator: false).pop(value);
        },
        options: [
          RadioOption(
            value: ThemeMode.system,
            label: l.themeSystem,
            trailing: Icon(
              Icons.brightness_auto,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          RadioOption(
            value: ThemeMode.light,
            label: l.themeLight,
            trailing: Icon(
              Icons.wb_sunny_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          RadioOption(
            value: ThemeMode.dark,
            label: l.themeDark,
            trailing: Icon(
              Icons.nightlight_round,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
