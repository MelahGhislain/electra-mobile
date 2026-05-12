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
  String get settingsAbout => 'Über die App';

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
      'Erinnerungen und Ausgabenwarnungen erhalten';

  @override
  String get settingsExportData => 'Daten exportieren';

  @override
  String get settingsExportDataSubtitle => 'Exportiere deine Daten';

  @override
  String get settingsSharedAccount => 'Gemeinsames Konto';

  @override
  String get settingsSharedAccountSubtitle =>
      'Einstellungen für gemeinsames Konto verwalten';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsSupportSubtitle => 'Unser Support-Team kontaktieren';

  @override
  String get settingsDocs => 'Dokumentation';

  @override
  String get settingsDocsSubtitle => 'Lerne, die App zu nutzen';

  @override
  String get settingsSuggest => 'Verbesserung vorschlagen';

  @override
  String get settingsSuggestSubtitle => 'Teile dein Feedback, um uns zu helfen';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSetupGuide => 'Einrichtungsanleitung';

  @override
  String get settingsSetupGuideSubtitle => 'Neu hier? Beginne damit';

  @override
  String get settingsDeleteAccount => 'Konto löschen';

  @override
  String get settingsDeleteAccountSubtitle => 'Dein Konto dauerhaft löschen';

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
  String get languageSystemDefault => 'Systemsprache';

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
  String get logoutTitle => 'Abmelden';

  @override
  String get logoutBody =>
      'Möchtest du dich wirklich von deinem Konto abmelden?';

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
  String get tryAgain => 'Erneut versuchen';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get enterYourName => 'Gib deinen Namen ein';

  @override
  String get nameCannotBeEmpty => 'Name darf nicht leer sein';

  @override
  String get nameTooShort => 'Name ist zu kurz';

  @override
  String get email => 'E-Mail';

  @override
  String get enterYourEmail => 'Gib deine E-Mail-Adresse ein';

  @override
  String get emailCannotBeEmpty => 'E-Mail darf nicht leer sein';

  @override
  String get enterValidEmail => 'Gib eine gültige E-Mail-Adresse ein';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get monthlyBudget => 'Monatliches Budget';

  @override
  String get budgetSubtitle =>
      'Lege ein monatliches Ausgabenlimit fest, um auf Kurs zu bleiben.';

  @override
  String get budgetAmount => 'Budgetbetrag';

  @override
  String get enterBudgetAmount => 'Budgetbetrag eingeben';

  @override
  String get pleaseEnterABudgetAmount => 'Bitte gib einen Budgetbetrag ein';

  @override
  String get enterAValidAmountGreaterThan0 =>
      'Gib einen gültigen Betrag größer als 0 ein';

  @override
  String get budgetSeemsTooHigh => 'Budget scheint zu hoch — bitte überprüfen';

  @override
  String get quickSelect => 'Schnellauswahl';

  @override
  String get saveBudget => 'Budget speichern';

  @override
  String get removeBudget => 'Budget entfernen';

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountBody =>
      'Diese Aktion ist dauerhaft und kann nicht rückgängig gemacht werden. Alle deine Daten, Käufe und Einstellungen werden gelöscht.';

  @override
  String deleteAccountConfirmationMessage(String keyword) {
    return 'Gib $keyword unten ein, um zu bestätigen, dass du verstehst, dass dies unwiderruflich ist.';
  }

  @override
  String typeDeleteHere(String keyword) {
    return 'Gib $keyword hier ein';
  }

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
  String get homeYoureSpendingLessThanUsual =>
      'Du gibst weniger als üblich aus. Großartig!';

  @override
  String get letsSetThingsUp => 'Lass uns alles einrichten';

  @override
  String get getTheMostOutOfTheAppBySetting =>
      'Hole das Beste aus der App heraus, indem du einige Dinge einrichtest.';

  @override
  String get setMonthlyBudgetTitle => 'Monatliches Budget festlegen';

  @override
  String get helpUsPersonalizeYourSpending =>
      'Hilf uns, deinen Ausgabenplan zu personalisieren';

  @override
  String get enablePushNotifications => 'Push-Benachrichtigungen aktivieren';

  @override
  String get stayUpdatedOnSpending =>
      'Bleib über Ausgaben und Erinnerungen informiert';

  @override
  String get skipForNow => 'Vorerst überspringen';

  @override
  String get youCanChangeTheseLater =>
      'Du kannst diese Einstellungen jederzeit in den Einstellungen ändern.';

  @override
  String get todaysSpending => 'Heutige Ausgaben';

  @override
  String vsYesterday(String percentage) {
    return '$percentage% vs. gestern';
  }

  @override
  String get noDataForYesterday => 'Keine Daten von gestern';

  @override
  String get mostRecentPurchase => 'Letzter Kauf';

  @override
  String get ofDailyBudget => 'des täglichen\nBudgets';

  @override
  String get dailyBudget => 'Tagesbudget';

  @override
  String get topSpendingToday => 'Größte Ausgaben heute';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get total => 'Gesamt';

  @override
  String get thisMonth => 'Diesen Monat';

  @override
  String get headsUp => 'Achtung';

  @override
  String get avgDailySpend => 'Durchschn. Tagesausgaben';

  @override
  String get daysLeft => 'Verbleibende Tage';

  @override
  String get recentActivity => 'Letzte Aktivität';

  @override
  String get addExpense => 'Ausgabe hinzufügen';

  @override
  String get repeat => 'Wiederholen';

  @override
  String get setBudget => 'Budget festlegen';

  @override
  String get scanReceipt => 'Beleg\nscannen';

  @override
  String get noBudgetSetForThisMonth =>
      'Kein Budget für diesen Monat festgelegt.';

  @override
  String get youHaveExceededYourMonthlyBudget =>
      'Du hast dein monatliches Budget überschritten.';

  @override
  String get headsUpYouAreCloseToYourBudget =>
      'Achtung! Du näherst dich deinem Budget.';

  @override
  String get niceWorkYouAreStayingWithinBudget =>
      'Gut gemacht! Du bleibst im Budget 👍';

  @override
  String get spending => 'Ausgaben';

  @override
  String get trackYourSpendingStayInControl =>
      'Verfolge deine Ausgaben, behalte die Kontrolle';

  @override
  String get searchMerchantItemOrCategory =>
      'Händler, Artikel oder Kategorie suchen...';

  @override
  String spendingInsightMessage(String percentage, String category) {
    return 'Du hast diese Woche $percentage% mehr für $category ausgegeben';
  }

  @override
  String get addPurchase => 'Kauf hinzufügen';

  @override
  String get editPurchase => 'Kauf bearbeiten';

  @override
  String get title => 'Titel';

  @override
  String get date => 'Datum';

  @override
  String get category => 'Kategorie';

  @override
  String get paymentMethod => 'Zahlungsmethode';

  @override
  String get amount => 'Betrag';

  @override
  String get currency => 'Währung';

  @override
  String get pleaseEnterName => 'Bitte gib einen Namen ein';

  @override
  String get enterAmount => 'Betrag eingeben';

  @override
  String get savePurchase => 'Kauf speichern';

  @override
  String get card => 'Karte';

  @override
  String get cash => 'Bargeld';

  @override
  String get other => 'Sonstiges';

  @override
  String get filterAndSort => 'Filtern und sortieren';

  @override
  String get resetAll => 'Alle zurücksetzen';

  @override
  String get applyFilters => 'Filter anwenden';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get merchant => 'Händler';

  @override
  String get dateRange => 'Datumsbereich';

  @override
  String get noCategoriesAvailable => 'Keine Kategorien verfügbar';

  @override
  String get noMerchantsAvailable => 'Keine Händler verfügbar';

  @override
  String get noResultsFound => 'Keine Ergebnisse gefunden';

  @override
  String get noPurchasesYet => 'Noch keine Käufe';

  @override
  String get tryAdjustingFiltersOrSearch =>
      'Versuche, deine Filter oder Suche anzupassen';

  @override
  String get purchaseHistoryWillAppearHere =>
      'Dein Kaufverlauf wird hier angezeigt';

  @override
  String get clearFilters => 'Filter löschen';

  @override
  String get insight => 'Einblick';

  @override
  String get noItems => 'Keine Artikel';

  @override
  String get item => 'Artikel';

  @override
  String get items => 'Artikel';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get failedToLoadPurchase => 'Kauf konnte nicht geladen werden';

  @override
  String get avgPrice => 'Durchschn. Preis';

  @override
  String get payment => 'Zahlung';

  @override
  String get below => '↓ Darunter';

  @override
  String get above => '↑ Darüber';

  @override
  String get at => 'Bei';

  @override
  String itemInsights(String percent, String label) {
    return '↑ +$percent% vs. letzter Kauf • Durchschnittspreis $label';
  }

  @override
  String get editItem => 'Artikel bearbeiten';

  @override
  String get deleteItem => 'Artikel löschen';

  @override
  String get edited => 'Bearbeitet';

  @override
  String ofTotal(String percent) {
    return '$percent% des Gesamtbetrags';
  }

  @override
  String get sortNameAZ => 'Name (A–Z)';

  @override
  String get sortNameZA => 'Name (Z–A)';

  @override
  String get sortPriceLow => 'Preis ↑';

  @override
  String get sortPriceHigh => 'Preis ↓';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get noItemsRecorded => 'Keine Artikel erfasst';

  @override
  String get noCategoryDataAvailable => 'Keine Kategoriedaten verfügbar';

  @override
  String get sortItems => 'Artikel sortieren';

  @override
  String get view => 'Ansehen';

  @override
  String get receipt => 'Beleg';

  @override
  String get noReceiptAdded => 'Kein Beleg hinzugefügt';

  @override
  String uploadedProcessed(String date) {
    return 'Hochgeladen am $date • Verarbeitet';
  }

  @override
  String get spendingInsights => 'Ausgabenanalyse';

  @override
  String get spendingOverview => 'Ausgabenübersicht';

  @override
  String get viewByCategories => 'Nach Kategorien';

  @override
  String get keyInsights => 'Wichtige Einblicke';

  @override
  String get topSpendingCategories => 'Top-Ausgabenkategorien';

  @override
  String get spendingTrend => 'Ausgabentrend';

  @override
  String get previous => 'Vorherige';

  @override
  String get paymentMethods => 'Zahlungsmethoden';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get monthly => 'Monatlich';

  @override
  String get yearly => 'Jährlich';

  @override
  String get noDataThisPeriod => 'Keine Daten\nin diesem Zeitraum';

  @override
  String get viewAllCategories => 'Alle Kategorien anzeigen';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get savingsOpportunity => 'Sparmöglichkeit';

  @override
  String get noSpendingDataThisPeriod =>
      'Keine Ausgabendaten in diesem Zeitraum';

  @override
  String totalSpentIn(String period) {
    return 'Gesamt ausgegeben in $period';
  }

  @override
  String lessThanPrevious(String percent, String amount) {
    return '$percent% weniger als vorher ($amount)';
  }

  @override
  String moreThanPrevious(String percent, String amount) {
    return '$percent% mehr als vorher ($amount)';
  }

  @override
  String get budgetStatus => 'Budgetstatus';

  @override
  String get onTrack => 'Im Rahmen';

  @override
  String get overBudget => 'Budget überschritten';

  @override
  String ofBudget(String amount) {
    return 'von $amount Budget';
  }

  @override
  String get averagePerDay => 'Durchschnitt pro Tag';

  @override
  String get thisPeriod => 'Dieser Zeitraum';

  @override
  String get noTrendDataAvailable => 'Keine Trenddaten verfügbar';

  @override
  String get letsSignYouIn => 'Lass uns dich anmelden';

  @override
  String get signInAndStartPlanning => 'Melde dich an und beginne zu planen.';

  @override
  String get emailAddress => 'E-Mail-Adresse';

  @override
  String get enterYourMailAddress => 'Gib deine E-Mail-Adresse ein';

  @override
  String get emailIsRequired => 'E-Mail ist erforderlich';

  @override
  String get password => 'Passwort';

  @override
  String get enterYourPassword => 'Gib dein Passwort ein';

  @override
  String get passwordIsRequired => 'Passwort ist erforderlich';

  @override
  String get signIn => 'Anmelden';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String get dontHaveAnAccount => 'Noch kein Konto?';

  @override
  String get signUp => 'Registrieren';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get nameIsRequired => 'Name ist erforderlich';

  @override
  String get minimum8Characters => 'Mindestens 8 Zeichen';

  @override
  String get reEnterPassword => 'Passwort wiederholen';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get alreadyHaveAnAccount => 'Bereits ein Konto?';

  @override
  String get orSignWith => 'Oder fortfahren mit';

  @override
  String get whereDidMyMoneyGo => 'Wo ist mein Geld geblieben?';

  @override
  String get myMoney => 'Mein Geld';

  @override
  String get stopGuessingSpending =>
      'Hör auf zu raten. Electra hilft dir, jeden Ausgabe mühelos zu verfolgen.';

  @override
  String get trackWithYourVoice => 'Mit deiner Stimme verfolgen';

  @override
  String get voice => 'Stimme';

  @override
  String get voiceDescription =>
      'Sprich einfach, wir erledigen den Rest. Schnell, intelligent und super einfach.';

  @override
  String get autoCategorizeExpenses => 'Ausgaben automatisch kategorisieren';

  @override
  String get autoCategorize => 'Auto-Kategorie';

  @override
  String get autoCategorizeDescription =>
      'Electra kategorisiert deine Ausgaben automatisch, damit du dich auf das Wesentliche konzentrieren kannst.';

  @override
  String get insightsThatHelpYouSave => 'Einblicke, die dir helfen zu sparen';

  @override
  String get insightsDescription =>
      'Verstehe deine Ausgabenmuster und triff klügere finanzielle Entscheidungen.';

  @override
  String get yourDataIsSafe => 'Deine Daten sind immer sicher';

  @override
  String get safe => 'Sicher';

  @override
  String get privacyDescription =>
      'Wir halten deine Daten privat und sicher. Dein Vertrauen ist unsere Priorität.';

  @override
  String get saveMoreStressLess => 'Mehr sparen. Weniger stressen.';

  @override
  String get saveMore => 'Mehr sparen.';

  @override
  String get finalOnboardingDescription =>
      'Behalte die Kontrolle über deine Finanzen und entwickle täglich bessere Geldgewohnheiten.';

  @override
  String get skip => 'Überspringen';

  @override
  String get next => 'Weiter';

  @override
  String get letsGo => 'Los geht\'s';

  @override
  String get spendingDetails => 'Ausgabendetails';

  @override
  String get share => 'Teilen';

  @override
  String get export => 'Exportieren';

  @override
  String get deletePurchase => 'Kauf löschen';

  @override
  String get deletePurchaseTitle => 'Kauf löschen?';

  @override
  String get deletePurchaseDescription =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get premiumFeature => 'Premium-Funktion';

  @override
  String get savingChanges => 'Änderungen werden gespeichert…';

  @override
  String get sortNewest => 'Neueste zuerst';

  @override
  String get sortOldest => 'Älteste zuerst';

  @override
  String get sortMostExpensive => 'Teuerste zuerst';

  @override
  String get sortCheapest => 'Günstigste zuerst';

  @override
  String get sortByName => 'Nach Name';

  @override
  String get categoryFood => 'Lebensmittel';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHousing => 'Wohnen';

  @override
  String get categoryBills => 'Rechnungen';

  @override
  String get categorySubscriptions => 'Abonnements';

  @override
  String get categoryShopping => 'Einkaufen';

  @override
  String get categoryHealth => 'Gesundheit';

  @override
  String get categoryEntertainment => 'Unterhaltung';

  @override
  String get categoryTravel => 'Reisen';

  @override
  String get categoryEducation => 'Bildung';

  @override
  String get categoryPersonal => 'Persönlich';

  @override
  String get categoryGifts => 'Geschenke';

  @override
  String get categoryDonations => 'Spenden';

  @override
  String get categoryOther => 'Sonstiges';

  @override
  String get selectCategory => 'Kategorie auswählen';

  @override
  String get searchCategories => 'Kategorien suchen...';

  @override
  String noCategoriesFoundFor(String query) {
    return 'Keine Kategorien für \"$query\" gefunden';
  }

  @override
  String itemWillBePermanentlyRemoved(String itemName) {
    return '\"$itemName\" wird dauerhaft aus diesem Kauf entfernt.';
  }

  @override
  String get itemName => 'Artikelname';

  @override
  String get itemNameHint => 'z.B. Rindfleisch, Milch, Shampoo';

  @override
  String get unitPrice => 'Stückpreis';

  @override
  String get required => 'Pflichtfeld';

  @override
  String get invalid => 'Ungültig';

  @override
  String get quantityShort => 'Mge';

  @override
  String get minimumOne => 'Min 1';

  @override
  String get home => 'Start';

  @override
  String get insights => 'Einblicke';

  @override
  String get profile => 'Profil';

  @override
  String get selectDateRange => 'Datumsbereich auswählen';

  @override
  String get premium => 'Premium';

  @override
  String get subscription => 'Abonnement';

  @override
  String get manualEntry => 'Manuelle Eingabe';

  @override
  String get enterDetailsManually => 'Details manuell eingeben';

  @override
  String get voiceInput => 'Spracheingabe';

  @override
  String get addBySpeaking => 'Per Sprache hinzufügen';

  @override
  String get snapPhotoOfReceipt => 'Foto deiner Quittung machen';

  @override
  String get all => 'Alle';
}
