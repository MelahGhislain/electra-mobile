// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Electra';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsHelp => 'Help';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsBudget => 'Budget & Income';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsNotifications => 'Push Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Get reminders and spending alerts';

  @override
  String get settingsExportData => 'Export Data';

  @override
  String get settingsExportDataSubtitle => 'Export your data';

  @override
  String get settingsSharedAccount => 'Shared Account';

  @override
  String get settingsSharedAccountSubtitle => 'Manage shared account settings';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsSupportSubtitle => 'Contact our support team';

  @override
  String get settingsDocs => 'Documentation';

  @override
  String get settingsDocsSubtitle => 'Learn how to use the app';

  @override
  String get settingsSuggest => 'Suggest an Improvement';

  @override
  String get settingsSuggestSubtitle => 'Share your feedback to help us';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSetupGuide => 'Setup Guide';

  @override
  String get settingsSetupGuideSubtitle => 'New here? Start with this';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsDeleteAccountSubtitle => 'Permanently remove your account';

  @override
  String get budgetNotSet => 'Not set';

  @override
  String budgetPerMonth(String amount) {
    return '$amount / month';
  }

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSystemDefault => 'System Default';

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
  String get logoutTitle => 'Log out?';

  @override
  String get logoutBody => 'You will be signed out of your account.';

  @override
  String get logoutConfirm => 'Log out';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get retry => 'Try again';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountBody =>
      'This will permanently remove your account and all your data. This action cannot be undone.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingLetsGo => 'Let\'s Go';

  @override
  String homeGreeting(String name) {
    return 'Hello $name';
  }

  @override
  String get homeTagline => 'Take control of\nyour day';

  @override
  String get homeSpendingBreakdown => 'Spending Breakdown';

  @override
  String get homeMonthlySnapshot => 'Monthly Snapshot';

  @override
  String get homeRecentlyCompleted => 'Recently Completed';

  @override
  String get homeViewAll => 'View all';

  @override
  String homeAvgDaily(String amount) {
    return 'Avg. daily spend: $amount';
  }

  @override
  String get homeBudgetGood => 'Nice work! You\'re staying within budget 👍';

  @override
  String get homeBudgetWarning => 'Heads up! You\'re close to your budget.';

  @override
  String get homeBudgetOver => 'You have exceeded your monthly budget.';

  @override
  String get homeBudgetNone => 'No budget set for this month.';

  @override
  String get insightsTitle => 'Spending insights';

  @override
  String get insightsPeriodWeekly => 'Weekly';

  @override
  String get insightsPeriodMonthly => 'Monthly';

  @override
  String get insightsPeriodYearly => 'Yearly';

  @override
  String insightsTotalSpent(String period) {
    return 'Total spent in $period';
  }

  @override
  String get insightsBudgetOnTrack => 'On track';

  @override
  String get insightsBudgetOver => 'Over budget';

  @override
  String get insightsSpendingOverview => 'Spending overview';

  @override
  String get insightsViewByCategories => 'View by categories';

  @override
  String get insightsViewAllCategories => 'View all categories';

  @override
  String get insightsKeyInsights => 'Key insights';

  @override
  String get insightsTopCategories => 'Top spending categories';

  @override
  String get insightsViewAll => 'View all';

  @override
  String get insightsTrend => 'Spending trend';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get errorNetwork => 'Unable to connect. Please check your network.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';
}
