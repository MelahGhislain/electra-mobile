import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_state.dart';
import 'package:electra/presentation/purchase/pages/purchase_filter.dart';
import 'package:electra/presentation/purchase/widgets/spending/purchase_filter_sheet.dart';
import 'package:electra/presentation/purchase/widgets/spending/spending_active_filter_chips.dart';
import 'package:electra/presentation/purchase/widgets/spending/spending_category_tabs.dart';
import 'package:electra/presentation/purchase/widgets/spending/spending_day_header.dart';
import 'package:electra/presentation/purchase/widgets/spending/spending_empty_state.dart';
import 'package:electra/presentation/purchase/widgets/spending/spending_insight_banner.dart';
import 'package:electra/presentation/purchase/widgets/spending/spending_list_item.dart';
import 'package:electra/presentation/purchase/widgets/spending/spending_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({super.key});

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  PurchaseFilter _filter = const PurchaseFilter();

  // ── Filtering & Sorting ──────────────────────────────────────────────────

  List<Purchase> _applyFilter(List<Purchase> all) {
    var list = all.where((p) => !p.isDeleted).toList();

    final q = _filter.searchQuery?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      list = list.where((p) {
        final merchantMatch =
            (p.merchant?.name.toLowerCase().contains(q) ?? false);
        final itemMatch = p.items.any((i) => i.name.toLowerCase().contains(q));
        return merchantMatch || itemMatch;
      }).toList();
    }

    if (_filter.category != null) {
      list = list
          .where((p) => p.items.any((i) => i.category.name == _filter.category))
          .toList();
    }

    if (_filter.merchant != null) {
      list = list.where((p) => p.merchant?.name == _filter.merchant).toList();
    }

    if (_filter.dateFrom != null) {
      list = list.where((p) {
        final d = p.purchaseDate;
        return d.isAfter(_filter.dateFrom!.subtract(const Duration(days: 1))) &&
            d.isBefore(_filter.dateTo!.add(const Duration(days: 1)));
      }).toList();
    }

    switch (_filter.sort) {
      case PurchaseSortOption.newest:
        list.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
      case PurchaseSortOption.oldest:
        list.sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));
      case PurchaseSortOption.mostExpensive:
        list.sort((a, b) => b.totals.amount.compareTo(a.totals.amount));
      case PurchaseSortOption.cheapest:
        list.sort((a, b) => a.totals.amount.compareTo(b.totals.amount));
      case PurchaseSortOption.byName:
        list.sort(
          (a, b) => (a.merchant?.name ?? '').compareTo(b.merchant?.name ?? ''),
        );
    }

    return list;
  }

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

  List<String> _categories(List<Purchase> all) =>
      all.expand((p) => p.items.map((i) => i.category.name)).toSet().toList()
        ..sort();

  List<String> _merchants(List<Purchase> all) =>
      all
          .map((p) => p.merchant?.name)
          .whereType<String>()
          .where((n) => n != 'Unknown')
          .toSet()
          .toList()
        ..sort();

  Future<void> _openFilterSheet(List<Purchase> all) async {
    final result = await PurchaseFilterSheet.show(
      context,
      current: _filter,
      categories: _categories(all),
      merchants: _merchants(all),
    );
    if (result != null) setState(() => _filter = result);
  }

  void _navigateToDetail(BuildContext context, Purchase purchase) {
    context.pushNamed(
      RouteNames.purchaseDetail,
      pathParameters: {'purchaseId': purchase.id},
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        final allPurchases = state is PurchaseLoaded
            ? state.purchases
            : <Purchase>[];
        final filtered = _applyFilter(allPurchases);
        final grouped = _groupByDay(filtered);
        final sortedDays = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        final isFiltered =
            _filter.hasActiveFilters ||
            (_filter.searchQuery?.isNotEmpty ?? false);

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.darkBackground,
              onRefresh: () => context.read<PurchaseCubit>().loadPurchases(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ── Header ─────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _SpendingHeader(
                      filterCount: _filter.activeFilterCount,
                      onFilterTap: () => _openFilterSheet(allPurchases),
                    ),
                  ),

                  // ── Search bar ─────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: SpendingSearchBar(
                        initialValue: _filter.searchQuery,
                        onChanged: (q) => setState(
                          () => _filter = _filter.copyWith(searchQuery: q),
                        ),
                        onClear: () => setState(
                          () => _filter = _filter.copyWith(clearSearch: true),
                        ),
                      ),
                    ),
                  ),

                  // ── Category tabs ──────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SpendingCategoryTabs(
                        selectedCategory: _filter.category,
                        onCategoryChanged: (cat) => setState(
                          () => _filter = cat == null
                              ? _filter.copyWith(clearCategory: true)
                              : _filter.copyWith(category: cat),
                        ),
                      ),
                    ),
                  ),

                  // ── Active filter chips ────────────────────────────────
                  if (_filter.hasActiveFilters)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SpendingActiveFilterChips(
                          filter: _filter,
                          onFilterChanged: (f) => setState(() => _filter = f),
                        ),
                      ),
                    ),

                  // ── Insight banner ─────────────────────────────────────
                  if (!isFiltered && allPurchases.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(RouteNames.insights);
                          },
                          child: SpendingInsightBanner(
                            message: 'You spent 18% more on food this week',
                          ),
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // ── List / Loading / Empty ─────────────────────────────
                  if (state is PurchaseLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkBackground,
                        ),
                      ),
                    )
                  else if (filtered.isEmpty)
                    SliverFillRemaining(
                      child: SpendingEmptyState(
                        isFiltered: isFiltered,
                        onClearFilters: () =>
                            setState(() => _filter = const PurchaseFilter()),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildListItem(
                            index,
                            sortedDays,
                            grouped,
                            context,
                          ),
                          childCount: _listItemCount(sortedDays, grouped),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int _listItemCount(
    List<DateTime> days,
    Map<DateTime, List<Purchase>> grouped,
  ) => days.fold(0, (sum, d) => sum + 1 + (grouped[d]?.length ?? 0));

  Widget _buildListItem(
    int index,
    List<DateTime> days,
    Map<DateTime, List<Purchase>> grouped,
    BuildContext context,
  ) {
    int cursor = 0;
    for (final day in days) {
      final purchases = grouped[day]!;
      if (index == cursor) {
        final dayTotal = purchases.fold(0.0, (sum, p) => sum + p.totals.amount);
        return SpendingDayHeader(
          date: day,
          count: purchases.length,
          total: dayTotal,
        );
      }
      cursor++;
      for (final purchase in purchases) {
        if (index == cursor) {
          return SpendingListItem(
            purchase: purchase,
            onTap: () => _navigateToDetail(context, purchase),
          );
        }
        cursor++;
      }
    }
    return const SizedBox.shrink();
  }
}

// ── Private header widget ─────────────────────────────────────────────────

class _SpendingHeader extends StatelessWidget {
  final int filterCount;
  final VoidCallback onFilterTap;

  const _SpendingHeader({required this.filterCount, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Spending',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightText,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Track your spending, stay in control',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onFilterTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: filterCount > 0
                    ? AppColors.primary
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: filterCount > 0
                      ? AppColors.primary
                      : AppColors.dividerLight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                    color: filterCount > 0 ? Colors.white : AppColors.lightText,
                  ),
                  if (filterCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Colors.white,
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
    );
  }
}
