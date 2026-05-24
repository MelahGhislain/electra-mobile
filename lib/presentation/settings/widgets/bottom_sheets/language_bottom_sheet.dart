import 'package:minata/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:minata/common/widgets/text_fields/radio_option_list.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Each entry maps a human-readable label to the BCP-47 locale code
/// that gets saved to the backend. [code] must match an ARB @@locale.
/// null code means "use the device locale".
class AppLanguage {
  final String label;
  final String? subtitle; // native name shown below the label
  final String? code; // BCP-47, e.g. "fr", "zh". null = system default.

  const AppLanguage({required this.label, this.subtitle, this.code});

  static const systemDefault = AppLanguage(label: 'System Default', code: null);

  static const all = [
    systemDefault,
    AppLanguage(label: 'English', code: 'en'),
    AppLanguage(label: 'Français', code: 'fr', subtitle: 'French'),
    AppLanguage(label: 'Español', code: 'es', subtitle: 'Spanish'),
    AppLanguage(label: 'Deutsch', code: 'de', subtitle: 'German'),
    AppLanguage(label: 'Português', code: 'pt', subtitle: 'Portuguese'),
    AppLanguage(label: '简体中文', code: 'zh', subtitle: 'Simplified Chinese'),
    AppLanguage(label: '日本語', code: 'ja', subtitle: 'Japanese'),
    AppLanguage(label: '한국어', code: 'ko', subtitle: 'Korean'),
    AppLanguage(label: 'العربية', code: 'ar', subtitle: 'Arabic'),
  ];

  /// Returns the [AppLanguage] whose [code] matches [localeCode].
  /// Falls back to [systemDefault] if no match.
  static AppLanguage fromCode(String? localeCode) {
    if (localeCode == null || localeCode.isEmpty) return systemDefault;
    return all.firstWhere(
      (l) => l.code?.toLowerCase() == localeCode.toLowerCase(),
      orElse: () => systemDefault,
    );
  }

  /// The value to persist to the backend.
  /// systemDefault sends empty string so the backend stores no preference.
  String get backendValue => code ?? '';

  /// Only "System Default" is translated — all other labels are native-script
  /// names (e.g. "Français", "日本語") that must never be translated, because
  /// a user who speaks that language needs to recognise it regardless of the
  /// current app locale.
  String localizedLabel(AppLocalizations l) =>
      code == null ? l.languageSystemDefault : label;
}

class LanguageBottomSheet {
  static Future<AppLanguage?> show(BuildContext context, AppLanguage current) {
    final l = AppLocalizations.of(context);
    return AppBottomSheet.show<AppLanguage>(
      context,
      title: l.settingsLanguage,
      icon: Icons.language_rounded,
      child: RadioOptionList<AppLanguage>(
        selectedValue: current,
        onSelected: (value) {
          Navigator.of(context, rootNavigator: false).pop(value);
        },
        options: AppLanguage.all
            .map(
              (lang) => RadioOption(
                value: lang,
                label: lang.localizedLabel(l),
                subtitle: lang.subtitle,
              ),
            )
            .toList(),
      ),
    );
  }
}
