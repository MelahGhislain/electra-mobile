import 'package:qleo/domain/entities/insights/insights.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

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

// ── Existing models (unchanged) ───────────────────────────────────────────────

class InsightsMetaModel {
  static InsightsMeta fromJson(Map<String, dynamic> j) => InsightsMeta(
    label: j['label'] as String? ?? '',
    period: _parsePeriod(j['period'] as String?),
    from: DateTime.parse(j['from'] as String),
    to: DateTime.parse(j['to'] as String),
    previousFrom: DateTime.parse(j['previousFrom'] as String),
    previousTo: DateTime.parse(j['previousTo'] as String),
  );
}

class SpendingTotalsModel {
  static SpendingTotals fromJson(Map<String, dynamic> j) => SpendingTotals(
    amount: (j['amount'] as num?)?.toDouble() ?? 0,
    currency: j['currency'] as String? ?? 'USD',
    delta: (j['delta'] as num?)?.toDouble() ?? 0,
    deltaPercent: (j['deltaPercent'] as num?)?.toDouble() ?? 0,
    trend: _parseTrend(j['trend'] as String?),
    previousAmount: (j['previousAmount'] as num?)?.toDouble() ?? 0,
  );
}

class BudgetStatusModel {
  static BudgetStatus fromJson(Map<String, dynamic> j) => BudgetStatus(
    monthlyBudget: (j['monthlyBudget'] as num?)?.toDouble() ?? 0,
    currency: j['currency'] as String? ?? 'USD',
    spent: (j['spent'] as num?)?.toDouble() ?? 0,
    remaining: (j['remaining'] as num?)?.toDouble() ?? 0,
    progressPercent: (j['progressPercent'] as num?)?.toDouble() ?? 0,
    isOnTrack: j['isOnTrack'] as bool? ?? true,
  );
}

class CategoryBreakdownModel {
  static CategoryBreakdown fromJson(Map<String, dynamic> j) =>
      CategoryBreakdown(
        name: j['name'] as String? ?? '',
        normalizedName: j['normalizedName'] as String? ?? '',
        color: j['color'] as String?,
        amount: (j['amount'] as num?)?.toDouble() ?? 0,
        currency: j['currency'] as String? ?? 'USD',
        percent: (j['percent'] as num?)?.toDouble() ?? 0,
        count: (j['count'] as num?)?.toInt() ?? 0,
      );
}

class KeyInsightModel {
  static KeyInsight fromJson(Map<String, dynamic> j) => KeyInsight(
    type: _parseInsightType(j['type'] as String?),
    leadingText: j['leadingText'] as String? ?? '',
    value: j['value'] as String? ?? '',
    tailingText: j['tailingText'] as String? ?? '',
    trend: j['trend'] != null ? _parseTrend(j['trend'] as String?) : null,
    numericValue: (j['numericValue'] as num?)?.toDouble(),
    date: j['date'] as String?,
  );
}

class TrendPointModel {
  static TrendPoint fromJson(Map<String, dynamic> j) => TrendPoint(
    date: DateTime.parse(j['date'] as String),
    amount: (j['amount'] as num?)?.toDouble() ?? 0,
  );
}

class SpendingTrendModel {
  static SpendingTrend fromJson(Map<String, dynamic> j) => SpendingTrend(
    currency: j['currency'] as String? ?? 'USD',
    dailyAverage: (j['dailyAverage'] as num?)?.toDouble() ?? 0,
    current: (j['current'] as List? ?? [])
        .map((e) => TrendPointModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    previous: (j['previous'] as List? ?? [])
        .map((e) => TrendPointModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class PaymentMethodBreakdownModel {
  static PaymentMethodBreakdown fromJson(Map<String, dynamic> j) =>
      PaymentMethodBreakdown(
        method: j['method'] as String? ?? '',
        amount: (j['amount'] as num?)?.toDouble() ?? 0,
        currency: j['currency'] as String? ?? 'USD',
        percent: (j['percent'] as num?)?.toDouble() ?? 0,
        count: (j['count'] as num?)?.toInt() ?? 0,
      );
}

class MerchantBreakdownModel {
  static MerchantBreakdown fromJson(Map<String, dynamic> j) =>
      MerchantBreakdown(
        name: j['name'] as String? ?? '',
        normalizedName: j['normalizedName'] as String? ?? '',
        amount: (j['amount'] as num?)?.toDouble() ?? 0,
        currency: j['currency'] as String? ?? 'USD',
        count: (j['count'] as num?)?.toInt() ?? 0,
      );
}

class SavingsOpportunityModel {
  static SavingsOpportunity fromJson(Map<String, dynamic> j) =>
      SavingsOpportunity(
        categoryName: j['categoryName'] as String? ?? '',
        currentAmount: (j['currentAmount'] as num?)?.toDouble() ?? 0,
        suggestedReduction: (j['suggestedReduction'] as num?)?.toDouble() ?? 0,
        projectedAnnualSavings:
            (j['projectedAnnualSavings'] as num?)?.toDouble() ?? 0,
        currency: j['currency'] as String? ?? 'USD',
        message: j['message'] as String? ?? '',
      );
}

// ── NEW: Top spending day ─────────────────────────────────────────────────────

class TopSpendingDayModel {
  static TopSpendingDay fromJson(Map<String, dynamic> j) => TopSpendingDay(
    date: j['date'] as String? ?? '',
    dayLabel: j['dayLabel'] as String? ?? '',
    amount: (j['amount'] as num?)?.toDouble() ?? 0,
    currency: j['currency'] as String? ?? 'USD',
    transactionCount: (j['transactionCount'] as num?)?.toInt() ?? 0,
  );
}

// ── NEW: AI enrichment ────────────────────────────────────────────────────────

class HealthScoreModel {
  static HealthScore fromJson(Map<String, dynamic> j) => HealthScore(
    score: (j['score'] as num?)?.toInt() ?? 0,
    label: j['label'] as String? ?? '',
    highlights: (j['highlights'] as List? ?? [])
        .map((e) => e as String)
        .toList(),
  );
}

class RecommendationModel {
  static Recommendation fromJson(Map<String, dynamic> j) => Recommendation(
    title: j['title'] as String? ?? '',
    description: j['description'] as String? ?? '',
    icon: j['icon'] as String? ?? 'other',
    potentialSavings: (j['potentialSavings'] as num?)?.toDouble(),
    currency: j['currency'] as String?,
  );
}

class AiEnrichmentModel {
  static AiEnrichment fromJson(Map<String, dynamic> j) => AiEnrichment(
    healthScore: HealthScoreModel.fromJson(
      j['healthScore'] as Map<String, dynamic>,
    ),
    recommendations: (j['recommendations'] as List? ?? [])
        .map((e) => RecommendationModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    generatedAt: DateTime.parse(j['generatedAt'] as String),
  );
}

// ── Root model ────────────────────────────────────────────────────────────────

class SpendingInsightsModel {
  static SpendingInsights fromJson(Map<String, dynamic> j) {
    final budgetRaw = j['budget'];
    final savingsRaw = j['savingsOpportunity'];
    final aiRaw = j['aiEnrichment'];

    return SpendingInsights(
      meta: InsightsMetaModel.fromJson(j['meta'] as Map<String, dynamic>),
      totals: SpendingTotalsModel.fromJson(j['totals'] as Map<String, dynamic>),
      budget: (budgetRaw != null && budgetRaw is Map && budgetRaw.isNotEmpty)
          ? BudgetStatusModel.fromJson(budgetRaw as Map<String, dynamic>)
          : null,
      categoryBreakdown: (j['categoryBreakdown'] as List? ?? [])
          .map(
            (e) => CategoryBreakdownModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      keyInsights: (j['keyInsights'] as List? ?? [])
          .map((e) => KeyInsightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      trend: SpendingTrendModel.fromJson(j['trend'] as Map<String, dynamic>),
      paymentMethods: (j['paymentMethods'] as List? ?? [])
          .map(
            (e) =>
                PaymentMethodBreakdownModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      topMerchants: (j['topMerchants'] as List? ?? [])
          .map(
            (e) => MerchantBreakdownModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      savingsOpportunity:
          (savingsRaw != null && savingsRaw is Map && savingsRaw.isNotEmpty)
          ? SavingsOpportunityModel.fromJson(savingsRaw as Map<String, dynamic>)
          : null,
      // ── new fields ──────────────────────────────────────────────────────────
      topSpendingDays: (j['topSpendingDays'] as List? ?? [])
          .map((e) => TopSpendingDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiEnrichment: (aiRaw != null && aiRaw is Map && aiRaw.isNotEmpty)
          ? AiEnrichmentModel.fromJson(aiRaw as Map<String, dynamic>)
          : null,
      isPremium: j['isPremium'] as bool? ?? false,
    );
  }
}
