import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// The name of the app
  ///
  /// In en, this message translates to:
  /// **'Electra'**
  String get appName;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get settingsHelp;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget & Income'**
  String get settingsBudget;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get reminders and spending alerts'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsExportData;

  /// No description provided for @settingsExportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export your data'**
  String get settingsExportDataSubtitle;

  /// No description provided for @settingsSharedAccount.
  ///
  /// In en, this message translates to:
  /// **'Shared Account'**
  String get settingsSharedAccount;

  /// No description provided for @settingsSharedAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage shared account settings'**
  String get settingsSharedAccountSubtitle;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact our support team'**
  String get settingsSupportSubtitle;

  /// No description provided for @settingsDocs.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get settingsDocs;

  /// No description provided for @settingsDocsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn how to use the app'**
  String get settingsDocsSubtitle;

  /// No description provided for @settingsSuggest.
  ///
  /// In en, this message translates to:
  /// **'Suggest an Improvement'**
  String get settingsSuggest;

  /// No description provided for @settingsSuggestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback to help us'**
  String get settingsSuggestSubtitle;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsSetupGuide.
  ///
  /// In en, this message translates to:
  /// **'Setup Guide'**
  String get settingsSetupGuide;

  /// No description provided for @settingsSetupGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New here? Start with this'**
  String get settingsSetupGuideSubtitle;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove your account'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @budgetNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get budgetNotSet;

  /// No description provided for @budgetPerMonth.
  ///
  /// In en, this message translates to:
  /// **'{amount} / month'**
  String budgetPerMonth(String amount);

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystemDefault;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @languageChineseSimplified.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get languageChineseSimplified;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutTitle;

  /// No description provided for @logoutBody.
  ///
  /// In en, this message translates to:
  /// **'You will be signed out of your account.'**
  String get logoutBody;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove your account and all your data. This action cannot be undone.'**
  String get deleteAccountBody;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingLetsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get onboardingLetsGo;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Take control of\nyour day'**
  String get homeTagline;

  /// No description provided for @homeSpendingBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Spending Breakdown'**
  String get homeSpendingBreakdown;

  /// No description provided for @homeMonthlySnapshot.
  ///
  /// In en, this message translates to:
  /// **'Monthly Snapshot'**
  String get homeMonthlySnapshot;

  /// No description provided for @homeRecentlyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Recently Completed'**
  String get homeRecentlyCompleted;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// No description provided for @homeAvgDaily.
  ///
  /// In en, this message translates to:
  /// **'Avg. daily spend: {amount}'**
  String homeAvgDaily(String amount);

  /// No description provided for @homeBudgetGood.
  ///
  /// In en, this message translates to:
  /// **'Nice work! You\'re staying within budget 👍'**
  String get homeBudgetGood;

  /// No description provided for @homeBudgetWarning.
  ///
  /// In en, this message translates to:
  /// **'Heads up! You\'re close to your budget.'**
  String get homeBudgetWarning;

  /// No description provided for @homeBudgetOver.
  ///
  /// In en, this message translates to:
  /// **'You have exceeded your monthly budget.'**
  String get homeBudgetOver;

  /// No description provided for @homeBudgetNone.
  ///
  /// In en, this message translates to:
  /// **'No budget set for this month.'**
  String get homeBudgetNone;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending insights'**
  String get insightsTitle;

  /// No description provided for @insightsPeriodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get insightsPeriodWeekly;

  /// No description provided for @insightsPeriodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get insightsPeriodMonthly;

  /// No description provided for @insightsPeriodYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get insightsPeriodYearly;

  /// No description provided for @insightsTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent in {period}'**
  String insightsTotalSpent(String period);

  /// No description provided for @insightsBudgetOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get insightsBudgetOnTrack;

  /// No description provided for @insightsBudgetOver.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get insightsBudgetOver;

  /// No description provided for @insightsSpendingOverview.
  ///
  /// In en, this message translates to:
  /// **'Spending overview'**
  String get insightsSpendingOverview;

  /// No description provided for @insightsViewByCategories.
  ///
  /// In en, this message translates to:
  /// **'View by categories'**
  String get insightsViewByCategories;

  /// No description provided for @insightsViewAllCategories.
  ///
  /// In en, this message translates to:
  /// **'View all categories'**
  String get insightsViewAllCategories;

  /// No description provided for @insightsKeyInsights.
  ///
  /// In en, this message translates to:
  /// **'Key insights'**
  String get insightsKeyInsights;

  /// No description provided for @insightsTopCategories.
  ///
  /// In en, this message translates to:
  /// **'Top spending categories'**
  String get insightsTopCategories;

  /// No description provided for @insightsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get insightsViewAll;

  /// No description provided for @insightsTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending trend'**
  String get insightsTrend;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Please check your network.'**
  String get errorNetwork;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorSessionExpired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
