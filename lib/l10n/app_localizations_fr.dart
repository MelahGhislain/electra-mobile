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
  String get settingsSupport => 'Support';

  @override
  String get settingsSupportSubtitle => 'Contacter notre équipe de support';

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
  String get settingsSetupGuideSubtitle => 'Nouveau ? Commencez par ici';

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
  String get languageSystemDefault => 'Par défaut du système';

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
  String get logoutTitle => 'Se déconnecter ?';

  @override
  String get logoutBody => 'Vous serez déconnecté de votre compte.';

  @override
  String get logoutConfirm => 'Se déconnecter';

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
  String get retry => 'Réessayer';

  @override
  String get deleteAccountTitle => 'Supprimer le compte ?';

  @override
  String get deleteAccountBody =>
      'Cela supprimera définitivement votre compte et toutes vos données. Cette action est irréversible.';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingLetsGo => 'Allons-y';

  @override
  String homeGreeting(String name) {
    return 'Bonjour $name';
  }

  @override
  String get homeTagline => 'Prenez le contrôle\nde votre journée';

  @override
  String get homeSpendingBreakdown => 'Répartition des dépenses';

  @override
  String get homeMonthlySnapshot => 'Aperçu mensuel';

  @override
  String get homeRecentlyCompleted => 'Récemment complété';

  @override
  String get homeViewAll => 'Voir tout';

  @override
  String homeAvgDaily(String amount) {
    return 'Dépense journalière moy. : $amount';
  }

  @override
  String get homeBudgetGood => 'Bravo ! Vous respectez votre budget 👍';

  @override
  String get homeBudgetWarning => 'Attention ! Vous approchez de votre budget.';

  @override
  String get homeBudgetOver => 'Vous avez dépassé votre budget mensuel.';

  @override
  String get homeBudgetNone => 'Aucun budget défini pour ce mois.';

  @override
  String get insightsTitle => 'Analyses des dépenses';

  @override
  String get insightsPeriodWeekly => 'Hebdomadaire';

  @override
  String get insightsPeriodMonthly => 'Mensuel';

  @override
  String get insightsPeriodYearly => 'Annuel';

  @override
  String insightsTotalSpent(String period) {
    return 'Total dépensé en $period';
  }

  @override
  String get insightsBudgetOnTrack => 'Dans les limites';

  @override
  String get insightsBudgetOver => 'Dépassement';

  @override
  String get insightsSpendingOverview => 'Aperçu des dépenses';

  @override
  String get insightsViewByCategories => 'Par catégories';

  @override
  String get insightsViewAllCategories => 'Voir toutes les catégories';

  @override
  String get insightsKeyInsights => 'Points clés';

  @override
  String get insightsTopCategories => 'Top catégories';

  @override
  String get insightsViewAll => 'Voir tout';

  @override
  String get insightsTrend => 'Tendance des dépenses';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get errorNetwork => 'Connexion impossible. Vérifiez votre réseau.';

  @override
  String get errorSessionExpired => 'Votre session a expiré. Reconnectez-vous.';
}
