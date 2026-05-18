// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Electra';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsData => 'Données';

  @override
  String get settingsHelp => 'Aide';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsBudget => 'Budget & Revenus';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsCurrency => 'Devise';

  @override
  String get settingsNotifications => 'Notifications push';

  @override
  String get settingsNotificationsSubtitle =>
      'Recevez des rappels et des alertes de dépenses';

  @override
  String get settingsExportData => 'Exporter les données';

  @override
  String get settingsExportDataSubtitle => 'Exportez vos données';

  @override
  String get settingsSharedAccount => 'Compte partagé';

  @override
  String get settingsSharedAccountSubtitle =>
      'Gérer les paramètres du compte partagé';

  @override
  String get settingsSupport => 'Assistance';

  @override
  String get settingsSupportSubtitle => 'Contacter notre équipe d\'assistance';

  @override
  String get settingsDocs => 'Documentation';

  @override
  String get settingsDocsSubtitle => 'Apprenez à utiliser l\'application';

  @override
  String get settingsSuggest => 'Suggérer une amélioration';

  @override
  String get settingsSuggestSubtitle => 'Partagez vos retours pour nous aider';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSetupGuide => 'Guide de configuration';

  @override
  String get settingsSetupGuideSubtitle => 'Nouveau ici ? Commencez par ici';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Supprimer définitivement votre compte';

  @override
  String get budgetNotSet => 'Non défini';

  @override
  String budgetPerMonth(String amount) {
    return '$amount / mois';
  }

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get languageSystemDefault => 'Langue du système';

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
  String get logoutTitle => 'Se déconnecter';

  @override
  String get logoutBody =>
      'Êtes-vous sûr de vouloir vous déconnecter de votre compte ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get enterYourName => 'Entrez votre nom';

  @override
  String get nameCannotBeEmpty => 'Le nom ne peut pas être vide';

  @override
  String get nameTooShort => 'Le nom est trop court';

  @override
  String get email => 'E-mail';

  @override
  String get enterYourEmail => 'Entrez votre adresse e-mail';

  @override
  String get emailCannotBeEmpty => 'L\'e-mail ne peut pas être vide';

  @override
  String get enterValidEmail => 'Entrez une adresse e-mail valide';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get monthlyBudget => 'Budget mensuel';

  @override
  String get budgetSubtitle =>
      'Définissez une limite mensuelle pour rester dans les clous.';

  @override
  String get budgetAmount => 'Montant du budget';

  @override
  String get enterBudgetAmount => 'Entrez le montant du budget';

  @override
  String get pleaseEnterABudgetAmount => 'Veuillez entrer un montant de budget';

  @override
  String get enterAValidAmountGreaterThan0 =>
      'Entrez un montant valide supérieur à 0';

  @override
  String get budgetSeemsTooHigh =>
      'Le budget semble trop élevé — veuillez vérifier';

  @override
  String get quickSelect => 'Sélection rapide';

  @override
  String get saveBudget => 'Enregistrer le budget';

  @override
  String get removeBudget => 'Supprimer le budget';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountBody =>
      'Cette action est permanente et irréversible. Toutes vos données, achats et paramètres seront supprimés.';

  @override
  String deleteAccountConfirmationMessage(String keyword) {
    return 'Tapez $keyword ci-dessous pour confirmer que vous comprenez que c\'est irréversible.';
  }

  @override
  String typeDeleteHere(String keyword) {
    return 'Tapez $keyword ici';
  }

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingLetsGo => 'C\'est parti';

  @override
  String homeGreeting(String name) {
    return 'Bonjour $name';
  }

  @override
  String get homeYoureSpendingLessThanUsual =>
      'Vous dépensez moins que d\'habitude. Bravo !';

  @override
  String get letsSetThingsUp => 'Configurons les choses';

  @override
  String get getTheMostOutOfTheAppBySetting =>
      'Profitez au maximum de l\'application en configurant quelques éléments.';

  @override
  String get setMonthlyBudgetTitle => 'Définir votre budget mensuel';

  @override
  String get helpUsPersonalizeYourSpending =>
      'Aidez-nous à personnaliser votre plan de dépenses';

  @override
  String get enablePushNotifications => 'Activer les notifications push';

  @override
  String get stayUpdatedOnSpending =>
      'Restez informé de vos dépenses et rappels';

  @override
  String get skipForNow => 'Passer pour l\'instant';

  @override
  String get youCanChangeTheseLater =>
      'Vous pouvez toujours modifier ces paramètres dans Paramètres.';

  @override
  String get todaysSpending => 'Dépenses du jour';

  @override
  String vsYesterday(String percentage) {
    return '$percentage% vs hier';
  }

  @override
  String get noDataForYesterday => 'Aucune donnée pour hier';

  @override
  String get mostRecentPurchase => 'Achat le plus récent';

  @override
  String get ofDailyBudget => 'du budget\nquotidien';

  @override
  String get dailyBudget => 'Budget quotidien';

  @override
  String get mostRecentSpending => 'Dépenses les plus récentes';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get total => 'Total';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get headsUp => 'Attention';

  @override
  String get avgDailySpend => 'Dép. quotidienne moy.';

  @override
  String get daysLeft => 'Jours restants';

  @override
  String get recentActivity => 'Activité récente';

  @override
  String get addExpense => 'Ajouter une dépense';

  @override
  String get repeat => 'Répéter';

  @override
  String get setBudget => 'Définir un budget';

  @override
  String get scanReceipt => 'Scanner\nle reçu';

  @override
  String get noBudgetSetForThisMonth => 'Aucun budget défini pour ce mois.';

  @override
  String get youHaveExceededYourMonthlyBudget =>
      'Vous avez dépassé votre budget mensuel.';

  @override
  String get headsUpYouAreCloseToYourBudget =>
      'Attention ! Vous approchez de votre budget.';

  @override
  String get niceWorkYouAreStayingWithinBudget =>
      'Bravo ! Vous respectez votre budget 👍';

  @override
  String get spending => 'Dépenses';

  @override
  String get trackYourSpendingStayInControl =>
      'Suivez vos dépenses, restez maître de vos finances';

  @override
  String get searchMerchantItemOrCategory =>
      'Rechercher un marchand, article ou catégorie...';

  @override
  String spendingInsightMessage(String percentage, String category) {
    return 'Vous avez dépensé $percentage% de plus en $category cette semaine';
  }

  @override
  String get addPurchase => 'Ajouter un achat';

  @override
  String get editPurchase => 'Modifier l\'achat';

  @override
  String get title => 'Titre';

  @override
  String get date => 'Date';

  @override
  String get category => 'Catégorie';

  @override
  String get paymentMethod => 'Mode de paiement';

  @override
  String get amount => 'Montant';

  @override
  String get currency => 'Devise';

  @override
  String get pleaseEnterName => 'Veuillez entrer un nom';

  @override
  String get enterAmount => 'Entrez un montant';

  @override
  String get savePurchase => 'Enregistrer l\'achat';

  @override
  String get card => 'Carte';

  @override
  String get cash => 'Espèces';

  @override
  String get other => 'Autre';

  @override
  String get filterAndSort => 'Filtrer et trier';

  @override
  String get resetAll => 'Tout réinitialiser';

  @override
  String get applyFilters => 'Appliquer les filtres';

  @override
  String get sortBy => 'Trier par';

  @override
  String get merchant => 'Marchand';

  @override
  String get dateRange => 'Plage de dates';

  @override
  String get noCategoriesAvailable => 'Aucune catégorie disponible';

  @override
  String get noMerchantsAvailable => 'Aucun marchand disponible';

  @override
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String get noPurchasesYet => 'Aucun achat pour l\'instant';

  @override
  String get tryAdjustingFiltersOrSearch =>
      'Essayez d\'ajuster vos filtres ou votre recherche';

  @override
  String get purchaseHistoryWillAppearHere =>
      'Votre historique d\'achats apparaîtra ici';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get insight => 'Analyse';

  @override
  String get noItems => 'Aucun article';

  @override
  String get item => 'Article';

  @override
  String get items => 'Articles';

  @override
  String get unknown => 'Inconnu';

  @override
  String get failedToLoadPurchase => 'Échec du chargement de l\'achat';

  @override
  String get avgPrice => 'Prix moy.';

  @override
  String get payment => 'Paiement';

  @override
  String get below => '↓ En dessous';

  @override
  String get above => '↑ Au-dessus';

  @override
  String get at => 'À';

  @override
  String itemInsights(String percent, String label) {
    return '↑ +$percent% vs dernier achat • prix moyen $label';
  }

  @override
  String get editItem => 'Modifier l\'article';

  @override
  String get deleteItem => 'Supprimer l\'article';

  @override
  String get edited => 'Modifié';

  @override
  String ofTotal(String percent) {
    return '$percent% du total';
  }

  @override
  String get sortNameAZ => 'Nom (A–Z)';

  @override
  String get sortNameZA => 'Nom (Z–A)';

  @override
  String get sortPriceLow => 'Prix ↑';

  @override
  String get sortPriceHigh => 'Prix ↓';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get noItemsRecorded => 'Aucun article enregistré';

  @override
  String get noCategoryDataAvailable => 'Aucune donnée de catégorie disponible';

  @override
  String get sortItems => 'Trier les articles';

  @override
  String get view => 'Voir';

  @override
  String get receipt => 'Reçu';

  @override
  String get noReceiptAdded => 'Aucun reçu ajouté';

  @override
  String uploadedProcessed(String date) {
    return 'Téléchargé le $date • Traité';
  }

  @override
  String get spendingInsights => 'Analyses des dépenses';

  @override
  String get spendingOverview => 'Aperçu des dépenses';

  @override
  String viewByCategories(String group) {
    return 'Par $group';
  }

  @override
  String get keyInsights => 'Points clés';

  @override
  String get topSpendingCategories => 'Principales catégories de dépenses';

  @override
  String get spendingTrend => 'Tendance des dépenses';

  @override
  String get previous => 'Précédent';

  @override
  String get paymentMethods => 'Modes de paiement';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get noDataThisPeriod => 'Aucune donnée\ncette période';

  @override
  String get viewAllCategories => 'Voir toutes les catégories';

  @override
  String get somethingWentWrong => 'Une erreur est survenue';

  @override
  String get savingsOpportunity => 'Opportunité d\'épargne';

  @override
  String get noSpendingDataThisPeriod =>
      'Aucune donnée de dépense cette période';

  @override
  String totalSpentIn(String period) {
    return 'Total dépensé en $period';
  }

  @override
  String lessThanPrevious(String percent, String amount) {
    return '$percent% de moins que précédemment ($amount)';
  }

  @override
  String moreThanPrevious(String percent, String amount) {
    return '$percent% de plus que précédemment ($amount)';
  }

  @override
  String get budgetStatus => 'Statut du budget';

  @override
  String get onTrack => 'Dans les limites';

  @override
  String get overBudget => 'Dépassement de budget';

  @override
  String ofBudget(String amount) {
    return 'sur $amount de budget';
  }

  @override
  String get averagePerDay => 'Moyenne par jour';

  @override
  String get thisPeriod => 'Cette période';

  @override
  String get noTrendDataAvailable => 'Aucune tendance disponible';

  @override
  String get letsSignYouIn => 'Connectons-nous';

  @override
  String get signInAndStartPlanning =>
      'Connectez-vous et commencez à planifier.';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get enterYourMailAddress => 'Entrez votre adresse e-mail';

  @override
  String get emailIsRequired => 'L\'e-mail est requis';

  @override
  String get password => 'Mot de passe';

  @override
  String get enterYourPassword => 'Entrez votre mot de passe';

  @override
  String get passwordIsRequired => 'Le mot de passe est requis';

  @override
  String get signIn => 'Se connecter';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get dontHaveAnAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get fullName => 'Nom complet';

  @override
  String get nameIsRequired => 'Le nom est requis';

  @override
  String get minimum8Characters => 'Minimum 8 caractères';

  @override
  String get reEnterPassword => 'Ressaisir le mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get alreadyHaveAnAccount => 'Vous avez déjà un compte ?';

  @override
  String get orSignWith => 'Ou continuer avec';

  @override
  String get whereDidMyMoneyGo => 'Où est passé mon argent ?';

  @override
  String get myMoney => 'Mon argent';

  @override
  String get stopGuessingSpending =>
      'Arrêtez de deviner vos dépenses. Electra vous aide à suivre chaque dépense sans effort.';

  @override
  String get trackWithYourVoice => 'Suivez avec votre voix';

  @override
  String get voice => 'Voix';

  @override
  String get voiceDescription =>
      'Parlez simplement, nous nous occupons du reste. Rapide, intelligent et très simple.';

  @override
  String get autoCategorizeExpenses => 'Catégorisation automatique';

  @override
  String get autoCategorize => 'Auto-catégorie';

  @override
  String get autoCategorizeDescription =>
      'Electra catégorise automatiquement vos dépenses pour que vous puissiez vous concentrer sur l\'essentiel.';

  @override
  String get insightsThatHelpYouSave => 'Des analyses pour mieux épargner';

  @override
  String get insightsDescription =>
      'Comprenez vos habitudes de dépenses et prenez de meilleures décisions financières.';

  @override
  String get yourDataIsSafe => 'Vos données sont toujours en sécurité';

  @override
  String get safe => 'Sécurisé';

  @override
  String get privacyDescription =>
      'Nous gardons vos données privées et sécurisées. Votre confiance est notre priorité.';

  @override
  String get saveMoreStressLess => 'Économisez plus. Stressez moins.';

  @override
  String get saveMore => 'Économisez plus.';

  @override
  String get finalOnboardingDescription =>
      'Gardez le contrôle de vos finances et développez de meilleures habitudes financières chaque jour.';

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get letsGo => 'C\'est parti';

  @override
  String get spendingDetails => 'Détails des dépenses';

  @override
  String get share => 'Partager';

  @override
  String get export => 'Exporter';

  @override
  String get deletePurchase => 'Supprimer l\'achat';

  @override
  String get deletePurchaseTitle => 'Supprimer l\'achat ?';

  @override
  String get deletePurchaseDescription => 'Cette action est irréversible.';

  @override
  String get premiumFeature => 'Fonctionnalité Premium';

  @override
  String get savingChanges => 'Enregistrement…';

  @override
  String get sortNewest => 'Plus récent en premier';

  @override
  String get sortOldest => 'Plus ancien en premier';

  @override
  String get sortMostExpensive => 'Plus cher';

  @override
  String get sortCheapest => 'Moins cher';

  @override
  String get sortByName => 'Par nom';

  @override
  String get categoryFood => 'Alimentation';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHousing => 'Logement';

  @override
  String get categoryBills => 'Factures';

  @override
  String get categorySubscriptions => 'Abonnements';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryHealth => 'Santé';

  @override
  String get categoryEntertainment => 'Loisirs';

  @override
  String get categoryTravel => 'Voyages';

  @override
  String get categoryEducation => 'Éducation';

  @override
  String get categoryPersonal => 'Personnel';

  @override
  String get categoryGifts => 'Cadeaux';

  @override
  String get categoryDonations => 'Dons';

  @override
  String get categoryOther => 'Autre';

  @override
  String get selectCategory => 'Sélectionner une catégorie';

  @override
  String get searchCategories => 'Rechercher des catégories...';

  @override
  String noCategoriesFoundFor(String query) {
    return 'Aucune catégorie trouvée pour \"$query\"';
  }

  @override
  String itemWillBePermanentlyRemoved(String itemName) {
    return '« $itemName » sera définitivement supprimé de cet achat.';
  }

  @override
  String get itemName => 'Nom de l\'article';

  @override
  String get itemNameHint => 'ex. Bœuf, Lait, Shampooing';

  @override
  String get unitPrice => 'Prix unitaire';

  @override
  String get required => 'Requis';

  @override
  String get invalid => 'Invalide';

  @override
  String get quantityShort => 'Qté';

  @override
  String get minimumOne => 'Min 1';

  @override
  String get home => 'Accueil';

  @override
  String get insights => 'Analyses';

  @override
  String get profile => 'Profil';

  @override
  String get selectDateRange => 'Sélectionner une plage de dates';

  @override
  String get premium => 'Premium';

  @override
  String get subscription => 'Abonnement';

  @override
  String get manualEntry => 'Saisie manuelle';

  @override
  String get enterDetailsManually => 'Saisir les détails manuellement';

  @override
  String get voiceInput => 'Saisie vocale';

  @override
  String get addBySpeaking => 'Ajouter par voix';

  @override
  String get snapPhotoOfReceipt => 'Prendre une photo de votre reçu';

  @override
  String get all => 'Tous';

  @override
  String get categories => 'Catégories';

  @override
  String get merchants => 'Marchands';
}
