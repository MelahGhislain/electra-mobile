import 'package:electra/domain/entities/insights/insights.dart';

// ── helpers ───────────────────────────────────────────────────────────────────

TrendDirection _parseTrend(String? v) {
  switch (v) {
    case 'up':
      return TrendDirection.up;
    case 'down':
      return TrendDirection.down;
    default:
      return TrendDirection.neutral;
  }
}

InsightsPeriod _parsePeriod(String? v) {
  switch (v) {
    case 'weekly':
      return InsightsPeriod.weekly;
    case 'yearly':
      return InsightsPeriod.yearly;
    default:
      return InsightsPeriod.monthly;
  }
}

KeyInsightType _parseInsightType(String? v) {
  switch (v) {
    case 'category_change':
      return KeyInsightType.categoryChange;
    case 'daily_average':
      return KeyInsightType.dailyAverage;
    case 'highest_day':
      return KeyInsightType.highestDay;
    default:
      return KeyInsightType.savings;
  }
}

// ── Models ────────────────────────────────────────────────────────────────────

class InsightsMetaModel {
  static InsightsMeta fromJson(Map<String, dynamic> j) => InsightsMeta(
    label: j['label'] as String,
    period: _parsePeriod(j['period'] as String?),
    from: DateTime.parse(j['from'] as String),
    to: DateTime.parse(j['to'] as String),
    previousFrom: DateTime.parse(j['previousFrom'] as String),
    previousTo: DateTime.parse(j['previousTo'] as String),
  );
}

class SpendingTotalsModel {
  static SpendingTotals fromJson(Map<String, dynamic> j) => SpendingTotals(
    amount: (j['amount'] as num).toDouble(),
    currency: j['currency'] as String,
    delta: (j['delta'] as num).toDouble(),
    deltaPercent: (j['deltaPercent'] as num).toDouble(),
    trend: _parseTrend(j['trend'] as String?),
    previousAmount: (j['previousAmount'] as num).toDouble(),
  );
}

class BudgetStatusModel {
  static BudgetStatus fromJson(Map<String, dynamic> j) => BudgetStatus(
    monthlyBudget: (j['monthlyBudget'] as num).toDouble(),
    currency: j['currency'] as String,
    spent: (j['spent'] as num).toDouble(),
    remaining: (j['remaining'] as num).toDouble(),
    progressPercent: (j['progressPercent'] as num).toDouble(),
    isOnTrack: j['isOnTrack'] as bool,
  );
}

class CategoryBreakdownModel {
  static CategoryBreakdown fromJson(Map<String, dynamic> j) =>
      CategoryBreakdown(
        name: j['name'] as String,
        normalizedName: j['normalizedName'] as String,
        color: j['color'] as String?,
        amount: (j['amount'] as num).toDouble(),
        currency: j['currency'] as String,
        percent: (j['percent'] as num).toDouble(),
        count: (j['count'] as num).toInt(),
      );
}

class KeyInsightModel {
  static KeyInsight fromJson(Map<String, dynamic> j) => KeyInsight(
    type: _parseInsightType(j['type'] as String?),
    value: j['value'] as String,
    label: j['label'] as String,
    trend: j['trend'] != null ? _parseTrend(j['trend'] as String?) : null,
    numericValue: (j['numericValue'] as num?)?.toDouble(),
    date: j['date'] as String?,
  );
}

class TrendPointModel {
  static TrendPoint fromJson(Map<String, dynamic> j) => TrendPoint(
    date: DateTime.parse(j['date'] as String),
    amount: (j['amount'] as num).toDouble(),
  );
}

class SpendingTrendModel {
  static SpendingTrend fromJson(Map<String, dynamic> j) => SpendingTrend(
    currency: j['currency'] as String,
    dailyAverage: (j['dailyAverage'] as num).toDouble(),
    current: (j['current'] as List)
        .map((e) => TrendPointModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    previous: (j['previous'] as List)
        .map((e) => TrendPointModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class PaymentMethodBreakdownModel {
  static PaymentMethodBreakdown fromJson(Map<String, dynamic> j) =>
      PaymentMethodBreakdown(
        method: j['method'] as String,
        amount: (j['amount'] as num).toDouble(),
        currency: j['currency'] as String,
        percent: (j['percent'] as num).toDouble(),
        count: (j['count'] as num).toInt(),
      );
}

class MerchantBreakdownModel {
  static MerchantBreakdown fromJson(Map<String, dynamic> j) =>
      MerchantBreakdown(
        name: j['name'] as String,
        normalizedName: j['normalizedName'] as String,
        amount: (j['amount'] as num).toDouble(),
        currency: j['currency'] as String,
        count: (j['count'] as num).toInt(),
      );
}

class SavingsOpportunityModel {
  static SavingsOpportunity fromJson(Map<String, dynamic> j) =>
      SavingsOpportunity(
        categoryName: j['categoryName'] as String,
        currentAmount: (j['currentAmount'] as num).toDouble(),
        suggestedReduction: (j['suggestedReduction'] as num).toDouble(),
        projectedAnnualSavings: (j['projectedAnnualSavings'] as num).toDouble(),
        currency: j['currency'] as String,
        message: j['message'] as String,
      );
}

class SpendingInsightsModel {
  static SpendingInsights fromJson(Map<String, dynamic> j) {
    final budgetRaw = j['budget'];
    final savingsRaw = j['savingsOpportunity'];

    return SpendingInsights(
      meta: InsightsMetaModel.fromJson(j['meta'] as Map<String, dynamic>),
      totals: SpendingTotalsModel.fromJson(j['totals'] as Map<String, dynamic>),
      budget: (budgetRaw != null && budgetRaw is Map)
          ? BudgetStatusModel.fromJson(budgetRaw as Map<String, dynamic>)
          : null,
      categoryBreakdown: (j['categoryBreakdown'] as List)
          .map(
            (e) => CategoryBreakdownModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      keyInsights: (j['keyInsights'] as List)
          .map((e) => KeyInsightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      trend: SpendingTrendModel.fromJson(j['trend'] as Map<String, dynamic>),
      paymentMethods: (j['paymentMethods'] as List)
          .map(
            (e) =>
                PaymentMethodBreakdownModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      topMerchants: (j['topMerchants'] as List)
          .map(
            (e) => MerchantBreakdownModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      savingsOpportunity: (savingsRaw != null && savingsRaw is Map)
          ? SavingsOpportunityModel.fromJson(savingsRaw as Map<String, dynamic>)
          : null,
    );
  }
}
