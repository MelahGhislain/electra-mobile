// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Qleo';

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
  String get logoutTitle => 'Log out';

  @override
  String get logoutBody => 'Are you sure you want to logout of your account?';

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
  String get tryAgain => 'Try again';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get nameTooShort => 'Name is too short';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get emailCannotBeEmpty => 'Email cannot be empty';

  @override
  String get enterValidEmail => 'Enter a valid email address';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get budgetSubtitle => 'Set a monthly spending limit to stay on track.';

  @override
  String get budgetAmount => 'Budget Amount';

  @override
  String get enterBudgetAmount => 'Enter budget amount';

  @override
  String get pleaseEnterABudgetAmount => 'Please enter a budget amount';

  @override
  String get enterAValidAmountGreaterThan0 =>
      'Enter a valid amount greater than 0';

  @override
  String get budgetSeemsTooHigh => 'Budget seems too high — please check';

  @override
  String get quickSelect => 'Quick select';

  @override
  String get saveBudget => 'Save Budget';

  @override
  String get removeBudget => 'Remove Budget';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountBody =>
      'This action is permanent and cannot be undone. All your data, purchases, and settings will be deleted.';

  @override
  String deleteAccountConfirmationMessage(String keyword) {
    return 'Type $keyword below to confirm you understand this is irreversible.';
  }

  @override
  String typeDeleteHere(String keyword) {
    return 'Type $keyword here';
  }

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
  String get homeYoureSpendingLessThanUsual =>
      'You\'re spending less than usual. Great job!';

  @override
  String get letsSetThingsUp => 'Let\'s set things up';

  @override
  String get getTheMostOutOfTheAppBySetting =>
      'Get the most out of the app by setting up a few things.';

  @override
  String get setMonthlyBudgetTitle => 'Set your monthly budget';

  @override
  String get helpUsPersonalizeYourSpending =>
      'Help us personalize your spending plan';

  @override
  String get enablePushNotifications => 'Enable push notifications';

  @override
  String get stayUpdatedOnSpending => 'Stay updated on spending & reminders';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get youCanChangeTheseLater =>
      'You can always change these later in Settings.';

  @override
  String get todaysSpending => 'Today\'s Spending';

  @override
  String vsYesterday(String percentage) {
    return '$percentage% vs yesterday';
  }

  @override
  String get noDataForYesterday => 'No data for yesterday';

  @override
  String get mostRecentPurchase => 'Most recent purchase';

  @override
  String get ofDailyBudget => 'of daily\nbudget';

  @override
  String get dailyBudget => 'Daily budget';

  @override
  String get mostRecentSpending => 'Most Recent Spending';

  @override
  String get viewAll => 'View all';

  @override
  String get total => 'Total';

  @override
  String get thisMonth => 'This Month';

  @override
  String get headsUp => 'Heads up';

  @override
  String get avgDailySpend => 'Avg. daily spend';

  @override
  String get daysLeft => 'Days left';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get repeat => 'Repeat';

  @override
  String get setBudget => 'Set Budget';

  @override
  String get scanReceipt => 'Scan\nReceipt';

  @override
  String get noBudgetSetForThisMonth => 'No budget set for this month.';

  @override
  String get youHaveExceededYourMonthlyBudget =>
      'You have exceeded your monthly budget.';

  @override
  String get headsUpYouAreCloseToYourBudget =>
      'Heads up! You\'re close to your budget.';

  @override
  String get niceWorkYouAreStayingWithinBudget =>
      'Nice work! You\'re staying within budget 👍';

  @override
  String get spending => 'Spending';

  @override
  String get trackYourSpendingStayInControl =>
      'Track your spending, stay in control';

  @override
  String get searchMerchantItemOrCategory =>
      'Search merchant, item or category...';

  @override
  String spendingInsightMessage(String percentage, String category) {
    return 'You spent $percentage% more on $category this week';
  }

  @override
  String get addPurchase => 'Add Purchase';

  @override
  String get editPurchase => 'Edit purchase';

  @override
  String get title => 'Title';

  @override
  String get date => 'Date';

  @override
  String get category => 'Category';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get amount => 'Amount';

  @override
  String get currency => 'Currency';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get savePurchase => 'Save Purchase';

  @override
  String get card => 'Card';

  @override
  String get cash => 'Cash';

  @override
  String get other => 'Other';

  @override
  String get filterAndSort => 'Filter and Sort';

  @override
  String get resetAll => 'Reset all';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get sortBy => 'Sort By';

  @override
  String get merchant => 'Merchant';

  @override
  String get dateRange => 'Date Range';

  @override
  String get noCategoriesAvailable => 'No categories available';

  @override
  String get noMerchantsAvailable => 'No merchants available';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get noPurchasesYet => 'No purchases yet';

  @override
  String get tryAdjustingFiltersOrSearch =>
      'Try adjusting your filters or search query';

  @override
  String get purchaseHistoryWillAppearHere =>
      'Your purchase history will appear here';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get insight => 'Insight';

  @override
  String get noItems => 'No items';

  @override
  String get item => 'Item';

  @override
  String get items => 'Items';

  @override
  String get unknown => 'Unknown';

  @override
  String get failedToLoadPurchase => 'Failed to load purchase';

  @override
  String get avgPrice => 'Avg price';

  @override
  String get payment => 'Payment';

  @override
  String get below => '↓ Below';

  @override
  String get above => '↑ Above';

  @override
  String get at => 'At';

  @override
  String itemInsights(String percent, String label) {
    return '↑ +$percent% vs last purchase • $label average price';
  }

  @override
  String get editItem => 'Edit item';

  @override
  String get deleteItem => 'Delete item';

  @override
  String get edited => 'Edited';

  @override
  String ofTotal(String percent) {
    return '$percent% of total';
  }

  @override
  String get sortNameAZ => 'Name (A–Z)';

  @override
  String get sortNameZA => 'Name (Z–A)';

  @override
  String get sortPriceLow => 'Price ↑';

  @override
  String get sortPriceHigh => 'Price ↓';

  @override
  String get dateNewest => 'Date ↑';

  @override
  String get sortDateOldest => 'Date ↓';

  @override
  String get addItem => 'Add item';

  @override
  String get noItemsRecorded => 'No items recorded';

  @override
  String get noCategoryDataAvailable => 'No category data available';

  @override
  String get sortItems => 'Sort items';

  @override
  String get view => 'View';

  @override
  String get receipt => 'Receipt';

  @override
  String get noReceiptAdded => 'No receipt added';

  @override
  String uploadedProcessed(String date) {
    return 'Uploaded $date • Processed';
  }

  @override
  String get spendingInsights => 'Spending insights';

  @override
  String get spendingOverview => 'Spending overview';

  @override
  String viewByCategories(String group) {
    return 'View by $group';
  }

  @override
  String get keyInsights => 'Key insights';

  @override
  String get topSpendingCategories => 'Top spending categories';

  @override
  String get spendingTrend => 'Spending trend';

  @override
  String get previous => 'Previous';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get noDataThisPeriod => 'No data\nthis period';

  @override
  String get viewAllCategories => 'View all categories';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get savingsOpportunity => 'Savings opportunity';

  @override
  String get noSpendingDataThisPeriod => 'No spending data this period';

  @override
  String totalSpentIn(String period) {
    return 'Total spent in $period';
  }

  @override
  String lessThanPrevious(String percent, String amount) {
    return '$percent% less than previous ($amount)';
  }

  @override
  String moreThanPrevious(String percent, String amount) {
    return '$percent% more than previous ($amount)';
  }

  @override
  String get budgetStatus => 'Budget status';

  @override
  String get onTrack => 'On track';

  @override
  String get overBudget => 'Over budget';

  @override
  String ofBudget(String amount) {
    return 'of $amount budget';
  }

  @override
  String get averagePerDay => 'Average per day';

  @override
  String get thisPeriod => 'This period';

  @override
  String get noTrendDataAvailable => 'No trend data available';

  @override
  String get letsSignYouIn => 'Let\'s Sign you in';

  @override
  String get signInAndStartPlanning => 'Sign in and start planning.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterYourMailAddress => 'Enter your mail address';

  @override
  String get emailIsRequired => 'Email is required';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String get signIn => 'Sign In';

  @override
  String get continueWithGoogle => 'Continue With Google';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get fullName => 'Full Name';

  @override
  String get nameIsRequired => 'Name is required';

  @override
  String get minimum8Characters => 'Minimum 8 characters';

  @override
  String get reEnterPassword => 'Re-Enter Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get orSignWith => 'Or Sign With';

  @override
  String get whereDidMyMoneyGo => 'Where Did My Money Go?';

  @override
  String get myMoney => 'My Money';

  @override
  String get stopGuessingSpending =>
      'Stop guessing your spending. Qleo helps you track every expense effortlessly.';

  @override
  String get trackWithYourVoice => 'Track with Your Voice';

  @override
  String get voice => 'Voice';

  @override
  String get voiceDescription =>
      'Just speak, and we\'ll take care of the rest. Fast, smart and super easy.';

  @override
  String get autoCategorizeExpenses => 'Auto-Categorize Expenses';

  @override
  String get autoCategorize => 'Auto-Categorize';

  @override
  String get autoCategorizeDescription =>
      'Qleo automatically categorizes your expenses so you can focus on what matters.';

  @override
  String get insightsThatHelpYouSave => 'Insights That Help You Save';

  @override
  String get insightsDescription =>
      'Understand your spending patterns and make smarter financial decisions.';

  @override
  String get yourDataIsSafe => 'Your Data is Always Safe';

  @override
  String get safe => 'Safe';

  @override
  String get privacyDescription =>
      'We keep your data private and secure. Your trust is our priority.';

  @override
  String get saveMoreStressLess => 'Save More. Stress Less.';

  @override
  String get saveMore => 'Save More.';

  @override
  String get finalOnboardingDescription =>
      'Stay on top of your finances and build better money habits every day.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get letsGo => 'Let\'s Go';

  @override
  String get spendingDetails => 'Spending details';

  @override
  String get share => 'Share';

  @override
  String get export => 'Export';

  @override
  String get deletePurchase => 'Delete purchase';

  @override
  String get deletePurchaseTitle => 'Delete purchase?';

  @override
  String get deletePurchaseDescription => 'This action cannot be undone.';

  @override
  String get premiumFeature => 'Premium feature';

  @override
  String get savingChanges => 'Saving changes…';

  @override
  String get sortNewest => 'Newest First';

  @override
  String get sortOldest => 'Oldest First';

  @override
  String get sortMostExpensive => 'Most Expensive';

  @override
  String get sortCheapest => 'Cheapest';

  @override
  String get sortByName => 'By Name';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categoryBills => 'Bills';

  @override
  String get categorySubscriptions => 'Subscriptions';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryGifts => 'Gifts';

  @override
  String get categoryDonations => 'Donations';

  @override
  String get categoryOther => 'Other';

  @override
  String get selectCategory => 'Select category';

  @override
  String get searchCategories => 'Search categories...';

  @override
  String noCategoriesFoundFor(String query) {
    return 'No categories found for \"$query\"';
  }

  @override
  String itemWillBePermanentlyRemoved(String itemName) {
    return '\"$itemName\" will be permanently removed from this purchase.';
  }

  @override
  String get itemName => 'Item name';

  @override
  String get itemNameHint => 'e.g. Beef, Milk, Shampoo';

  @override
  String get unitPrice => 'Unit price';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get quantityShort => 'Qty';

  @override
  String get minimumOne => 'Min 1';

  @override
  String get home => 'Home';

  @override
  String get insights => 'Insights';

  @override
  String get profile => 'Profile';

  @override
  String get selectDateRange => 'Select date range';

  @override
  String get premium => 'Premium';

  @override
  String get subscription => 'Subscription';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get enterDetailsManually => 'Enter details manually';

  @override
  String get voiceInput => 'Voice Input';

  @override
  String get addBySpeaking => 'Add by speaking';

  @override
  String get snapPhotoOfReceipt => 'Snap a photo of your receipt';

  @override
  String get all => 'All';

  @override
  String get categories => 'Categories';

  @override
  String get merchants => 'Merchants';

  @override
  String get budget => 'Budget';

  @override
  String get dailyAverage => 'Daily average';

  @override
  String get financialHealthReport => 'Financial Health Report';

  @override
  String get financialHealthScore => 'Financial health score';

  @override
  String get generatedAt => 'Generated at';

  @override
  String get noOpportunity => 'No opportunity found';

  @override
  String get ofTotalSpend => 'of total spend';

  @override
  String get perDay => 'per day';

  @override
  String get perYear => 'per year';

  @override
  String get periodSummary => 'Period Summary';

  @override
  String get potentialSavings => 'Potential savings';

  @override
  String get recommendationsForYou => 'Recommendations for you';

  @override
  String get topCategory => 'Top category';

  @override
  String get totalSpent => 'Total spent';

  @override
  String get viewFullReport => 'View full report';

  @override
  String get vsLastPeriod => 'vs last period';

  @override
  String get vsPreviousPeriod => 'vs previous period';

  @override
  String get youSpentTheMostOn => 'You spent the most on';
}
