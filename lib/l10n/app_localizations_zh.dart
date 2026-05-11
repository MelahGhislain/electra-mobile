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
  String get settingsSupportSubtitle => '联系我们的支持团队';

  @override
  String get settingsDocs => '文档';

  @override
  String get settingsDocsSubtitle => '了解如何使用该应用';

  @override
  String get settingsSuggest => '提出改进建议';

  @override
  String get settingsSuggestSubtitle => '分享您的反馈以帮助我们';

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
  String get themeSystem => '跟随系统';

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
  String get logoutTitle => '退出登录？';

  @override
  String get logoutBody => '您将退出您的账户。';

  @override
  String get logoutConfirm => '退出';

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
  String get retry => '重试';

  @override
  String get deleteAccountTitle => '删除账户？';

  @override
  String get deleteAccountBody => '这将永久删除您的账户和所有数据，此操作无法撤销。';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingLetsGo => '开始使用';

  @override
  String homeGreeting(String name) {
    return '你好，$name';
  }

  @override
  String get homeTagline => '掌控\n你的每一天';

  @override
  String get homeSpendingBreakdown => '支出明细';

  @override
  String get homeMonthlySnapshot => '月度概览';

  @override
  String get homeRecentlyCompleted => '最近完成';

  @override
  String get homeViewAll => '查看全部';

  @override
  String homeAvgDaily(String amount) {
    return '日均支出：$amount';
  }

  @override
  String get homeBudgetGood => '做得好！您在预算范围内 👍';

  @override
  String get homeBudgetWarning => '注意！您的支出接近预算上限。';

  @override
  String get homeBudgetOver => '您已超出月度预算。';

  @override
  String get homeBudgetNone => '本月未设置预算。';

  @override
  String get insightsTitle => '消费分析';

  @override
  String get insightsPeriodWeekly => '每周';

  @override
  String get insightsPeriodMonthly => '每月';

  @override
  String get insightsPeriodYearly => '每年';

  @override
  String insightsTotalSpent(String period) {
    return '$period总支出';
  }

  @override
  String get insightsBudgetOnTrack => '正常';

  @override
  String get insightsBudgetOver => '超出预算';

  @override
  String get insightsSpendingOverview => '支出概览';

  @override
  String get insightsViewByCategories => '按类别查看';

  @override
  String get insightsViewAllCategories => '查看所有类别';

  @override
  String get insightsKeyInsights => '关键洞察';

  @override
  String get insightsTopCategories => '主要消费类别';

  @override
  String get insightsViewAll => '查看全部';

  @override
  String get insightsTrend => '消费趋势';

  @override
  String get errorGeneric => '出了点问题';

  @override
  String get errorNetwork => '无法连接，请检查网络。';

  @override
  String get errorSessionExpired => '会话已过期，请重新登录。';
}
