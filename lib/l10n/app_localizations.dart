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
  /// **'Qleo'**
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
  /// **'Log out'**
  String get logoutTitle;

  /// No description provided for @logoutBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout of your account?'**
  String get logoutBody;

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

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get nameTooShort;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @emailCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailCannotBeEmpty;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @budgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a monthly spending limit to stay on track.'**
  String get budgetSubtitle;

  /// No description provided for @budgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Budget Amount'**
  String get budgetAmount;

  /// No description provided for @enterBudgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter budget amount'**
  String get enterBudgetAmount;

  /// No description provided for @pleaseEnterABudgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a budget amount'**
  String get pleaseEnterABudgetAmount;

  /// No description provided for @enterAValidAmountGreaterThan0.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount greater than 0'**
  String get enterAValidAmountGreaterThan0;

  /// No description provided for @budgetSeemsTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Budget seems too high — please check'**
  String get budgetSeemsTooHigh;

  /// No description provided for @quickSelect.
  ///
  /// In en, this message translates to:
  /// **'Quick select'**
  String get quickSelect;

  /// No description provided for @saveBudget.
  ///
  /// In en, this message translates to:
  /// **'Save Budget'**
  String get saveBudget;

  /// No description provided for @removeBudget.
  ///
  /// In en, this message translates to:
  /// **'Remove Budget'**
  String get removeBudget;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data, purchases, and settings will be deleted.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Type {keyword} below to confirm you understand this is irreversible.'**
  String deleteAccountConfirmationMessage(String keyword);

  /// No description provided for @typeDeleteHere.
  ///
  /// In en, this message translates to:
  /// **'Type {keyword} here'**
  String typeDeleteHere(String keyword);

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

  /// No description provided for @homeYoureSpendingLessThanUsual.
  ///
  /// In en, this message translates to:
  /// **'You\'re spending less than usual. Great job!'**
  String get homeYoureSpendingLessThanUsual;

  /// No description provided for @letsSetThingsUp.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set things up'**
  String get letsSetThingsUp;

  /// No description provided for @getTheMostOutOfTheAppBySetting.
  ///
  /// In en, this message translates to:
  /// **'Get the most out of the app by setting up a few things.'**
  String get getTheMostOutOfTheAppBySetting;

  /// No description provided for @setMonthlyBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your monthly budget'**
  String get setMonthlyBudgetTitle;

  /// No description provided for @helpUsPersonalizeYourSpending.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your spending plan'**
  String get helpUsPersonalizeYourSpending;

  /// No description provided for @enablePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable push notifications'**
  String get enablePushNotifications;

  /// No description provided for @stayUpdatedOnSpending.
  ///
  /// In en, this message translates to:
  /// **'Stay updated on spending & reminders'**
  String get stayUpdatedOnSpending;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @youCanChangeTheseLater.
  ///
  /// In en, this message translates to:
  /// **'You can always change these later in Settings.'**
  String get youCanChangeTheseLater;

  /// No description provided for @todaysSpending.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Spending'**
  String get todaysSpending;

  /// No description provided for @vsYesterday.
  ///
  /// In en, this message translates to:
  /// **'{percentage}% vs yesterday'**
  String vsYesterday(String percentage);

  /// No description provided for @noDataForYesterday.
  ///
  /// In en, this message translates to:
  /// **'No data for yesterday'**
  String get noDataForYesterday;

  /// No description provided for @mostRecentPurchase.
  ///
  /// In en, this message translates to:
  /// **'Most recent purchase'**
  String get mostRecentPurchase;

  /// No description provided for @ofDailyBudget.
  ///
  /// In en, this message translates to:
  /// **'of daily\nbudget'**
  String get ofDailyBudget;

  /// No description provided for @dailyBudget.
  ///
  /// In en, this message translates to:
  /// **'Daily budget'**
  String get dailyBudget;

  /// No description provided for @mostRecentSpending.
  ///
  /// In en, this message translates to:
  /// **'Most Recent Spending'**
  String get mostRecentSpending;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @headsUp.
  ///
  /// In en, this message translates to:
  /// **'Heads up'**
  String get headsUp;

  /// No description provided for @avgDailySpend.
  ///
  /// In en, this message translates to:
  /// **'Avg. daily spend'**
  String get avgDailySpend;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get daysLeft;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @setBudget.
  ///
  /// In en, this message translates to:
  /// **'Set Budget'**
  String get setBudget;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan\nReceipt'**
  String get scanReceipt;

  /// No description provided for @noBudgetSetForThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No budget set for this month.'**
  String get noBudgetSetForThisMonth;

  /// No description provided for @youHaveExceededYourMonthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'You have exceeded your monthly budget.'**
  String get youHaveExceededYourMonthlyBudget;

  /// No description provided for @headsUpYouAreCloseToYourBudget.
  ///
  /// In en, this message translates to:
  /// **'Heads up! You\'re close to your budget.'**
  String get headsUpYouAreCloseToYourBudget;

  /// No description provided for @niceWorkYouAreStayingWithinBudget.
  ///
  /// In en, this message translates to:
  /// **'Nice work! You\'re staying within budget 👍'**
  String get niceWorkYouAreStayingWithinBudget;

  /// No description provided for @spending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get spending;

  /// No description provided for @trackYourSpendingStayInControl.
  ///
  /// In en, this message translates to:
  /// **'Track your spending, stay in control'**
  String get trackYourSpendingStayInControl;

  /// No description provided for @searchMerchantItemOrCategory.
  ///
  /// In en, this message translates to:
  /// **'Search merchant, item or category...'**
  String get searchMerchantItemOrCategory;

  /// No description provided for @spendingInsightMessage.
  ///
  /// In en, this message translates to:
  /// **'You spent {percentage}% more on {category} this week'**
  String spendingInsightMessage(String percentage, String category);

  /// No description provided for @addPurchase.
  ///
  /// In en, this message translates to:
  /// **'Add Purchase'**
  String get addPurchase;

  /// No description provided for @editPurchase.
  ///
  /// In en, this message translates to:
  /// **'Edit purchase'**
  String get editPurchase;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @savePurchase.
  ///
  /// In en, this message translates to:
  /// **'Save Purchase'**
  String get savePurchase;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @filterAndSort.
  ///
  /// In en, this message translates to:
  /// **'Filter and Sort'**
  String get filterAndSort;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get resetAll;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @merchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get merchant;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @noMerchantsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No merchants available'**
  String get noMerchantsAvailable;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noPurchasesYet.
  ///
  /// In en, this message translates to:
  /// **'No purchases yet'**
  String get noPurchasesYet;

  /// No description provided for @tryAdjustingFiltersOrSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search query'**
  String get tryAdjustingFiltersOrSearch;

  /// No description provided for @purchaseHistoryWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your purchase history will appear here'**
  String get purchaseHistoryWillAppearHere;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @insight.
  ///
  /// In en, this message translates to:
  /// **'Insight'**
  String get insight;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noItems;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @failedToLoadPurchase.
  ///
  /// In en, this message translates to:
  /// **'Failed to load purchase'**
  String get failedToLoadPurchase;

  /// No description provided for @avgPrice.
  ///
  /// In en, this message translates to:
  /// **'Avg price'**
  String get avgPrice;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @below.
  ///
  /// In en, this message translates to:
  /// **'↓ Below'**
  String get below;

  /// No description provided for @above.
  ///
  /// In en, this message translates to:
  /// **'↑ Above'**
  String get above;

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'At'**
  String get at;

  /// No description provided for @itemInsights.
  ///
  /// In en, this message translates to:
  /// **'↑ +{percent}% vs last purchase • {label} average price'**
  String itemInsights(String percent, String label);

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItem;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get deleteItem;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get edited;

  /// No description provided for @ofTotal.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of total'**
  String ofTotal(String percent);

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get sortNameAZ;

  /// No description provided for @sortNameZA.
  ///
  /// In en, this message translates to:
  /// **'Name (Z–A)'**
  String get sortNameZA;

  /// No description provided for @sortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price ↑'**
  String get sortPriceLow;

  /// No description provided for @sortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price ↓'**
  String get sortPriceHigh;

  /// No description provided for @dateNewest.
  ///
  /// In en, this message translates to:
  /// **'Date ↑'**
  String get dateNewest;

  /// No description provided for @sortDateOldest.
  ///
  /// In en, this message translates to:
  /// **'Date ↓'**
  String get sortDateOldest;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @noItemsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No items recorded'**
  String get noItemsRecorded;

  /// No description provided for @noCategoryDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No category data available'**
  String get noCategoryDataAvailable;

  /// No description provided for @sortItems.
  ///
  /// In en, this message translates to:
  /// **'Sort items'**
  String get sortItems;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @noReceiptAdded.
  ///
  /// In en, this message translates to:
  /// **'No receipt added'**
  String get noReceiptAdded;

  /// No description provided for @uploadedProcessed.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {date} • Processed'**
  String uploadedProcessed(String date);

  /// No description provided for @spendingInsights.
  ///
  /// In en, this message translates to:
  /// **'Spending insights'**
  String get spendingInsights;

  /// No description provided for @spendingOverview.
  ///
  /// In en, this message translates to:
  /// **'Spending overview'**
  String get spendingOverview;

  /// No description provided for @viewByCategories.
  ///
  /// In en, this message translates to:
  /// **'View by {group}'**
  String viewByCategories(String group);

  /// No description provided for @keyInsights.
  ///
  /// In en, this message translates to:
  /// **'Key insights'**
  String get keyInsights;

  /// No description provided for @topSpendingCategories.
  ///
  /// In en, this message translates to:
  /// **'Top spending categories'**
  String get topSpendingCategories;

  /// No description provided for @spendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending trend'**
  String get spendingTrend;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethods;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @noDataThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data\nthis period'**
  String get noDataThisPeriod;

  /// No description provided for @viewAllCategories.
  ///
  /// In en, this message translates to:
  /// **'View all categories'**
  String get viewAllCategories;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @savingsOpportunity.
  ///
  /// In en, this message translates to:
  /// **'Savings opportunity'**
  String get savingsOpportunity;

  /// No description provided for @noSpendingDataThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No spending data this period'**
  String get noSpendingDataThisPeriod;

  /// No description provided for @totalSpentIn.
  ///
  /// In en, this message translates to:
  /// **'Total spent in {period}'**
  String totalSpentIn(String period);

  /// No description provided for @lessThanPrevious.
  ///
  /// In en, this message translates to:
  /// **'{percent}% less than previous ({amount})'**
  String lessThanPrevious(String percent, String amount);

  /// No description provided for @moreThanPrevious.
  ///
  /// In en, this message translates to:
  /// **'{percent}% more than previous ({amount})'**
  String moreThanPrevious(String percent, String amount);

  /// No description provided for @budgetStatus.
  ///
  /// In en, this message translates to:
  /// **'Budget status'**
  String get budgetStatus;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get onTrack;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get overBudget;

  /// No description provided for @ofBudget.
  ///
  /// In en, this message translates to:
  /// **'of {amount} budget'**
  String ofBudget(String amount);

  /// No description provided for @averagePerDay.
  ///
  /// In en, this message translates to:
  /// **'Average per day'**
  String get averagePerDay;

  /// No description provided for @thisPeriod.
  ///
  /// In en, this message translates to:
  /// **'This period'**
  String get thisPeriod;

  /// No description provided for @noTrendDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No trend data available'**
  String get noTrendDataAvailable;

  /// No description provided for @letsSignYouIn.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Sign you in'**
  String get letsSignYouIn;

  /// No description provided for @signInAndStartPlanning.
  ///
  /// In en, this message translates to:
  /// **'Sign in and start planning.'**
  String get signInAndStartPlanning;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterYourMailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your mail address'**
  String get enterYourMailAddress;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue With Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// No description provided for @minimum8Characters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get minimum8Characters;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-Enter Password'**
  String get reEnterPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @orSignWith.
  ///
  /// In en, this message translates to:
  /// **'Or Sign With'**
  String get orSignWith;

  /// No description provided for @whereDidMyMoneyGo.
  ///
  /// In en, this message translates to:
  /// **'Where Did My Money Go?'**
  String get whereDidMyMoneyGo;

  /// No description provided for @myMoney.
  ///
  /// In en, this message translates to:
  /// **'My Money'**
  String get myMoney;

  /// No description provided for @stopGuessingSpending.
  ///
  /// In en, this message translates to:
  /// **'Stop guessing your spending. Qleo helps you track every expense effortlessly.'**
  String get stopGuessingSpending;

  /// No description provided for @trackWithYourVoice.
  ///
  /// In en, this message translates to:
  /// **'Track with Your Voice'**
  String get trackWithYourVoice;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @voiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Just speak, and we\'ll take care of the rest. Fast, smart and super easy.'**
  String get voiceDescription;

  /// No description provided for @autoCategorizeExpenses.
  ///
  /// In en, this message translates to:
  /// **'Auto-Categorize Expenses'**
  String get autoCategorizeExpenses;

  /// No description provided for @autoCategorize.
  ///
  /// In en, this message translates to:
  /// **'Auto-Categorize'**
  String get autoCategorize;

  /// No description provided for @autoCategorizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Qleo automatically categorizes your expenses so you can focus on what matters.'**
  String get autoCategorizeDescription;

  /// No description provided for @insightsThatHelpYouSave.
  ///
  /// In en, this message translates to:
  /// **'Insights That Help You Save'**
  String get insightsThatHelpYouSave;

  /// No description provided for @insightsDescription.
  ///
  /// In en, this message translates to:
  /// **'Understand your spending patterns and make smarter financial decisions.'**
  String get insightsDescription;

  /// No description provided for @yourDataIsSafe.
  ///
  /// In en, this message translates to:
  /// **'Your Data is Always Safe'**
  String get yourDataIsSafe;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get safe;

  /// No description provided for @privacyDescription.
  ///
  /// In en, this message translates to:
  /// **'We keep your data private and secure. Your trust is our priority.'**
  String get privacyDescription;

  /// No description provided for @saveMoreStressLess.
  ///
  /// In en, this message translates to:
  /// **'Save More. Stress Less.'**
  String get saveMoreStressLess;

  /// No description provided for @saveMore.
  ///
  /// In en, this message translates to:
  /// **'Save More.'**
  String get saveMore;

  /// No description provided for @finalOnboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay on top of your finances and build better money habits every day.'**
  String get finalOnboardingDescription;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get letsGo;

  /// No description provided for @spendingDetails.
  ///
  /// In en, this message translates to:
  /// **'Spending details'**
  String get spendingDetails;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @deletePurchase.
  ///
  /// In en, this message translates to:
  /// **'Delete purchase'**
  String get deletePurchase;

  /// No description provided for @deletePurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete purchase?'**
  String get deletePurchaseTitle;

  /// No description provided for @deletePurchaseDescription.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deletePurchaseDescription;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium feature'**
  String get premiumFeature;

  /// No description provided for @savingChanges.
  ///
  /// In en, this message translates to:
  /// **'Saving changes…'**
  String get savingChanges;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get sortOldest;

  /// No description provided for @sortMostExpensive.
  ///
  /// In en, this message translates to:
  /// **'Most Expensive'**
  String get sortMostExpensive;

  /// No description provided for @sortCheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get sortCheapest;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'By Name'**
  String get sortByName;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get categoryHousing;

  /// No description provided for @categoryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get categoryBills;

  /// No description provided for @categorySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get categorySubscriptions;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// No description provided for @categoryGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get categoryGifts;

  /// No description provided for @categoryDonations.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get categoryDonations;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @searchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get searchCategories;

  /// No description provided for @noCategoriesFoundFor.
  ///
  /// In en, this message translates to:
  /// **'No categories found for \"{query}\"'**
  String noCategoriesFoundFor(String query);

  /// No description provided for @itemWillBePermanentlyRemoved.
  ///
  /// In en, this message translates to:
  /// **'\"{itemName}\" will be permanently removed from this purchase.'**
  String itemWillBePermanentlyRemoved(String itemName);

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// No description provided for @itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Beef, Milk, Shampoo'**
  String get itemNameHint;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get unitPrice;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @quantityShort.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quantityShort;

  /// No description provided for @minimumOne.
  ///
  /// In en, this message translates to:
  /// **'Min 1'**
  String get minimumOne;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get selectDateRange;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @enterDetailsManually.
  ///
  /// In en, this message translates to:
  /// **'Enter details manually'**
  String get enterDetailsManually;

  /// No description provided for @voiceInput.
  ///
  /// In en, this message translates to:
  /// **'Voice Input'**
  String get voiceInput;

  /// No description provided for @addBySpeaking.
  ///
  /// In en, this message translates to:
  /// **'Add by speaking'**
  String get addBySpeaking;

  /// No description provided for @snapPhotoOfReceipt.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo of your receipt'**
  String get snapPhotoOfReceipt;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @merchants.
  ///
  /// In en, this message translates to:
  /// **'Merchants'**
  String get merchants;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily average'**
  String get dailyAverage;

  /// No description provided for @financialHealthReport.
  ///
  /// In en, this message translates to:
  /// **'Financial Health Report'**
  String get financialHealthReport;

  /// No description provided for @financialHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Financial health score'**
  String get financialHealthScore;

  /// No description provided for @generatedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated at'**
  String get generatedAt;

  /// No description provided for @noOpportunity.
  ///
  /// In en, this message translates to:
  /// **'No opportunity found'**
  String get noOpportunity;

  /// No description provided for @ofTotalSpend.
  ///
  /// In en, this message translates to:
  /// **'of total spend'**
  String get ofTotalSpend;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get perDay;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'per year'**
  String get perYear;

  /// No description provided for @periodSummary.
  ///
  /// In en, this message translates to:
  /// **'Period Summary'**
  String get periodSummary;

  /// No description provided for @potentialSavings.
  ///
  /// In en, this message translates to:
  /// **'Potential savings'**
  String get potentialSavings;

  /// No description provided for @recommendationsForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommendations for you'**
  String get recommendationsForYou;

  /// No description provided for @topCategory.
  ///
  /// In en, this message translates to:
  /// **'Top category'**
  String get topCategory;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get totalSpent;

  /// No description provided for @viewFullReport.
  ///
  /// In en, this message translates to:
  /// **'View full report'**
  String get viewFullReport;

  /// No description provided for @vsLastPeriod.
  ///
  /// In en, this message translates to:
  /// **'vs last period'**
  String get vsLastPeriod;

  /// No description provided for @vsPreviousPeriod.
  ///
  /// In en, this message translates to:
  /// **'vs previous period'**
  String get vsPreviousPeriod;

  /// No description provided for @youSpentTheMostOn.
  ///
  /// In en, this message translates to:
  /// **'You spent the most on'**
  String get youSpentTheMostOn;
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
