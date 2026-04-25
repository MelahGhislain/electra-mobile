import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/text_fields/radio_option_list.dart';
import 'package:flutter/material.dart';

enum AppLanguage {
  systemDefault,
  english,
  french,
  spanish,
  german,
  japanese,
  chineseSimplified,
  korean,
}

extension AppLanguageExtension on AppLanguage {
  String get label {
    return switch (this) {
      AppLanguage.systemDefault => 'System Default',
      AppLanguage.english => 'English',
      AppLanguage.french => 'Français',
      AppLanguage.spanish => 'Español',
      AppLanguage.german => 'Deutsch',
      AppLanguage.japanese => '日本語',
      AppLanguage.chineseSimplified => '简体中文',
      AppLanguage.korean => '한국어',
    };
  }

  String? get subtitle {
    return switch (this) {
      AppLanguage.french => 'French',
      AppLanguage.spanish => 'Spanish',
      AppLanguage.german => 'German',
      AppLanguage.japanese => 'Japanese',
      AppLanguage.chineseSimplified => 'Simplified Chinese',
      AppLanguage.korean => 'Korean',
      _ => null,
    };
  }
}

class LanguageBottomSheet {
  static Future<AppLanguage?> show(BuildContext context, AppLanguage current) {
    return AppBottomSheet.show<AppLanguage>(
      context,
      title: 'Language',
      icon: Icons.language,
      child: RadioOptionList<AppLanguage>(
        selectedValue: current,
        onSelected: (_) {},
        options: AppLanguage.values
            .map(
              (lang) => RadioOption(
                value: lang,
                label: lang.label,
                subtitle: lang.subtitle,
              ),
            )
            .toList(),
      ),
    );
  }
}
