import 'package:equatable/equatable.dart';

// ── Period ────────────────────────────────────────────────────────────────────

enum InsightsPeriod { weekly, monthly, yearly }

// ── Meta ──────────────────────────────────────────────────────────────────────

class InsightsMeta extends Equatable {
  final String label;
  final InsightsPeriod period;
  final DateTime from;
  final DateTime to;
  final DateTime previousFrom;
  final DateTime previousTo;

  const InsightsMeta({
    required this.label,
    required this.period,
    required this.from,
    required this.to,
    required this.previousFrom,
    required this.previousTo,
  });

  @override
  List<Object?> get props => [label, period, from, to, previousFrom, previousTo];
}

// ── Totals ────────────────────────────────────────────────────────────────────

enum TrendDirection { up, down, neutral }

class SpendingTotals extends Equatable {
  final double amount;
  final String currency;
  final double delta;
  final double deltaPercent;
  final TrendDirection trend;
  final double previousAmount;

  const SpendingTotals({
    required this.amount,
    required this.currency,
    required this.delta,
    required this.deltaPercent,
    required this.trend,
    required this.previousAmount,
  });

  @override
  List<Object?> get props =>
      [amount, currency, delta, deltaPercent, trend, previousAmount];
}

// ── Budget ────────────────────────────────────────────────────────────────────

class BudgetStatus extends Equatable {
  final double monthlyBudget;
  final String currency;
  final double spent;
  final double remaining;
  final double progressPercent;
  final bool isOnTrack;

  const BudgetStatus({
    required this.monthlyBudget,
    required this.currency,
    required this.spent,
    required this.remaining,
    required this.progressPercent,
    required this.isOnTrack,
  });

  @override
  List<Object?> get props =>
      [monthlyBudget, currency, spent, remaining, progressPercent, isOnTrack];
}

// ── Category breakdown ────────────────────────────────────────────────────────

class CategoryBreakdown extends Equatable {
  final String name;
  final String normalizedName;
  final String? color;
  final double amount;
  final String currency;
  final double percent;
  final int count;

  const CategoryBreakdown({
    required this.name,
    required this.normalizedName,
    this.color,
    required this.amount,
    required this.currency,
    required this.percent,
    required this.count,
  });

  @override
  List<Object?> get props =>
      [name, normalizedName, color, amount, currency, percent, count];
}

// ── Key Insight ───────────────────────────────────────────────────────────────

enum KeyInsightType { savings, categoryChange, dailyAverage, highestDay }

class KeyInsight extends Equatable {
  final KeyInsightType type;
  final String leadingText;
  final String value;
  final String tailingText;
  final TrendDirection? trend;
  final double? numericValue;
  final String? date;

  const KeyInsight({
    required this.type,
    required this.leadingText,
    required this.value,
    required this.tailingText,
    this.trend,
    this.numericValue,
    this.date,
  });

  @override
  List<Object?> get props =>
      [type, leadingText, value, tailingText, trend, numericValue, date];
}

// ── Trend ─────────────────────────────────────────────────────────────────────

class TrendPoint extends Equatable {
  final DateTime date;
  final double amount;

  const TrendPoint({required this.date, required this.amount});

  @override
  List<Object?> get props => [date, amount];
}

class SpendingTrend extends Equatable {
  final String currency;
  final double dailyAverage;
  final List<TrendPoint> current;
  final List<TrendPoint> previous;

  const SpendingTrend({
    required this.currency,
    required this.dailyAverage,
    required this.current,
    required this.previous,
  });

  @override
  List<Object?> get props => [currency, dailyAverage, current, previous];
}

// ── Payment method ────────────────────────────────────────────────────────────

class PaymentMethodBreakdown extends Equatable {
  final String method;
  final double amount;
  final String currency;
  final double percent;
  final int count;

  const PaymentMethodBreakdown({
    required this.method,
    required this.amount,
    required this.currency,
    required this.percent,
    required this.count,
  });

  @override
  List<Object?> get props => [method, amount, currency, percent, count];
}

// ── Merchant ──────────────────────────────────────────────────────────────────

class MerchantBreakdown extends Equatable {
  final String name;
  final String normalizedName;
  final double amount;
  final String currency;
  final int count;

  const MerchantBreakdown({
    required this.name,
    required this.normalizedName,
    required this.amount,
    required this.currency,
    required this.count,
  });

  @override
  List<Object?> get props => [name, normalizedName, amount, currency, count];
}

// ── Savings opportunity ───────────────────────────────────────────────────────

class SavingsOpportunity extends Equatable {
  final String categoryName;
  final double currentAmount;
  final double suggestedReduction;
  final double projectedAnnualSavings;
  final String currency;
  final String message;

  const SavingsOpportunity({
    required this.categoryName,
    required this.currentAmount,
    required this.suggestedReduction,
    required this.projectedAnnualSavings,
    required this.currency,
    required this.message,
  });

  @override
  List<Object?> get props => [
        categoryName,
        currentAmount,
        suggestedReduction,
        projectedAnnualSavings,
        currency,
        message,
      ];
}

// ── NEW: Top spending day ─────────────────────────────────────────────────────

class TopSpendingDay extends Equatable {
  final String date;       // "2026-05-21"
  final String dayLabel;   // "May 21, 2026"
  final double amount;
  final String currency;
  final int transactionCount;

  const TopSpendingDay({
    required this.date,
    required this.dayLabel,
    required this.amount,
    required this.currency,
    required this.transactionCount,
  });

  @override
  List<Object?> get props => [date, dayLabel, amount, currency, transactionCount];
}

// ── NEW: AI enrichment (premium only — null for free users) ──────────────────

class HealthScore extends Equatable {
  final int score;          // 0-100
  final String label;       // "Good" | "Fair" | "Excellent" | "Needs attention"
  final List<String> highlights;

  const HealthScore({
    required this.score,
    required this.label,
    required this.highlights,
  });

  @override
  List<Object?> get props => [score, label, highlights];
}

class Recommendation extends Equatable {
  final String title;
  final String description;
  final String icon;           // category normalizedName for icon lookup
  final double? potentialSavings;
  final String? currency;

  const Recommendation({
    required this.title,
    required this.description,
    required this.icon,
    this.potentialSavings,
    this.currency,
  });

  @override
  List<Object?> get props => [title, description, icon, potentialSavings, currency];
}

class AiEnrichment extends Equatable {
  final HealthScore healthScore;
  final List<Recommendation> recommendations;
  final DateTime generatedAt;

  const AiEnrichment({
    required this.healthScore,
    required this.recommendations,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [healthScore, recommendations, generatedAt];
}

// ── Root entity ───────────────────────────────────────────────────────────────

class SpendingInsights extends Equatable {
  final InsightsMeta meta;
  final SpendingTotals totals;
  final BudgetStatus? budget;
  final List<CategoryBreakdown> categoryBreakdown;
  final List<KeyInsight> keyInsights;
  final SpendingTrend trend;
  final List<PaymentMethodBreakdown> paymentMethods;
  final List<MerchantBreakdown> topMerchants;
  final SavingsOpportunity? savingsOpportunity;
  final List<TopSpendingDay> topSpendingDays; // new
  final AiEnrichment? aiEnrichment;           // new — null for free users
  final bool isPremium;                        // new

  const SpendingInsights({
    required this.meta,
    required this.totals,
    this.budget,
    required this.categoryBreakdown,
    required this.keyInsights,
    required this.trend,
    required this.paymentMethods,
    required this.topMerchants,
    this.savingsOpportunity,
    required this.topSpendingDays,
    this.aiEnrichment,
    required this.isPremium,
  });

  @override
  List<Object?> get props => [
        meta,
        totals,
        budget,
        categoryBreakdown,
        keyInsights,
        trend,
        paymentMethods,
        topMerchants,
        savingsOpportunity,
        topSpendingDays,
        aiEnrichment,
        isPremium,
      ];
}
