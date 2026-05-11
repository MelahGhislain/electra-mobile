// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Electra';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsAccount => 'Conta';

  @override
  String get settingsGeneral => 'Geral';

  @override
  String get settingsData => 'Dados';

  @override
  String get settingsHelp => 'Ajuda';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsBudget => 'Orçamento e Renda';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsCurrency => 'Moeda';

  @override
  String get settingsNotifications => 'Notificações push';

  @override
  String get settingsNotificationsSubtitle =>
      'Receba lembretes e alertas de gastos';

  @override
  String get settingsExportData => 'Exportar dados';

  @override
  String get settingsExportDataSubtitle => 'Exporte seus dados';

  @override
  String get settingsSharedAccount => 'Conta compartilhada';

  @override
  String get settingsSharedAccountSubtitle =>
      'Gerenciar configurações de conta compartilhada';

  @override
  String get settingsSupport => 'Suporte';

  @override
  String get settingsSupportSubtitle =>
      'Entre em contato com nossa equipe de suporte';

  @override
  String get settingsDocs => 'Documentação';

  @override
  String get settingsDocsSubtitle => 'Aprenda a usar o aplicativo';

  @override
  String get settingsSuggest => 'Sugerir melhoria';

  @override
  String get settingsSuggestSubtitle =>
      'Compartilhe seu feedback para nos ajudar';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsSetupGuide => 'Guia de configuração';

  @override
  String get settingsSetupGuideSubtitle => 'Novo aqui? Comece por aqui';

  @override
  String get settingsDeleteAccount => 'Excluir conta';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Remover permanentemente sua conta';

  @override
  String get budgetNotSet => 'Não definido';

  @override
  String budgetPerMonth(String amount) {
    return '$amount / mês';
  }

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get languageSystemDefault => 'Padrão do sistema';

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
  String get logoutTitle => 'Sair?';

  @override
  String get logoutBody => 'Você será desconectado da sua conta.';

  @override
  String get logoutConfirm => 'Sair';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get deleteAccountTitle => 'Excluir conta?';

  @override
  String get deleteAccountBody =>
      'Isso excluirá permanentemente sua conta e todos os seus dados. Esta ação não pode ser desfeita.';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingLetsGo => 'Vamos lá';

  @override
  String homeGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get homeTagline => 'Assuma o controle\ndo seu dia';

  @override
  String get homeSpendingBreakdown => 'Detalhamento de gastos';

  @override
  String get homeMonthlySnapshot => 'Resumo mensal';

  @override
  String get homeRecentlyCompleted => 'Concluído recentemente';

  @override
  String get homeViewAll => 'Ver tudo';

  @override
  String homeAvgDaily(String amount) {
    return 'Média diária: $amount';
  }

  @override
  String get homeBudgetGood => 'Bom trabalho! Você está dentro do orçamento 👍';

  @override
  String get homeBudgetWarning =>
      'Atenção! Você está se aproximando do seu orçamento.';

  @override
  String get homeBudgetOver => 'Você ultrapassou seu orçamento mensal.';

  @override
  String get homeBudgetNone => 'Sem orçamento definido para este mês.';

  @override
  String get insightsTitle => 'Análise de gastos';

  @override
  String get insightsPeriodWeekly => 'Semanal';

  @override
  String get insightsPeriodMonthly => 'Mensal';

  @override
  String get insightsPeriodYearly => 'Anual';

  @override
  String insightsTotalSpent(String period) {
    return 'Total gasto em $period';
  }

  @override
  String get insightsBudgetOnTrack => 'No caminho certo';

  @override
  String get insightsBudgetOver => 'Orçamento excedido';

  @override
  String get insightsSpendingOverview => 'Visão geral dos gastos';

  @override
  String get insightsViewByCategories => 'Por categorias';

  @override
  String get insightsViewAllCategories => 'Ver todas as categorias';

  @override
  String get insightsKeyInsights => 'Principais insights';

  @override
  String get insightsTopCategories => 'Principais categorias';

  @override
  String get insightsViewAll => 'Ver tudo';

  @override
  String get insightsTrend => 'Tendência de gastos';

  @override
  String get errorGeneric => 'Algo deu errado';

  @override
  String get errorNetwork => 'Sem conexão. Verifique sua rede.';

  @override
  String get errorSessionExpired => 'Sua sessão expirou. Faça login novamente.';
}
