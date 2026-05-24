import 'package:minata/core/configs/fonts.dart';
import 'package:minata/core/configs/theme/app_colors.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:minata/presentation/insights/bloc/insights_cubit.dart';
import 'package:minata/presentation/insights/bloc/insights_state.dart';
import 'package:minata/presentation/insights/widgets/insights_header.dart';
import 'package:minata/presentation/insights/widgets/insights_totals_card.dart';
import 'package:minata/presentation/insights/widgets/insights_top_categories.dart';
import 'package:minata/presentation/insights/widgets/insights_spending_overview.dart';
import 'package:minata/presentation/insights/widgets/insights_states.dart';
import 'package:minata/presentation/insights/widgets/insights_key_insights_grid.dart';
import 'package:minata/presentation/insights/widgets/insights_trend_section.dart';
import 'package:minata/presentation/insights/widgets/insights_bottom_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void activate() {
    super.activate();
    _load();
  }

  void _load() {
    context.read<InsightsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l.spendingInsights,
          style: TextStyle(
            fontSize: AppFontSize.xxl,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: theme.iconTheme.color,
                  size: AppFontSize.lg,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<InsightsCubit, InsightsState>(
        builder: (context, state) {
          if (state is InsightsLoading || state is InsightsInitial) {
            return const InsightsLoadingState();
          }
          if (state is InsightsFailure) {
            return InsightsErrorState(
              message: state.message,
              onRetry: () => context.read<InsightsCubit>().load(),
            );
          }
          if (state is InsightsLoaded) {
            return _InsightsContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _InsightsContent extends StatefulWidget {
  final InsightsLoaded state;
  const _InsightsContent({required this.state});

  @override
  State<_InsightsContent> createState() => _InsightsContentState();
}

class _InsightsContentState extends State<_InsightsContent> {
  SpendingOverviewView _overviewView = SpendingOverviewView.categories;

  @override
  Widget build(BuildContext context) {
    final insights = widget.state.insights;
    final l = AppLocalizations.of(context);

    return RefreshIndicator(
      backgroundColor: AppColors.lightBackground,
      color: AppColors.darkBackground,
      onRefresh: () => context.read<InsightsCubit>().load(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Period selector + navigation ──────────────────────────
            InsightsHeader(
              period: widget.state.period,
              label: insights.meta.label,
              onPrevious: () => context.read<InsightsCubit>().previousPeriod(),
              onNext: () => context.read<InsightsCubit>().nextPeriod(),
              onPeriodChanged: (p) =>
                  context.read<InsightsCubit>().setPeriod(p),
            ),

            const SizedBox(height: 12),

            // ── Total + budget card ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InsightsTotalsCard(
                totals: insights.totals,
                budget: insights.budget,
                periodLabel: insights.meta.label,
              ),
            ),

            const SizedBox(height: 20),

            // ── Spending overview (donut) ─────────────────────────────
            _OverviewSectionHeader(
              title: l.spendingOverview,
              selected: _overviewView,
              items: [
                (SpendingOverviewView.categories, l.categories),
                (SpendingOverviewView.merchants, l.merchants),
                (SpendingOverviewView.paymentMethods, l.paymentMethods),
              ],
              onChanged: (v) => setState(() => _overviewView = v),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InsightsSpendingOverview(
                categories: insights.categoryBreakdown,
                merchants: insights.topMerchants,
                paymentMethods: insights.paymentMethods,
                total: insights.totals.amount,
                currency: insights.totals.currency,
                view: _overviewView,
              ),
            ),

            const SizedBox(height: 24),

            // ── Key insights ──────────────────────────────────────────
            _SectionHeader(title: l.keyInsights),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InsightsKeyInsightsGrid(insights: insights.keyInsights),
            ),

            const SizedBox(height: 24),

            // ── Top spending categories ───────────────────────────────
            _SectionHeader(
              title: l.topSpendingCategories,
              // trailing: l.viewAll,
              hideDropdown: true,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InsightsTopCategories(
                categories: insights.categoryBreakdown,
              ),
            ),

            const SizedBox(height: 24),

            // ── Spending trend ────────────────────────────────────────
            _SectionHeader(
              title: l.spendingTrend,
              trailing: 'vs ${_previousLabel(context, widget.state.period)}',
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InsightsTrendSection(trend: insights.trend),
            ),

            const SizedBox(height: 24),

            // ── Payment + Merchant + Savings row ──────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InsightsBottomRow(
                paymentMethods: insights.paymentMethods,
                merchants: insights.topMerchants,
                savingsOpportunity: insights.savingsOpportunity,
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _previousLabel(BuildContext context, String period) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    try {
      if (period == 'monthly') {
        final now = DateTime.now();
        final previousMonth = DateTime(now.year, now.month - 1);
        return DateFormat.yMMM(locale).format(previousMonth);
      }
    } catch (_) {}

    return l.previous;
  }
}

// ── Overview section header with anchored popup-menu dropdown ─────────────────

class _OverviewSectionHeader extends StatelessWidget {
  final String title;
  final SpendingOverviewView selected;
  final List<(SpendingOverviewView, String)> items;
  final ValueChanged<SpendingOverviewView> onChanged;

  const _OverviewSectionHeader({
    required this.title,
    required this.selected,
    required this.items,
    required this.onChanged,
  });

  void _openMenu(BuildContext context) {
    final theme = Theme.of(context);

    // Find the position of the tapped button in the screen
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu<SpendingOverviewView>(
      context: context,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor),
      ),
      elevation: 4,
      // Pin the right edge of the menu to the right edge of the row,
      // and open it just below the row.
      position: RelativeRect.fromLTRB(
        offset.dx + size.width - 180,
        offset.dy + size.height + 4,
        offset.dx + size.width,
        0,
      ),
      items: items.map((entry) {
        final (view, label) = entry;
        final isSelected = selected == view;
        return PopupMenuItem<SpendingOverviewView>(
          value: view,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  size: AppFontSize.md,
                  color: theme.textTheme.bodyMedium?.color,
                ),
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) onChanged(value);
    });
  }

  String get _selectedLabel => items.firstWhere((e) => e.$1 == selected).$2;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section title
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSize.md,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),

          // Pill-style dropdown button
          GestureDetector(
            onTap: () => _openMenu(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.viewByCategories(_selectedLabel),
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_drop_down_rounded, size: AppFontSize.xxxxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Generic section header ────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  final bool hideDropdown;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    this.trailing,
    this.hideDropdown = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSize.md,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          if (trailing != null)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    trailing!,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!hideDropdown)
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: AppFontSize.xxxxl,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
