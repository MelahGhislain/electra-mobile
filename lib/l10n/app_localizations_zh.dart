// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Electra';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsAccount => '账户';

  @override
  String get settingsGeneral => '通用';

  @override
  String get settingsData => '数据';

  @override
  String get settingsHelp => '帮助';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsBudget => '预算与收入';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsCurrency => '货币';

  @override
  String get settingsNotifications => '推送通知';

  @override
  String get settingsNotificationsSubtitle => '接收提醒和消费警报';

  @override
  String get settingsExportData => '导出数据';

  @override
  String get settingsExportDataSubtitle => '导出您的数据';

  @override
  String get settingsSharedAccount => '共享账户';

  @override
  String get settingsSharedAccountSubtitle => '管理共享账户设置';

  @override
  String get settingsSupport => '支持';

  @override
  String get settingsSupportSubtitle => '联系支持团队';

  @override
  String get settingsDocs => '文档';

  @override
  String get settingsDocsSubtitle => '了解如何使用应用';

  @override
  String get settingsSuggest => '提出改进建议';

  @override
  String get settingsSuggestSubtitle => '分享反馈帮助我们改进';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsSetupGuide => '设置指南';

  @override
  String get settingsSetupGuideSubtitle => '新用户？从这里开始';

  @override
  String get settingsDeleteAccount => '删除账户';

  @override
  String get settingsDeleteAccountSubtitle => '永久删除您的账户';

  @override
  String get budgetNotSet => '未设置';

  @override
  String budgetPerMonth(String amount) {
    return '$amount / 月';
  }

  @override
  String get themeSystem => '系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get languageSystemDefault => '系统默认';

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
  String get logoutTitle => '退出登录';

  @override
  String get logoutBody => '您确定要退出账户吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get tryAgain => '重试';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get editProfile => '编辑资料';

  @override
  String get enterYourName => '请输入姓名';

  @override
  String get nameCannotBeEmpty => '姓名不能为空';

  @override
  String get nameTooShort => '姓名太短';

  @override
  String get email => '邮箱';

  @override
  String get enterYourEmail => '请输入邮箱';

  @override
  String get emailCannotBeEmpty => '邮箱不能为空';

  @override
  String get enterValidEmail => '请输入有效邮箱';

  @override
  String get saveChanges => '保存更改';

  @override
  String get monthlyBudget => '月度预算';

  @override
  String get budgetSubtitle => '设置月度支出上限以保持控制。';

  @override
  String get budgetAmount => '预算金额';

  @override
  String get enterBudgetAmount => '输入预算金额';

  @override
  String get pleaseEnterABudgetAmount => '请输入预算金额';

  @override
  String get enterAValidAmountGreaterThan0 => '请输入大于0的金额';

  @override
  String get budgetSeemsTooHigh => '预算过高，请检查';

  @override
  String get quickSelect => '快速选择';

  @override
  String get saveBudget => '保存预算';

  @override
  String get removeBudget => '删除预算';

  @override
  String get deleteAccountTitle => '删除账户';

  @override
  String get deleteAccountBody => '此操作不可撤销，所有数据将被永久删除。';

  @override
  String deleteAccountConfirmationMessage(String keyword) {
    return '输入 $keyword 以确认此操作不可撤销。';
  }

  @override
  String typeDeleteHere(String keyword) {
    return '在此输入 $keyword';
  }

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingLetsGo => '开始';

  @override
  String homeGreeting(String name) {
    return '你好 $name';
  }

  @override
  String get homeYoureSpendingLessThanUsual => '你最近花得比平时少，很棒！';

  @override
  String get letsSetThingsUp => '开始设置';

  @override
  String get getTheMostOutOfTheAppBySetting => '通过简单设置充分使用应用。';

  @override
  String get setMonthlyBudgetTitle => '设置月度预算';

  @override
  String get helpUsPersonalizeYourSpending => '帮助我们个性化你的支出计划';

  @override
  String get enablePushNotifications => '开启推送通知';

  @override
  String get stayUpdatedOnSpending => '获取支出与提醒更新';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get youCanChangeTheseLater => '以后可以在设置中更改。';

  @override
  String get todaysSpending => '今日支出';

  @override
  String vsYesterday(String percentage) {
    return '比昨天 $percentage%';
  }

  @override
  String get noDataForYesterday => '昨日无数据';

  @override
  String get mostRecentPurchase => '最近消费';

  @override
  String get ofDailyBudget => '占每日\n预算';

  @override
  String get dailyBudget => '每日预算';

  @override
  String get topSpendingToday => '今日最高支出';

  @override
  String get viewAll => '查看全部';

  @override
  String get total => '总计';

  @override
  String get thisMonth => '本月';

  @override
  String get headsUp => '注意';

  @override
  String get avgDailySpend => '日均支出';

  @override
  String get daysLeft => '剩余天数';

  @override
  String get recentActivity => '最近活动';

  @override
  String get addExpense => '添加支出';

  @override
  String get repeat => '重复';

  @override
  String get setBudget => '设置预算';

  @override
  String get scanReceipt => '扫描\n小票';

  @override
  String get noBudgetSetForThisMonth => '本月未设置预算。';

  @override
  String get youHaveExceededYourMonthlyBudget => '你已超出月度预算。';

  @override
  String get headsUpYouAreCloseToYourBudget => '注意！你接近预算上限。';

  @override
  String get niceWorkYouAreStayingWithinBudget => '很好！你仍在预算范围内 👍';

  @override
  String get spending => '支出';

  @override
  String get trackYourSpendingStayInControl => '记录支出，保持掌控';

  @override
  String get searchMerchantItemOrCategory => '搜索商户、项目或类别...';

  @override
  String spendingInsightMessage(String percentage, String category) {
    return '本周在 $category 上多花了 $percentage%';
  }

  @override
  String get addPurchase => '添加消费';

  @override
  String get editPurchase => '编辑消费';

  @override
  String get title => '标题';

  @override
  String get date => '日期';

  @override
  String get category => '类别';

  @override
  String get paymentMethod => '支付方式';

  @override
  String get amount => '金额';

  @override
  String get currency => '货币';

  @override
  String get pleaseEnterName => '请输入名称';

  @override
  String get enterAmount => '输入金额';

  @override
  String get savePurchase => '保存消费';

  @override
  String get card => '银行卡';

  @override
  String get cash => '现金';

  @override
  String get other => '其他';

  @override
  String get filterAndSort => '筛选与排序';

  @override
  String get resetAll => '重置';

  @override
  String get applyFilters => '应用筛选';

  @override
  String get sortBy => '排序方式';

  @override
  String get merchant => '商户';

  @override
  String get dateRange => '日期范围';

  @override
  String get noCategoriesAvailable => '暂无类别';

  @override
  String get noMerchantsAvailable => '暂无商户';

  @override
  String get noResultsFound => '未找到结果';

  @override
  String get noPurchasesYet => '暂无记录';

  @override
  String get tryAdjustingFiltersOrSearch => '请调整筛选或搜索';

  @override
  String get purchaseHistoryWillAppearHere => '消费记录将显示在这里';

  @override
  String get clearFilters => '清除筛选';

  @override
  String get insight => '洞察';

  @override
  String get noItems => '暂无项目';

  @override
  String get item => '项目';

  @override
  String get items => '项目';

  @override
  String get unknown => '未知';

  @override
  String get failedToLoadPurchase => '加载消费失败';

  @override
  String get avgPrice => '平均价格';

  @override
  String get payment => '支付';

  @override
  String get below => '↓ 低于';

  @override
  String get above => '↑ 高于';

  @override
  String get at => '等于';

  @override
  String itemInsights(String percent, String label) {
    return '↑ 比上次消费高 $percent% • 平均 $label';
  }

  @override
  String get editItem => '编辑项目';

  @override
  String get deleteItem => '删除项目';

  @override
  String get edited => '已编辑';

  @override
  String ofTotal(String percent) {
    return '占总计 $percent%';
  }

  @override
  String get sortNameAZ => '名称 (A–Z)';

  @override
  String get sortNameZA => '名称 (Z–A)';

  @override
  String get sortPriceLow => '价格 ↑';

  @override
  String get sortPriceHigh => '价格 ↓';

  @override
  String get addItem => '添加项目';

  @override
  String get noItemsRecorded => '暂无记录';

  @override
  String get noCategoryDataAvailable => '暂无类别数据';

  @override
  String get sortItems => '排序项目';

  @override
  String get view => '查看';

  @override
  String get receipt => '小票';

  @override
  String get noReceiptAdded => '未添加小票';

  @override
  String uploadedProcessed(String date) {
    return '已上传 $date • 已处理';
  }

  @override
  String get spendingInsights => '支出分析';

  @override
  String get spendingOverview => '支出概览';

  @override
  String get viewByCategories => '按类别查看';

  @override
  String get keyInsights => '关键洞察';

  @override
  String get topSpendingCategories => '主要消费类别';

  @override
  String get spendingTrend => '消费趋势';

  @override
  String get previous => '上一个';

  @override
  String get paymentMethods => '支付方式';

  @override
  String get weekly => '每周';

  @override
  String get monthly => '每月';

  @override
  String get yearly => '每年';

  @override
  String get noDataThisPeriod => '本周期无数据';

  @override
  String get viewAllCategories => '查看所有类别';

  @override
  String get somethingWentWrong => '出了点问题';

  @override
  String get savingsOpportunity => '节省机会';

  @override
  String get noSpendingDataThisPeriod => '本周期无支出数据';

  @override
  String totalSpentIn(String period) {
    return '$period总支出';
  }

  @override
  String lessThanPrevious(String percent, String amount) {
    return '比上期少 $percent% ($amount)';
  }

  @override
  String moreThanPrevious(String percent, String amount) {
    return '比上期多 $percent% ($amount)';
  }

  @override
  String get budgetStatus => '预算状态';

  @override
  String get onTrack => '正常';

  @override
  String get overBudget => '超出预算';

  @override
  String ofBudget(String amount) {
    return '占 $amount 预算';
  }

  @override
  String get averagePerDay => '日均';

  @override
  String get thisPeriod => '本周期';

  @override
  String get noTrendDataAvailable => '暂无趋势数据';

  @override
  String get letsSignYouIn => '登录';

  @override
  String get signInAndStartPlanning => '登录并开始规划。';

  @override
  String get emailAddress => '邮箱';

  @override
  String get enterYourMailAddress => '请输入邮箱';

  @override
  String get emailIsRequired => '邮箱必填';

  @override
  String get password => '密码';

  @override
  String get enterYourPassword => '请输入密码';

  @override
  String get passwordIsRequired => '密码必填';

  @override
  String get signIn => '登录';

  @override
  String get continueWithGoogle => '使用 Google 登录';

  @override
  String get dontHaveAnAccount => '没有账号？';

  @override
  String get signUp => '注册';

  @override
  String get fullName => '姓名';

  @override
  String get nameIsRequired => '姓名必填';

  @override
  String get minimum8Characters => '至少 8 个字符';

  @override
  String get reEnterPassword => '再次输入密码';

  @override
  String get passwordsDoNotMatch => '密码不匹配';

  @override
  String get alreadyHaveAnAccount => '已有账号？';

  @override
  String get orSignWith => '或使用';

  @override
  String get whereDidMyMoneyGo => '我的钱去哪了？';

  @override
  String get myMoney => '我的资金';

  @override
  String get stopGuessingSpending => '不再猜测支出，轻松记录每一笔消费。';

  @override
  String get trackWithYourVoice => '语音记录';

  @override
  String get voice => '语音';

  @override
  String get voiceDescription => '只需说话，我们帮你完成记录。';

  @override
  String get autoCategorizeExpenses => '自动分类支出';

  @override
  String get autoCategorize => '自动分类';

  @override
  String get autoCategorizeDescription => '自动整理你的支出，让你专注重要事情。';

  @override
  String get insightsThatHelpYouSave => '帮助你节省的洞察';

  @override
  String get insightsDescription => '了解消费模式并做出更好的决策。';

  @override
  String get yourDataIsSafe => '数据始终安全';

  @override
  String get safe => '安全';

  @override
  String get privacyDescription => '我们保护你的隐私与数据安全。';

  @override
  String get saveMoreStressLess => '多存钱，少压力。';

  @override
  String get saveMore => '多存钱。';

  @override
  String get finalOnboardingDescription => '每天建立更好的理财习惯。';

  @override
  String get skip => '跳过';

  @override
  String get next => '下一步';

  @override
  String get letsGo => '开始';
}
