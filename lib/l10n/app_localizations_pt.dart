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
  String get settingsBudget => 'Orçamento e receitas';

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
  String get settingsExportDataSubtitle => 'Exporte os seus dados';

  @override
  String get settingsSharedAccount => 'Conta partilhada';

  @override
  String get settingsSharedAccountSubtitle =>
      'Gerir definições da conta partilhada';

  @override
  String get settingsSupport => 'Suporte';

  @override
  String get settingsSupportSubtitle => 'Contactar a nossa equipa de suporte';

  @override
  String get settingsDocs => 'Documentação';

  @override
  String get settingsDocsSubtitle => 'Aprenda a utilizar a aplicação';

  @override
  String get settingsSuggest => 'Sugerir uma melhoria';

  @override
  String get settingsSuggestSubtitle =>
      'Partilhe o seu feedback para nos ajudar';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsSetupGuide => 'Guia de configuração';

  @override
  String get settingsSetupGuideSubtitle => 'Novo aqui? Comece por aqui';

  @override
  String get settingsDeleteAccount => 'Eliminar conta';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Eliminar permanentemente a sua conta';

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
  String get languageSystemDefault => 'Idioma do sistema';

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
  String get logoutTitle => 'Terminar sessão';

  @override
  String get logoutBody =>
      'Tem a certeza de que pretende terminar sessão na sua conta?';

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
  String get tryAgain => 'Tentar novamente';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get enterYourName => 'Introduza o seu nome';

  @override
  String get nameCannotBeEmpty => 'O nome não pode estar vazio';

  @override
  String get nameTooShort => 'O nome é demasiado curto';

  @override
  String get email => 'E-mail';

  @override
  String get enterYourEmail => 'Introduza o seu e-mail';

  @override
  String get emailCannotBeEmpty => 'O e-mail não pode estar vazio';

  @override
  String get enterValidEmail => 'Introduza um endereço de e-mail válido';

  @override
  String get saveChanges => 'Guardar alterações';

  @override
  String get monthlyBudget => 'Orçamento mensal';

  @override
  String get budgetSubtitle =>
      'Defina um limite de gastos mensal para se manter no rumo certo.';

  @override
  String get budgetAmount => 'Valor do orçamento';

  @override
  String get enterBudgetAmount => 'Introduza o valor do orçamento';

  @override
  String get pleaseEnterABudgetAmount =>
      'Por favor introduza um valor de orçamento';

  @override
  String get enterAValidAmountGreaterThan0 =>
      'Introduza um valor válido superior a 0';

  @override
  String get budgetSeemsTooHigh =>
      'O orçamento parece demasiado alto — por favor verifique';

  @override
  String get quickSelect => 'Seleção rápida';

  @override
  String get saveBudget => 'Guardar orçamento';

  @override
  String get removeBudget => 'Remover orçamento';

  @override
  String get deleteAccountTitle => 'Eliminar conta';

  @override
  String get deleteAccountBody =>
      'Esta ação é permanente e não pode ser desfeita. Todos os seus dados, compras e definições serão eliminados.';

  @override
  String deleteAccountConfirmationMessage(String keyword) {
    return 'Escreva $keyword abaixo para confirmar que compreende que isto é irreversível.';
  }

  @override
  String typeDeleteHere(String keyword) {
    return 'Escreva $keyword aqui';
  }

  @override
  String get onboardingSkip => 'Ignorar';

  @override
  String get onboardingNext => 'Seguinte';

  @override
  String get onboardingLetsGo => 'Vamos lá';

  @override
  String homeGreeting(String name) {
    return 'Olá $name';
  }

  @override
  String get homeYoureSpendingLessThanUsual =>
      'Está a gastar menos do que o habitual. Excelente trabalho!';

  @override
  String get letsSetThingsUp => 'Vamos configurar tudo';

  @override
  String get getTheMostOutOfTheAppBySetting =>
      'Tire o máximo partido da aplicação configurando algumas coisas.';

  @override
  String get setMonthlyBudgetTitle => 'Defina o seu orçamento mensal';

  @override
  String get helpUsPersonalizeYourSpending =>
      'Ajude-nos a personalizar o seu plano de gastos';

  @override
  String get enablePushNotifications => 'Ativar notificações push';

  @override
  String get stayUpdatedOnSpending =>
      'Mantenha-se atualizado sobre gastos e lembretes';

  @override
  String get skipForNow => 'Ignorar por agora';

  @override
  String get youCanChangeTheseLater =>
      'Pode sempre alterar estas definições mais tarde em Configurações.';

  @override
  String get todaysSpending => 'Gastos de hoje';

  @override
  String vsYesterday(String percentage) {
    return '$percentage% vs ontem';
  }

  @override
  String get noDataForYesterday => 'Sem dados de ontem';

  @override
  String get mostRecentPurchase => 'Compra mais recente';

  @override
  String get ofDailyBudget => 'do orçamento\ndiário';

  @override
  String get dailyBudget => 'Orçamento diário';

  @override
  String get mostRecentSpending => 'Despesas mais recentes';

  @override
  String get viewAll => 'Ver tudo';

  @override
  String get total => 'Total';

  @override
  String get thisMonth => 'Este mês';

  @override
  String get headsUp => 'Atenção';

  @override
  String get avgDailySpend => 'Gasto diário médio';

  @override
  String get daysLeft => 'Dias restantes';

  @override
  String get recentActivity => 'Atividade recente';

  @override
  String get addExpense => 'Adicionar despesa';

  @override
  String get repeat => 'Repetir';

  @override
  String get setBudget => 'Definir orçamento';

  @override
  String get scanReceipt => 'Digitalizar\nrecibo';

  @override
  String get noBudgetSetForThisMonth =>
      'Nenhum orçamento definido para este mês.';

  @override
  String get youHaveExceededYourMonthlyBudget =>
      'Excedeu o seu orçamento mensal.';

  @override
  String get headsUpYouAreCloseToYourBudget =>
      'Atenção! Está próximo do seu orçamento.';

  @override
  String get niceWorkYouAreStayingWithinBudget =>
      'Bom trabalho! Está dentro do orçamento 👍';

  @override
  String get spending => 'Gastos';

  @override
  String get trackYourSpendingStayInControl =>
      'Controle os seus gastos, mantenha o controlo';

  @override
  String get searchMerchantItemOrCategory =>
      'Pesquisar comerciante, artigo ou categoria...';

  @override
  String spendingInsightMessage(String percentage, String category) {
    return 'Gastou $percentage% mais em $category esta semana';
  }

  @override
  String get addPurchase => 'Adicionar compra';

  @override
  String get editPurchase => 'Editar compra';

  @override
  String get title => 'Título';

  @override
  String get date => 'Data';

  @override
  String get category => 'Categoria';

  @override
  String get paymentMethod => 'Método de pagamento';

  @override
  String get amount => 'Valor';

  @override
  String get currency => 'Moeda';

  @override
  String get pleaseEnterName => 'Por favor introduza um nome';

  @override
  String get enterAmount => 'Introduza um valor';

  @override
  String get savePurchase => 'Guardar compra';

  @override
  String get card => 'Cartão';

  @override
  String get cash => 'Dinheiro';

  @override
  String get other => 'Outro';

  @override
  String get filterAndSort => 'Filtrar e ordenar';

  @override
  String get resetAll => 'Repor tudo';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get merchant => 'Comerciante';

  @override
  String get dateRange => 'Intervalo de datas';

  @override
  String get noCategoriesAvailable => 'Sem categorias disponíveis';

  @override
  String get noMerchantsAvailable => 'Sem comerciantes disponíveis';

  @override
  String get noResultsFound => 'Nenhum resultado encontrado';

  @override
  String get noPurchasesYet => 'Ainda sem compras';

  @override
  String get tryAdjustingFiltersOrSearch =>
      'Tente ajustar os filtros ou a pesquisa';

  @override
  String get purchaseHistoryWillAppearHere =>
      'O seu histórico de compras aparecerá aqui';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get insight => 'Análise';

  @override
  String get noItems => 'Sem artigos';

  @override
  String get item => 'Artigo';

  @override
  String get items => 'Artigos';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get failedToLoadPurchase => 'Falha ao carregar a compra';

  @override
  String get avgPrice => 'Preço médio';

  @override
  String get payment => 'Pagamento';

  @override
  String get below => '↓ Abaixo';

  @override
  String get above => '↑ Acima';

  @override
  String get at => 'Em';

  @override
  String itemInsights(String percent, String label) {
    return '↑ +$percent% vs última compra • preço médio $label';
  }

  @override
  String get editItem => 'Editar artigo';

  @override
  String get deleteItem => 'Eliminar artigo';

  @override
  String get edited => 'Editado';

  @override
  String ofTotal(String percent) {
    return '$percent% do total';
  }

  @override
  String get sortNameAZ => 'Nome (A–Z)';

  @override
  String get sortNameZA => 'Nome (Z–A)';

  @override
  String get sortPriceLow => 'Preço ↑';

  @override
  String get sortPriceHigh => 'Preço ↓';

  @override
  String get dateNewest => 'Data ↑';

  @override
  String get sortDateOldest => 'Data ↓';

  @override
  String get addItem => 'Adicionar artigo';

  @override
  String get noItemsRecorded => 'Nenhum artigo registado';

  @override
  String get noCategoryDataAvailable => 'Sem dados de categoria disponíveis';

  @override
  String get sortItems => 'Ordenar artigos';

  @override
  String get view => 'Ver';

  @override
  String get receipt => 'Recibo';

  @override
  String get noReceiptAdded => 'Nenhum recibo adicionado';

  @override
  String uploadedProcessed(String date) {
    return 'Carregado a $date • Processado';
  }

  @override
  String get spendingInsights => 'Análise de gastos';

  @override
  String get spendingOverview => 'Visão geral dos gastos';

  @override
  String viewByCategories(String group) {
    return 'Por $group';
  }

  @override
  String get keyInsights => 'Pontos-chave';

  @override
  String get topSpendingCategories => 'Principais categorias de gastos';

  @override
  String get spendingTrend => 'Tendência de gastos';

  @override
  String get previous => 'Anterior';

  @override
  String get paymentMethods => 'Métodos de pagamento';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensal';

  @override
  String get yearly => 'Anual';

  @override
  String get noDataThisPeriod => 'Sem dados\nneste período';

  @override
  String get viewAllCategories => 'Ver todas as categorias';

  @override
  String get somethingWentWrong => 'Algo correu mal';

  @override
  String get savingsOpportunity => 'Oportunidade de poupança';

  @override
  String get noSpendingDataThisPeriod => 'Sem dados de gastos neste período';

  @override
  String totalSpentIn(String period) {
    return 'Total gasto em $period';
  }

  @override
  String lessThanPrevious(String percent, String amount) {
    return '$percent% menos do que anteriormente ($amount)';
  }

  @override
  String moreThanPrevious(String percent, String amount) {
    return '$percent% mais do que anteriormente ($amount)';
  }

  @override
  String get budgetStatus => 'Estado do orçamento';

  @override
  String get onTrack => 'No caminho certo';

  @override
  String get overBudget => 'Orçamento excedido';

  @override
  String ofBudget(String amount) {
    return 'de $amount de orçamento';
  }

  @override
  String get averagePerDay => 'Média por dia';

  @override
  String get thisPeriod => 'Este período';

  @override
  String get noTrendDataAvailable => 'Sem dados de tendência disponíveis';

  @override
  String get letsSignYouIn => 'Vamos iniciar sessão';

  @override
  String get signInAndStartPlanning => 'Inicie sessão e comece a planear.';

  @override
  String get emailAddress => 'Endereço de e-mail';

  @override
  String get enterYourMailAddress => 'Introduza o seu endereço de e-mail';

  @override
  String get emailIsRequired => 'O e-mail é obrigatório';

  @override
  String get password => 'Palavra-passe';

  @override
  String get enterYourPassword => 'Introduza a sua palavra-passe';

  @override
  String get passwordIsRequired => 'A palavra-passe é obrigatória';

  @override
  String get signIn => 'Iniciar sessão';

  @override
  String get continueWithGoogle => 'Continuar com o Google';

  @override
  String get dontHaveAnAccount => 'Não tem uma conta?';

  @override
  String get signUp => 'Registar';

  @override
  String get fullName => 'Nome completo';

  @override
  String get nameIsRequired => 'O nome é obrigatório';

  @override
  String get minimum8Characters => 'Mínimo 8 caracteres';

  @override
  String get reEnterPassword => 'Reintroduzir palavra-passe';

  @override
  String get passwordsDoNotMatch => 'As palavras-passe não coincidem';

  @override
  String get alreadyHaveAnAccount => 'Já tem uma conta?';

  @override
  String get orSignWith => 'Ou continuar com';

  @override
  String get whereDidMyMoneyGo => 'Para onde foi o meu dinheiro?';

  @override
  String get myMoney => 'O meu dinheiro';

  @override
  String get stopGuessingSpending =>
      'Pare de adivinhar os seus gastos. O Electra ajuda-o a registar cada despesa sem esforço.';

  @override
  String get trackWithYourVoice => 'Registe com a sua voz';

  @override
  String get voice => 'Voz';

  @override
  String get voiceDescription =>
      'Fale apenas, nós tratamos do resto. Rápido, inteligente e muito fácil.';

  @override
  String get autoCategorizeExpenses => 'Categorização automática de despesas';

  @override
  String get autoCategorize => 'Auto-categoria';

  @override
  String get autoCategorizeDescription =>
      'O Electra categoriza automaticamente as suas despesas para que se possa focar no que importa.';

  @override
  String get insightsThatHelpYouSave => 'Análises que o ajudam a poupar';

  @override
  String get insightsDescription =>
      'Compreenda os seus padrões de gastos e tome decisões financeiras mais inteligentes.';

  @override
  String get yourDataIsSafe => 'Os seus dados estão sempre seguros';

  @override
  String get safe => 'Seguro';

  @override
  String get privacyDescription =>
      'Mantemos os seus dados privados e seguros. A sua confiança é a nossa prioridade.';

  @override
  String get saveMoreStressLess => 'Poupe mais. Stresse menos.';

  @override
  String get saveMore => 'Poupe mais.';

  @override
  String get finalOnboardingDescription =>
      'Mantenha o controlo das suas finanças e desenvolva melhores hábitos financeiros todos os dias.';

  @override
  String get skip => 'Ignorar';

  @override
  String get next => 'Seguinte';

  @override
  String get letsGo => 'Vamos lá';

  @override
  String get spendingDetails => 'Detalhes dos gastos';

  @override
  String get share => 'Partilhar';

  @override
  String get export => 'Exportar';

  @override
  String get deletePurchase => 'Eliminar compra';

  @override
  String get deletePurchaseTitle => 'Eliminar compra?';

  @override
  String get deletePurchaseDescription => 'Esta ação não pode ser desfeita.';

  @override
  String get premiumFeature => 'Funcionalidade Premium';

  @override
  String get savingChanges => 'A guardar alterações…';

  @override
  String get sortNewest => 'Mais recente primeiro';

  @override
  String get sortOldest => 'Mais antigo primeiro';

  @override
  String get sortMostExpensive => 'Mais caro primeiro';

  @override
  String get sortCheapest => 'Mais barato primeiro';

  @override
  String get sortByName => 'Por nome';

  @override
  String get categoryFood => 'Alimentação';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryHousing => 'Habitação';

  @override
  String get categoryBills => 'Faturas';

  @override
  String get categorySubscriptions => 'Subscrições';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryHealth => 'Saúde';

  @override
  String get categoryEntertainment => 'Entretenimento';

  @override
  String get categoryTravel => 'Viagens';

  @override
  String get categoryEducation => 'Educação';

  @override
  String get categoryPersonal => 'Pessoal';

  @override
  String get categoryGifts => 'Presentes';

  @override
  String get categoryDonations => 'Doações';

  @override
  String get categoryOther => 'Outro';

  @override
  String get selectCategory => 'Selecionar categoria';

  @override
  String get searchCategories => 'Pesquisar categorias...';

  @override
  String noCategoriesFoundFor(String query) {
    return 'Nenhuma categoria encontrada para \"$query\"';
  }

  @override
  String itemWillBePermanentlyRemoved(String itemName) {
    return '«$itemName» será removido permanentemente desta compra.';
  }

  @override
  String get itemName => 'Nome do artigo';

  @override
  String get itemNameHint => 'ex. Carne, Leite, Champô';

  @override
  String get unitPrice => 'Preço unitário';

  @override
  String get required => 'Obrigatório';

  @override
  String get invalid => 'Inválido';

  @override
  String get quantityShort => 'Qtd';

  @override
  String get minimumOne => 'Mín 1';

  @override
  String get home => 'Início';

  @override
  String get insights => 'Análises';

  @override
  String get profile => 'Perfil';

  @override
  String get selectDateRange => 'Selecionar intervalo de datas';

  @override
  String get premium => 'Premium';

  @override
  String get subscription => 'Assinatura';

  @override
  String get manualEntry => 'Entrada manual';

  @override
  String get enterDetailsManually => 'Digite os detalhes manualmente';

  @override
  String get voiceInput => 'Entrada de voz';

  @override
  String get addBySpeaking => 'Adicionar por voz';

  @override
  String get snapPhotoOfReceipt => 'Tire uma foto do seu recibo';

  @override
  String get all => 'Todos';

  @override
  String get categories => 'Categorias';

  @override
  String get merchants => 'Comerciantes';

  @override
  String get budget => 'Orçamento';

  @override
  String get dailyAverage => 'Média diária';

  @override
  String get financialHealthReport => 'Relatório de Saúde Financeira';

  @override
  String get financialHealthScore => 'Score de saúde financeira';

  @override
  String get generatedAt => 'Gerado em';

  @override
  String get noOpportunity => 'Nenhuma oportunidade encontrada';

  @override
  String get ofTotalSpend => 'de gastos totais';

  @override
  String get perDay => 'por dia';

  @override
  String get perYear => 'por ano';

  @override
  String get periodSummary => 'Resumo do período';

  @override
  String get potentialSavings => 'Economias potenciais';

  @override
  String get recommendationsForYou => 'Recomendações para você';

  @override
  String get topCategory => 'Categoria principal';

  @override
  String get totalSpent => 'Total gasto';

  @override
  String get viewFullReport => 'Ver relatório completo';

  @override
  String get vsLastPeriod => 'vs período anterior';

  @override
  String get vsPreviousPeriod => 'vs período anterior';

  @override
  String get youSpentTheMostOn => 'Você gastou mais em';
}
