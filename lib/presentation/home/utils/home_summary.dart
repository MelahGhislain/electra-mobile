import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/presentation/home/model/spending_category.dart';

/// All derived values the home screen needs, computed once from purchases.
class HomeSummary {
  final double spentThisMonth;
  final double budget; // from user settings, 0 if not set
  final double avgDaily;
  final double progress; // spentThisMonth / budget, clamped 0–1
  final List<SpendingCategory> categoryBreakdown;

  const HomeSummary({
    required this.spentThisMonth,
    required this.budget,
    required this.avgDaily,
    required this.progress,
    required this.categoryBreakdown,
  });

  factory HomeSummary.fromPurchases(
    List<Purchase> purchases, {
    double? monthlyBudget,
  }) {
    final now = DateTime.now();

    // ── Filter to current month ───────────────────────────────────────────
    final thisMonth = purchases.where((p) {
      return p.purchaseDate.year == now.year &&
          p.purchaseDate.month == now.month &&
          !p.isDeleted;
    }).toList();

    // ── Total spent this month ────────────────────────────────────────────
    final spent = thisMonth.fold<double>(
      0.0,
      (sum, p) => sum + p.totals.amount,
    );

    // ── Avg daily (days elapsed so far this month, min 1) ────────────────
    final daysElapsed = now.day.toDouble();
    final avg = daysElapsed > 0 ? spent / daysElapsed : 0.0;

    // ── Budget + progress ─────────────────────────────────────────────────
    final budget = monthlyBudget ?? 0.0;
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

    // ── Category breakdown ────────────────────────────────────────────────
    // Aggregate all active items from this month's purchases by category.
    final Map<String, double> categoryTotals = {};
    for (final purchase in thisMonth) {
      for (final item in purchase.activeItems) {
        final key = item.category.normalizedName.toLowerCase();
        categoryTotals[key] = (categoryTotals[key] ?? 0) + item.totalPrice;
      }
    }

    // Sort descending by amount, take top 6 for readability.
    final sorted = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final categories = sorted.take(6).map((entry) {
      final meta = CategoryMeta.fromKey(entry.key);
      return SpendingCategory(
        label: meta.label,
        amount: entry.value,
        color: meta.color,
      );
    }).toList();

    return HomeSummary(
      spentThisMonth: spent,
      budget: budget,
      avgDaily: avg,
      progress: progress,
      categoryBreakdown: categories,
    );
  }

  bool get hasBudget => budget > 0;

  String get budgetStatusMessage {
    if (!hasBudget) return 'No budget set for this month.';
    if (progress >= 1.0) return 'You have exceeded your monthly budget.';
    if (progress >= 0.85) return "Heads up! You're close to your budget.";
    return "Nice work! You're staying within budget 👍";
  }
}
