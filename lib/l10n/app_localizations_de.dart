// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Electra';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsData => 'Daten';

  @override
  String get settingsHelp => 'Hilfe';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsBudget => 'Budget & Einkommen';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsCurrency => 'Währung';

  @override
  String get settingsNotifications => 'Push-Benachrichtigungen';

  @override
  String get settingsNotificationsSubtitle =>
      'Erhalte Erinnerungen und Ausgabenwarnungen';

  @override
  String get settingsExportData => 'Daten exportieren';

  @override
  String get settingsExportDataSubtitle => 'Exportiere deine Daten';

  @override
  String get settingsSharedAccount => 'Geteiltes Konto';

  @override
  String get settingsSharedAccountSubtitle =>
      'Einstellungen für geteiltes Konto verwalten';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsSupportSubtitle => 'Kontaktiere unser Support-Team';

  @override
  String get settingsDocs => 'Dokumentation';

  @override
  String get settingsDocsSubtitle => 'Lerne die App kennen';

  @override
  String get settingsSuggest => 'Verbesserung vorschlagen';

  @override
  String get settingsSuggestSubtitle => 'Teile dein Feedback';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSetupGuide => 'Einrichtungshandbuch';

  @override
  String get settingsSetupGuideSubtitle => 'Neu hier? Starte hier';

  @override
  String get settingsDeleteAccount => 'Konto löschen';

  @override
  String get settingsDeleteAccountSubtitle => 'Konto dauerhaft entfernen';

  @override
  String get budgetNotSet => 'Nicht festgelegt';

  @override
  String budgetPerMonth(String amount) {
    return '$amount / Monat';
  }

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get languageSystemDefault => 'Systemstandard';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageChineseSimplified => '简体中文';

  @override
  String get languageKorean => '한국어';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageArabic => 'العربية';

  @override
  String get logoutTitle => 'Abmelden?';

  @override
  String get logoutBody => 'Du wirst von deinem Konto abgemeldet.';

  @override
  String get logoutConfirm => 'Abmelden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountBody =>
      'Dein Konto und alle Daten werden dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingLetsGo => 'Los geht\'s';

  @override
  String homeGreeting(String name) {
    return 'Hallo $name';
  }

  @override
  String get homeTagline => 'Übernimm die Kontrolle\nüber deinen Tag';

  @override
  String get homeSpendingBreakdown => 'Ausgabenübersicht';

  @override
  String get homeMonthlySnapshot => 'Monatsübersicht';

  @override
  String get homeRecentlyCompleted => 'Zuletzt abgeschlossen';

  @override
  String get homeViewAll => 'Alle anzeigen';

  @override
  String homeAvgDaily(String amount) {
    return 'Ø Tagesausgabe: $amount';
  }

  @override
  String get homeBudgetGood => 'Gut gemacht! Du bleibst im Budget 👍';

  @override
  String get homeBudgetWarning => 'Achtung! Du näherst dich deinem Budget.';

  @override
  String get homeBudgetOver => 'Du hast dein Monatsbudget überschritten.';

  @override
  String get homeBudgetNone => 'Kein Budget für diesen Monat festgelegt.';

  @override
  String get insightsTitle => 'Ausgabenanalyse';

  @override
  String get insightsPeriodWeekly => 'Wöchentlich';

  @override
  String get insightsPeriodMonthly => 'Monatlich';

  @override
  String get insightsPeriodYearly => 'Jährlich';

  @override
  String insightsTotalSpent(String period) {
    return 'Gesamt ausgegeben im $period';
  }

  @override
  String get insightsBudgetOnTrack => 'Im Plan';

  @override
  String get insightsBudgetOver => 'Budget überschritten';

  @override
  String get insightsSpendingOverview => 'Ausgabenübersicht';

  @override
  String get insightsViewByCategories => 'Nach Kategorien';

  @override
  String get insightsViewAllCategories => 'Alle Kategorien';

  @override
  String get insightsKeyInsights => 'Wichtige Erkenntnisse';

  @override
  String get insightsTopCategories => 'Top-Kategorien';

  @override
  String get insightsViewAll => 'Alle anzeigen';

  @override
  String get insightsTrend => 'Ausgabentrend';

  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen';

  @override
  String get errorNetwork => 'Keine Verbindung. Prüfe dein Netzwerk.';

  @override
  String get errorSessionExpired =>
      'Deine Sitzung ist abgelaufen. Bitte erneut anmelden.';
}
