import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/presentation/home/utils/home_summary.dart';
import 'package:electra/presentation/home/utils/home_utils.dart';
import 'package:electra/presentation/home/widgets/home_header.dart';
import 'package:electra/presentation/home/widgets/recent_activity_card.dart';
import 'package:electra/presentation/home/widgets/shimmer/home_shimmer.dart';
import 'package:electra/presentation/home/widgets/this_month_card.dart';
import 'package:electra/presentation/home/widgets/today_spending_card.dart';
import 'package:electra/presentation/home/widgets/top_spending_today_card.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_state.dart';
import 'package:electra/presentation/user/bloc/user_cubit.dart';
import 'package:electra/presentation/user/bloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PurchaseCubit>().loadPurchases();
    context.read<UserCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseCubit, PurchaseState>(
      listener: (context, state) {
        if (state is PurchaseLoaded && state.isEmpty) {
          context.goNamed(RouteNames.expenseRecorder);
        }
        if (state is PurchaseFailure) {
          final msg = state.message.toLowerCase();
          if (msg.contains('session expired') || msg.contains('unauthori')) {
            context.read<AppAuthCubit>().onLogout();
          }
        }
      },
      builder: (context, purchaseState) {
        if (purchaseState is PurchaseLoading ||
            purchaseState is PurchaseInitial) {
          return const HomeShimmer();
        }

        if (purchaseState is PurchaseFailure) {
          return _ErrorScreen(
            message: purchaseState.message,
            onRetry: () => context.read<PurchaseCubit>().loadPurchases(),
          );
        }

        if (purchaseState is PurchaseLoaded) {
          return BlocBuilder<UserCubit, UserState>(
            builder: (context, userState) {
              // ── User data ──────────────────────────────────────────────
              final userName = userState is UserLoaded
                  ? userState.user.name.split(' ').first
                  : '';
              final monthlyBudget = userState is UserLoaded
                  ? userState.user.settings?.monthlyBudget
                  : null;

              final purchases = purchaseState.purchases;

              // ── Derived data ───────────────────────────────────────────

              // Monthly summary
              final summary = HomeSummary.fromPurchases(
                purchases,
                monthlyBudget: monthlyBudget,
              );

              // Today's total (% vs yesterday)
              final todaySummary = TodaySummary.fromPurchases(purchases);

              // Today spending amount — if no today purchases, show last purchase
              final displayTotal = todaySummary.hasTodayPurchases
                  ? todaySummary.todayTotal
                  : _lastPurchaseAmount(purchases);

              final displaySummary = TodaySummary(
                todayTotal: displayTotal,
                yesterdayTotal: todaySummary.yesterdayTotal,
                hasTodayPurchases: todaySummary.hasTodayPurchases,
              );

              // Top spending rows — raw categories, not grouped
              final topRows = todaySummary.hasTodayPurchases
                  ? RawSpendingHelper.forToday(purchases)
                  : RawSpendingHelper.forLastPurchases(purchases);

              // Recent activity (3 most recent purchases)
              final recentItems = RecentActivityHelper.getRecent(
                purchases,
                count: 3,
              );

              return Scaffold(
                backgroundColor: AppColors.lightBackground,
                body: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // ── 1. Header ─────────────────────────────────────
                      SliverToBoxAdapter(
                        child: HomeHeader(
                          name: userName,
                          date: DateFormat(
                            'EEEE, MMMM d, yyyy',
                          ).format(DateTime.now()),
                          showInsightBanner:
                              displaySummary.spendingLessThanUsual,
                          insightBannerText:
                              "You're spending less than usual. Great job!",
                        ),
                      ),

                      // ── 2. Today's Spending ───────────────────────────
                      SliverToBoxAdapter(
                        child: TodaySpendingCard(
                          todaySummary: displaySummary,
                          monthlyBudget: monthlyBudget,
                        ),
                      ),

                      // ── 3. Top Spending Today ─────────────────────────
                      if (topRows.isNotEmpty)
                        SliverToBoxAdapter(
                          child: TopSpendingTodayCard(
                            rows: topRows,
                            onViewAll: () =>
                                context.goNamed(RouteNames.purchase),
                          ),
                        ),

                      // ── 4. This Month ─────────────────────────────────
                      SliverToBoxAdapter(
                        child: ThisMonthCard(summary: summary),
                      ),

                      // // ── 5. Smart Insights ─────────────────────────────
                      // SliverToBoxAdapter(
                      //   child: SmartInsightsCard(onViewAll: () {}),
                      // ),

                      // ── 6. Recent Activity ────────────────────────────
                      SliverToBoxAdapter(
                        child: RecentActivityCard(
                          items: recentItems,
                          onViewAll: () => context.goNamed(RouteNames.purchase),
                        ),
                      ),

                      // ── 7. Saving Goal ────────────────────────────────
                      // const SliverToBoxAdapter(child: SavingGoalCard()),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  double _lastPurchaseAmount(List<Purchase> purchases) {
    final sorted = purchases.where((p) => !p.isDeleted).toList()
      ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    return sorted.isNotEmpty ? sorted.first.totals.amount : 0.0;
  }
}

// ─────────────────────────────────────────
// ERROR SCREEN
// ─────────────────────────────────────────

class _ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorScreen({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 56,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2937),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
