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
  String get settingsBudget => 'Presupuesto e ingresos';

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
  String get settingsSupportSubtitle => 'Contactar a nuestro equipo de soporte';

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
  String get settingsSetupGuideSubtitle => '¿Eres nuevo? Empieza aquí';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Eliminar permanentemente tu cuenta';

  @override
  String get budgetNotSet => 'No establecido';

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
  String get languageSystemDefault => 'Idioma del sistema';

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
  String get logoutTitle => 'Cerrar sesión';

  @override
  String get logoutBody =>
      '¿Estás seguro de que deseas cerrar sesión en tu cuenta?';

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
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get enterYourName => 'Ingresa tu nombre';

  @override
  String get nameCannotBeEmpty => 'El nombre no puede estar vacío';

  @override
  String get nameTooShort => 'El nombre es demasiado corto';

  @override
  String get email => 'Correo electrónico';

  @override
  String get enterYourEmail => 'Ingresa tu correo electrónico';

  @override
  String get emailCannotBeEmpty => 'El correo no puede estar vacío';

  @override
  String get enterValidEmail => 'Ingresa un correo electrónico válido';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get monthlyBudget => 'Presupuesto mensual';

  @override
  String get budgetSubtitle =>
      'Establece un límite de gasto mensual para mantenerte al día.';

  @override
  String get budgetAmount => 'Monto del presupuesto';

  @override
  String get enterBudgetAmount => 'Ingresa el monto del presupuesto';

  @override
  String get pleaseEnterABudgetAmount =>
      'Por favor ingresa un monto de presupuesto';

  @override
  String get enterAValidAmountGreaterThan0 =>
      'Ingresa un monto válido mayor a 0';

  @override
  String get budgetSeemsTooHigh =>
      'El presupuesto parece demasiado alto — por favor verifica';

  @override
  String get quickSelect => 'Selección rápida';

  @override
  String get saveBudget => 'Guardar presupuesto';

  @override
  String get removeBudget => 'Eliminar presupuesto';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountBody =>
      'Esta acción es permanente y no se puede deshacer. Todos tus datos, compras y configuraciones serán eliminados.';

  @override
  String deleteAccountConfirmationMessage(String keyword) {
    return 'Escribe $keyword abajo para confirmar que entiendes que esto es irreversible.';
  }

  @override
  String typeDeleteHere(String keyword) {
    return 'Escribe $keyword aquí';
  }

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingLetsGo => '¡Vamos!';

  @override
  String homeGreeting(String name) {
    return 'Hola $name';
  }

  @override
  String get homeYoureSpendingLessThanUsual =>
      'Estás gastando menos de lo habitual. ¡Buen trabajo!';

  @override
  String get letsSetThingsUp => 'Vamos a configurar todo';

  @override
  String get getTheMostOutOfTheAppBySetting =>
      'Aprovecha al máximo la aplicación configurando algunas cosas.';

  @override
  String get setMonthlyBudgetTitle => 'Establece tu presupuesto mensual';

  @override
  String get helpUsPersonalizeYourSpending =>
      'Ayúdanos a personalizar tu plan de gastos';

  @override
  String get enablePushNotifications => 'Activar notificaciones push';

  @override
  String get stayUpdatedOnSpending =>
      'Mantente al día con tus gastos y recordatorios';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get youCanChangeTheseLater =>
      'Siempre puedes cambiar esto más tarde en Ajustes.';

  @override
  String get todaysSpending => 'Gastos de hoy';

  @override
  String vsYesterday(String percentage) {
    return '$percentage% vs ayer';
  }

  @override
  String get noDataForYesterday => 'Sin datos de ayer';

  @override
  String get mostRecentPurchase => 'Compra más reciente';

  @override
  String get ofDailyBudget => 'del presupuesto\ndiario';

  @override
  String get dailyBudget => 'Presupuesto diario';

  @override
  String get topSpendingToday => 'Principales gastos de hoy';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get total => 'Total';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get headsUp => 'Atención';

  @override
  String get avgDailySpend => 'Gasto diario prom.';

  @override
  String get daysLeft => 'Días restantes';

  @override
  String get recentActivity => 'Actividad reciente';

  @override
  String get addExpense => 'Agregar gasto';

  @override
  String get repeat => 'Repetir';

  @override
  String get setBudget => 'Establecer presupuesto';

  @override
  String get scanReceipt => 'Escanear\nrecibo';

  @override
  String get noBudgetSetForThisMonth =>
      'No hay presupuesto definido para este mes.';

  @override
  String get youHaveExceededYourMonthlyBudget =>
      'Has excedido tu presupuesto mensual.';

  @override
  String get headsUpYouAreCloseToYourBudget =>
      '¡Atención! Estás cerca de tu presupuesto.';

  @override
  String get niceWorkYouAreStayingWithinBudget =>
      '¡Buen trabajo! Te mantienes dentro del presupuesto 👍';

  @override
  String get spending => 'Gastos';

  @override
  String get trackYourSpendingStayInControl =>
      'Controla tus gastos, mantén el control';

  @override
  String get searchMerchantItemOrCategory =>
      'Buscar comerciante, artículo o categoría...';

  @override
  String spendingInsightMessage(String percentage, String category) {
    return 'Gastaste $percentage% más en $category esta semana';
  }

  @override
  String get addPurchase => 'Agregar compra';

  @override
  String get editPurchase => 'Editar compra';

  @override
  String get title => 'Título';

  @override
  String get date => 'Fecha';

  @override
  String get category => 'Categoría';

  @override
  String get paymentMethod => 'Método de pago';

  @override
  String get amount => 'Monto';

  @override
  String get currency => 'Moneda';

  @override
  String get pleaseEnterName => 'Por favor ingresa un nombre';

  @override
  String get enterAmount => 'Ingresa un monto';

  @override
  String get savePurchase => 'Guardar compra';

  @override
  String get card => 'Tarjeta';

  @override
  String get cash => 'Efectivo';

  @override
  String get other => 'Otro';

  @override
  String get filterAndSort => 'Filtrar y ordenar';

  @override
  String get resetAll => 'Restablecer todo';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get merchant => 'Comerciante';

  @override
  String get dateRange => 'Rango de fechas';

  @override
  String get noCategoriesAvailable => 'No hay categorías disponibles';

  @override
  String get noMerchantsAvailable => 'No hay comerciantes disponibles';

  @override
  String get noResultsFound => 'No se encontraron resultados';

  @override
  String get noPurchasesYet => 'Aún no hay compras';

  @override
  String get tryAdjustingFiltersOrSearch =>
      'Intenta ajustar tus filtros o búsqueda';

  @override
  String get purchaseHistoryWillAppearHere =>
      'Tu historial de compras aparecerá aquí';

  @override
  String get clearFilters => 'Borrar filtros';

  @override
  String get insight => 'Análisis';

  @override
  String get noItems => 'Sin artículos';

  @override
  String get item => 'Artículo';

  @override
  String get items => 'Artículos';

  @override
  String get unknown => 'Desconocido';

  @override
  String get failedToLoadPurchase => 'Error al cargar la compra';

  @override
  String get avgPrice => 'Precio prom.';

  @override
  String get payment => 'Pago';

  @override
  String get below => '↓ Por debajo';

  @override
  String get above => '↑ Por encima';

  @override
  String get at => 'En';

  @override
  String itemInsights(String percent, String label) {
    return '↑ +$percent% vs última compra • precio promedio $label';
  }

  @override
  String get editItem => 'Editar artículo';

  @override
  String get deleteItem => 'Eliminar artículo';

  @override
  String get edited => 'Editado';

  @override
  String ofTotal(String percent) {
    return '$percent% del total';
  }

  @override
  String get sortNameAZ => 'Nombre (A–Z)';

  @override
  String get sortNameZA => 'Nombre (Z–A)';

  @override
  String get sortPriceLow => 'Precio ↑';

  @override
  String get sortPriceHigh => 'Precio ↓';

  @override
  String get addItem => 'Agregar artículo';

  @override
  String get noItemsRecorded => 'No se han registrado artículos';

  @override
  String get noCategoryDataAvailable => 'No hay datos de categoría disponibles';

  @override
  String get sortItems => 'Ordenar artículos';

  @override
  String get view => 'Ver';

  @override
  String get receipt => 'Recibo';

  @override
  String get noReceiptAdded => 'No se ha agregado recibo';

  @override
  String uploadedProcessed(String date) {
    return 'Subido el $date • Procesado';
  }

  @override
  String get spendingInsights => 'Análisis de gastos';

  @override
  String get spendingOverview => 'Resumen de gastos';

  @override
  String get viewByCategories => 'Por categorías';

  @override
  String get keyInsights => 'Puntos clave';

  @override
  String get topSpendingCategories => 'Principales categorías de gasto';

  @override
  String get spendingTrend => 'Tendencia de gastos';

  @override
  String get previous => 'Anterior';

  @override
  String get paymentMethods => 'Métodos de pago';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensual';

  @override
  String get yearly => 'Anual';

  @override
  String get noDataThisPeriod => 'Sin datos\nen este período';

  @override
  String get viewAllCategories => 'Ver todas las categorías';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get savingsOpportunity => 'Oportunidad de ahorro';

  @override
  String get noSpendingDataThisPeriod => 'Sin datos de gastos en este período';

  @override
  String totalSpentIn(String period) {
    return 'Total gastado en $period';
  }

  @override
  String lessThanPrevious(String percent, String amount) {
    return '$percent% menos que el período anterior ($amount)';
  }

  @override
  String moreThanPrevious(String percent, String amount) {
    return '$percent% más que el período anterior ($amount)';
  }

  @override
  String get budgetStatus => 'Estado del presupuesto';

  @override
  String get onTrack => 'En camino';

  @override
  String get overBudget => 'Presupuesto excedido';

  @override
  String ofBudget(String amount) {
    return 'de $amount de presupuesto';
  }

  @override
  String get averagePerDay => 'Promedio por día';

  @override
  String get thisPeriod => 'Este período';

  @override
  String get noTrendDataAvailable => 'No hay datos de tendencia disponibles';

  @override
  String get letsSignYouIn => 'Iniciemos sesión';

  @override
  String get signInAndStartPlanning => 'Inicia sesión y comienza a planificar.';

  @override
  String get emailAddress => 'Dirección de correo electrónico';

  @override
  String get enterYourMailAddress => 'Ingresa tu dirección de correo';

  @override
  String get emailIsRequired => 'El correo es requerido';

  @override
  String get password => 'Contraseña';

  @override
  String get enterYourPassword => 'Ingresa tu contraseña';

  @override
  String get passwordIsRequired => 'La contraseña es requerida';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get dontHaveAnAccount => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get nameIsRequired => 'El nombre es requerido';

  @override
  String get minimum8Characters => 'Mínimo 8 caracteres';

  @override
  String get reEnterPassword => 'Volver a ingresar contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get alreadyHaveAnAccount => '¿Ya tienes una cuenta?';

  @override
  String get orSignWith => 'O continuar con';

  @override
  String get whereDidMyMoneyGo => '¿A dónde fue mi dinero?';

  @override
  String get myMoney => 'Mi dinero';

  @override
  String get stopGuessingSpending =>
      'Deja de adivinar tus gastos. Electra te ayuda a registrar cada gasto sin esfuerzo.';

  @override
  String get trackWithYourVoice => 'Registra con tu voz';

  @override
  String get voice => 'Voz';

  @override
  String get voiceDescription =>
      'Solo habla y nosotros nos encargamos del resto. Rápido, inteligente y muy fácil.';

  @override
  String get autoCategorizeExpenses => 'Categorización automática';

  @override
  String get autoCategorize => 'Auto-categoría';

  @override
  String get autoCategorizeDescription =>
      'Electra categoriza automáticamente tus gastos para que puedas centrarte en lo que importa.';

  @override
  String get insightsThatHelpYouSave => 'Análisis que te ayudan a ahorrar';

  @override
  String get insightsDescription =>
      'Entiende tus patrones de gasto y toma decisiones financieras más inteligentes.';

  @override
  String get yourDataIsSafe => 'Tus datos siempre están seguros';

  @override
  String get safe => 'Seguro';

  @override
  String get privacyDescription =>
      'Mantenemos tus datos privados y seguros. Tu confianza es nuestra prioridad.';

  @override
  String get saveMoreStressLess => 'Ahorra más. Estrésate menos.';

  @override
  String get saveMore => 'Ahorra más.';

  @override
  String get finalOnboardingDescription =>
      'Mantén el control de tus finanzas y desarrolla mejores hábitos financieros cada día.';

  @override
  String get skip => 'Omitir';

  @override
  String get next => 'Siguiente';

  @override
  String get letsGo => '¡Vamos!';
}
