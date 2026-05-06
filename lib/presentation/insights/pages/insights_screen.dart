import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/insights/bloc/insights_cubit.dart';
import 'package:electra/presentation/insights/bloc/insights_state.dart';
import 'package:electra/presentation/insights/widgets/insights_header.dart';
import 'package:electra/presentation/insights/widgets/insights_totals_card.dart';
import 'package:electra/presentation/insights/widgets/insights_top_categories.dart';
import 'package:electra/presentation/insights/widgets/insights_spending_overview.dart';
import 'package:electra/presentation/insights/widgets/insights_states.dart';
import 'package:electra/presentation/insights/widgets/insights_key_insights_grid.dart';
import 'package:electra/presentation/insights/widgets/insights_trend_section.dart';
import 'package:electra/presentation/insights/widgets/insights_bottom_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  // Called every time this branch tab is tapped/selected
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Spending insights',
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

class _InsightsContent extends StatelessWidget {
  final InsightsLoaded state;
  const _InsightsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final insights = state.insights;

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
              period: state.period,
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
            _SectionHeader(
              title: 'Spending overview',
              trailing: 'View by categories',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InsightsSpendingOverview(
                categories: insights.categoryBreakdown,
                total: insights.totals.amount,
                currency: insights.totals.currency,
              ),
            ),

            const SizedBox(height: 24),

            // ── Key insights ──────────────────────────────────────────
            _SectionHeader(title: 'Key insights'),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InsightsKeyInsightsGrid(insights: insights.keyInsights),
            ),

            const SizedBox(height: 24),

            // ── Top spending categories ───────────────────────────────
            _SectionHeader(
              title: 'Top spending categories',
              trailing: 'View all',
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
              title: 'Spending trend',
              trailing:
                  'vs ${_previousLabel(insights.meta.label, state.period)}',
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

  String _previousLabel(String currentLabel, String period) {
    try {
      if (period == 'monthly') {
        final parts = currentLabel.split(' ');
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        const fullMonths = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        final idx = fullMonths.indexOf(parts[0]);
        if (idx >= 0) {
          final prevIdx = (idx - 1 + 12) % 12;
          final year = idx == 0 ? int.parse(parts[1]) - 1 : int.parse(parts[1]);
          return '${months[prevIdx]} $year';
        }
      }
    } catch (_) {}
    return 'Previous';
  }
}

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
