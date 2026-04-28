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
  List<Object?> get props => [
    label,
    period,
    from,
    to,
    previousFrom,
    previousTo,
  ];
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
  List<Object?> get props => [
    amount,
    currency,
    delta,
    deltaPercent,
    trend,
    previousAmount,
  ];
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
  List<Object?> get props => [
    monthlyBudget,
    currency,
    spent,
    remaining,
    progressPercent,
    isOnTrack,
  ];
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
  List<Object?> get props => [
    name,
    normalizedName,
    color,
    amount,
    currency,
    percent,
    count,
  ];
}

// ── Key Insight ───────────────────────────────────────────────────────────────

enum KeyInsightType { savings, categoryChange, dailyAverage, highestDay }

class KeyInsight extends Equatable {
  final KeyInsightType type;
  final String value;
  final String label;
  final TrendDirection? trend;
  final double? numericValue;
  final String? date;

  const KeyInsight({
    required this.type,
    required this.value,
    required this.label,
    this.trend,
    this.numericValue,
    this.date,
  });

  @override
  List<Object?> get props => [type, value, label, trend, numericValue, date];
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
  ];
}
