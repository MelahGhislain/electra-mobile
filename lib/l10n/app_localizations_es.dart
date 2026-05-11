// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Electra';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsData => 'Datos';

  @override
  String get settingsHelp => 'Ayuda';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsBudget => 'Presupuesto e Ingresos';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsCurrency => 'Moneda';

  @override
  String get settingsNotifications => 'Notificaciones push';

  @override
  String get settingsNotificationsSubtitle =>
      'Recibe recordatorios y alertas de gastos';

  @override
  String get settingsExportData => 'Exportar datos';

  @override
  String get settingsExportDataSubtitle => 'Exporta tus datos';

  @override
  String get settingsSharedAccount => 'Cuenta compartida';

  @override
  String get settingsSharedAccountSubtitle =>
      'Gestionar configuración de cuenta compartida';

  @override
  String get settingsSupport => 'Soporte';

  @override
  String get settingsSupportSubtitle =>
      'Contacta con nuestro equipo de soporte';

  @override
  String get settingsDocs => 'Documentación';

  @override
  String get settingsDocsSubtitle => 'Aprende a usar la aplicación';

  @override
  String get settingsSuggest => 'Sugerir una mejora';

  @override
  String get settingsSuggestSubtitle => 'Comparte tu opinión para ayudarnos';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsSetupGuide => 'Guía de configuración';

  @override
  String get settingsSetupGuideSubtitle => '¿Nuevo aquí? Empieza por aquí';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Eliminar permanentemente tu cuenta';

  @override
  String get budgetNotSet => 'No definido';

  @override
  String budgetPerMonth(String amount) {
    return '$amount / mes';
  }

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get languageSystemDefault => 'Predeterminado del sistema';

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
  String get logoutTitle => '¿Cerrar sesión?';

  @override
  String get logoutBody => 'Se cerrará tu sesión.';

  @override
  String get logoutConfirm => 'Cerrar sesión';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get retry => 'Intentar de nuevo';

  @override
  String get deleteAccountTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountBody =>
      'Esto eliminará permanentemente tu cuenta y todos tus datos. Esta acción no se puede deshacer.';

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingLetsGo => '¡Vamos!';

  @override
  String homeGreeting(String name) {
    return 'Hola $name';
  }

  @override
  String get homeTagline => 'Toma el control\nde tu día';

  @override
  String get homeSpendingBreakdown => 'Desglose de gastos';

  @override
  String get homeMonthlySnapshot => 'Resumen mensual';

  @override
  String get homeRecentlyCompleted => 'Completado recientemente';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String homeAvgDaily(String amount) {
    return 'Gasto diario medio: $amount';
  }

  @override
  String get homeBudgetGood =>
      '¡Bien hecho! Te mantienes dentro del presupuesto 👍';

  @override
  String get homeBudgetWarning =>
      '¡Atención! Te estás acercando a tu presupuesto.';

  @override
  String get homeBudgetOver => 'Has superado tu presupuesto mensual.';

  @override
  String get homeBudgetNone => 'Sin presupuesto definido para este mes.';

  @override
  String get insightsTitle => 'Análisis de gastos';

  @override
  String get insightsPeriodWeekly => 'Semanal';

  @override
  String get insightsPeriodMonthly => 'Mensual';

  @override
  String get insightsPeriodYearly => 'Anual';

  @override
  String insightsTotalSpent(String period) {
    return 'Total gastado en $period';
  }

  @override
  String get insightsBudgetOnTrack => 'En camino';

  @override
  String get insightsBudgetOver => 'Presupuesto superado';

  @override
  String get insightsSpendingOverview => 'Resumen de gastos';

  @override
  String get insightsViewByCategories => 'Por categorías';

  @override
  String get insightsViewAllCategories => 'Ver todas las categorías';

  @override
  String get insightsKeyInsights => 'Puntos clave';

  @override
  String get insightsTopCategories => 'Principales categorías';

  @override
  String get insightsViewAll => 'Ver todo';

  @override
  String get insightsTrend => 'Tendencia de gastos';

  @override
  String get errorGeneric => 'Algo salió mal';

  @override
  String get errorNetwork => 'Sin conexión. Comprueba tu red.';

  @override
  String get errorSessionExpired =>
      'Tu sesión ha expirado. Inicia sesión de nuevo.';
}
