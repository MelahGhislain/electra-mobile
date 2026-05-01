import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/presentation/home/widgets/top_spending_today_card.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TODAY SUMMARY
// ─────────────────────────────────────────────────────────────────────────────

class TodaySummary {
  final double todayTotal;
  final double yesterdayTotal;
  final bool hasTodayPurchases;

  const TodaySummary({
    required this.todayTotal,
    required this.yesterdayTotal,
    required this.hasTodayPurchases,
  });

  factory TodaySummary.fromPurchases(List<Purchase> purchases) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    final todayPurchases = purchases
        .where((p) => !p.isDeleted && isSameDay(p.purchaseDate, now))
        .toList();

    final yesterdayPurchases = purchases
        .where((p) => !p.isDeleted && isSameDay(p.purchaseDate, yesterdayStart))
        .toList();

    return TodaySummary(
      todayTotal: todayPurchases.fold(0, (s, p) => s + p.totals.amount),
      yesterdayTotal: yesterdayPurchases.fold(0, (s, p) => s + p.totals.amount),
      hasTodayPurchases: todayPurchases.isNotEmpty,
    );
  }

  /// Returns null when there is no yesterday data to compare
  double? get percentVsYesterday {
    if (yesterdayTotal == 0) return null;
    return ((todayTotal - yesterdayTotal) / yesterdayTotal) * 100;
  }

  bool get spendingLessThanUsual {
    final p = percentVsYesterday;
    return p != null && p < 0;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTH EXTRAS  (days left, safe daily spend)
// ─────────────────────────────────────────────────────────────────────────────

class MonthExtras {
  final int daysLeft;
  final double safeDailySpend;

  const MonthExtras({required this.daysLeft, required this.safeDailySpend});

  factory MonthExtras.compute({
    required double budget,
    required double spentThisMonth,
  }) {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0).day;
    final daysLeft = (lastDay - now.day).clamp(0, lastDay);
    final remaining = (budget - spentThisMonth).clamp(0.0, double.infinity);
    return MonthExtras(
      daysLeft: daysLeft,
      safeDailySpend: daysLeft > 0 ? remaining / daysLeft : 0,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RAW SPENDING HELPER
// Aggregates purchases into per-category rows WITHOUT any grouping.
// Uses CategoryMeta directly so colors/icons match the existing map exactly.
// ─────────────────────────────────────────────────────────────────────────────

class RawSpendingHelper {
  /// Build rows from today's (or provided) purchases.
  /// Returns rows sorted descending by amount, capped at [maxRows].
  static List<RawSpendingRow> buildRows(
    List<Purchase> purchases, {
    int maxRows = 6,
  }) {
    final Map<String, double> totals = {};

    for (final p in purchases) {
      for (final item in p.activeItems) {
        final key = item.category.normalizedName.trim().toLowerCase();
        totals[key] = (totals[key] ?? 0) + item.totalPrice;
      }
    }

    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(maxRows).map((e) {
      final meta = CategoryMeta.fromKey(e.key);
      return RawSpendingRow(
        label: meta.label,
        amount: e.value,
        color: meta.color,
        icon: meta.icon,
      );
    }).toList();
  }

  /// Convenience: filter purchases to today then build rows.
  static List<RawSpendingRow> forToday(
    List<Purchase> allPurchases, {
    int maxRows = 6,
  }) {
    final now = DateTime.now();
    final today = allPurchases
        .where(
          (p) =>
              !p.isDeleted &&
              p.purchaseDate.year == now.year &&
              p.purchaseDate.month == now.month &&
              p.purchaseDate.day == now.day,
        )
        .toList();
    return buildRows(today, maxRows: maxRows);
  }

  /// Fallback: use the last N purchases when there are no today purchases.
  static List<RawSpendingRow> forLastPurchases(
    List<Purchase> allPurchases, {
    int maxRows = 6,
  }) {
    final sorted = allPurchases.where((p) => !p.isDeleted).toList()
      ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    final recent = sorted.take(5).toList();
    return buildRows(recent, maxRows: maxRows);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RECENT ACTIVITY HELPER
// ─────────────────────────────────────────────────────────────────────────────

class RecentActivityItem {
  final String title;
  final String categoryLabel;
  final Color categoryColor;
  final IconData categoryIcon;
  final double amount;
  final DateTime date;

  const RecentActivityItem({
    required this.title,
    required this.categoryLabel,
    required this.categoryColor,
    required this.categoryIcon,
    required this.amount,
    required this.date,
  });
}

class RecentActivityHelper {
  static List<RecentActivityItem> getRecent(
    List<Purchase> purchases, {
    int count = 3,
  }) {
    final sorted = purchases.where((p) => !p.isDeleted).toList()
      ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

    return sorted.take(count).map((p) {
      final firstItem = p.activeItems.isNotEmpty ? p.activeItems.first : null;
      final key = firstItem?.category.normalizedName ?? 'other';
      final meta = CategoryMeta.fromKey(key);

      return RecentActivityItem(
        title: p.merchant?.name ?? 'Purchase',
        categoryLabel: meta.label,
        categoryColor: meta.color,
        categoryIcon: meta.icon,
        amount: p.totals.amount,
        date: p.purchaseDate,
      );
    }).toList();
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final dateStart = DateTime(date.year, date.month, date.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    final h = date.hour;
    final m = date.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hDisplay = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final timeStr = '$hDisplay:$m $period';

    if (dateStart == todayStart) return 'Today, $timeStr';
    if (dateStart == yesterdayStart) return 'Yesterday, $timeStr';
    return '${date.month}/${date.day}/${date.year}, $timeStr';
  }
}
