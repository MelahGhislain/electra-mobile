import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_state.dart';
import 'package:electra/presentation/purchase/pages/purchase_filter.dart';
import 'package:electra/presentation/purchase/widgets/purchase/active_filter_chips.dart';
import 'package:electra/presentation/purchase/widgets/purchase/purchase_day_header.dart';
import 'package:electra/presentation/purchase/widgets/purchase/purchase_empty_state.dart';
import 'package:electra/presentation/purchase/widgets/purchase/purchase_filter_sheet.dart';
import 'package:electra/presentation/purchase/widgets/purchase/purchase_list_item.dart';
import 'package:electra/presentation/purchase/widgets/purchase/purchase_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  PurchaseFilter _filter = const PurchaseFilter();

  // ── Filtering & Sorting ──────────────────────────────────────────────────

  List<Purchase> _applyFilter(List<Purchase> all) {
    var list = all.where((p) => !p.isDeleted).toList();

    // Search
    final q = _filter.searchQuery?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      list = list.where((p) {
        final merchantMatch =
            (p.merchant?.name.toLowerCase().contains(q) ?? false);
        final itemMatch =
            p.items.any((i) => i.name.toLowerCase().contains(q));
        return merchantMatch || itemMatch;
      }).toList();
    }

    // Category filter
    if (_filter.category != null) {
      list = list.where((p) => p.items
          .any((i) => i.category.name == _filter.category)).toList();
    }

    // Merchant filter
    if (_filter.merchant != null) {
      list = list
          .where((p) => p.merchant?.name == _filter.merchant)
          .toList();
    }

    // Date range
    if (_filter.dateFrom != null) {
      list = list.where((p) {
        final d = p.purchaseDate;
        return d.isAfter(_filter.dateFrom!.subtract(const Duration(days: 1))) &&
            d.isBefore(_filter.dateTo!.add(const Duration(days: 1)));
      }).toList();
    }

    // Sort
    switch (_filter.sort) {
      case PurchaseSortOption.newest:
        list.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
        break;
      case PurchaseSortOption.oldest:
        list.sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));
        break;
      case PurchaseSortOption.mostExpensive:
        list.sort((a, b) => b.totals.amount.compareTo(a.totals.amount));
        break;
      case PurchaseSortOption.cheapest:
        list.sort((a, b) => a.totals.amount.compareTo(b.totals.amount));
        break;
      case PurchaseSortOption.byName:
        list.sort((a, b) =>
            (a.merchant?.name ?? '').compareTo(b.merchant?.name ?? ''));
        break;
    }

    return list;
  }

  /// Groups purchases by calendar day
  Map<DateTime, List<Purchase>> _groupByDay(List<Purchase> purchases) {
    final map = <DateTime, List<Purchase>>{};
    for (final p in purchases) {
      final day = DateTime(
        p.purchaseDate.year,
        p.purchaseDate.month,
        p.purchaseDate.day,
      );
      map.putIfAbsent(day, () => []).add(p);
    }
    return map;
  }

  List<String> _categories(List<Purchase> all) => all
      .expand((p) => p.items.map((i) => i.category.name))
      .toSet()
      .toList()
    ..sort();

  List<String> _merchants(List<Purchase> all) => all
      .map((p) => p.merchant?.name)
      .whereType<String>()
      .where((n) => n != 'Unknown')
      .toSet()
      .toList()
    ..sort();

  // ── Filter sheet ─────────────────────────────────────────────────────────

  Future<void> _openFilterSheet(List<Purchase> all) async {
    final result = await PurchaseFilterSheet.show(
      context,
      current: _filter,
      categories: _categories(all),
      merchants: _merchants(all),
    );
    if (result != null) setState(() => _filter = result);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        final allPurchases =
            state is PurchaseLoaded ? state.purchases : <Purchase>[];
        final filtered = _applyFilter(allPurchases);
        final grouped = _groupByDay(filtered);
        final sortedDays = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        final isFiltered =
            _filter.hasActiveFilters || (_filter.searchQuery?.isNotEmpty ?? false);
        final filterCount = _filter.activeFilterCount;

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      const Text(
                        'Purchases',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      // Total count badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${filtered.length}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── Search + Filter ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: PurchaseSearchBar(
                          initialValue: _filter.searchQuery,
                          onChanged: (q) => setState(() => _filter =
                              _filter.copyWith(searchQuery: q)),
                          onClear: () => setState(() => _filter =
                              _filter.copyWith(clearSearch: true)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filter button
                      GestureDetector(
                        onTap: () => _openFilterSheet(allPurchases),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: filterCount > 0
                                ? const Color(0xFF1F2937)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: filterCount > 0
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFFE5E7EB),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                size: 20,
                                color: filterCount > 0
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                              if (filterCount > 0)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF97316),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Active filter chips ───────────────────────────────────
                if (_filter.hasActiveFilters) ...[
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ActiveFilterChips(
                      filter: _filter,
                      onFilterChanged: (f) => setState(() => _filter = f),
                    ),
                  ),
                ],

                const SizedBox(height: 4),

                // ── List ──────────────────────────────────────────────────
                Expanded(
                  child: state is PurchaseLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                          ? PurchaseEmptyState(
                              isFiltered: isFiltered,
                              onClearFilters: () => setState(
                                  () => _filter = const PurchaseFilter()),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                              itemCount: _listItemCount(sortedDays, grouped),
                              itemBuilder: (context, index) =>
                                  _buildListItem(index, sortedDays, grouped),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── List builder helpers ─────────────────────────────────────────────────

  /// Total items = one header + purchases per day
  int _listItemCount(
    List<DateTime> days,
    Map<DateTime, List<Purchase>> grouped,
  ) {
    return days.fold(0, (sum, d) => sum + 1 + (grouped[d]?.length ?? 0));
  }

  Widget _buildListItem(
    int index,
    List<DateTime> days,
    Map<DateTime, List<Purchase>> grouped,
  ) {
    int cursor = 0;
    for (final day in days) {
      final purchases = grouped[day]!;

      // Header
      if (index == cursor) {
        final dayTotal =
            purchases.fold(0.0, (sum, p) => sum + p.totals.amount);
        return PurchaseDayHeader(
          date: day,
          count: purchases.length,
          total: dayTotal,
        );
      }
      cursor++;

      // Items
      for (final purchase in purchases) {
        if (index == cursor) {
          return PurchaseListItem(
            purchase: purchase,
            onTap: () {
              // TODO: navigate to purchase detail
            },
          );
        }
        cursor++;
      }
    }
    return const SizedBox.shrink();
  }
}
