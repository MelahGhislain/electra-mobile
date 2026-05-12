import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/common/blocs/locale_cubit.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/l10n/app_localizations.dart';
import 'package:electra/presentation/home/bloc/home_cubit.dart';
import 'package:electra/presentation/home/utils/home_summary.dart';
import 'package:electra/presentation/home/utils/home_utils.dart';
import 'package:electra/presentation/home/widgets/home_header.dart';
import 'package:electra/presentation/home/widgets/home_setup_card.dart';
import 'package:electra/presentation/home/widgets/recent_activity_card.dart';
import 'package:electra/presentation/home/widgets/this_month_card.dart';
import 'package:electra/presentation/home/widgets/today_spending_card.dart';
import 'package:electra/presentation/home/widgets/top_spending_today_card.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_state.dart';
import 'package:electra/presentation/settings/blocs/user_cubit.dart';
import 'package:electra/presentation/settings/blocs/user_state.dart';
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
    // Fire both loads — HomeCubit and LocaleCubit are triggered from the
    // UserCubit listener below once the user actually loads.
    context.read<PurchaseCubit>().loadPurchases();
    context.read<UserCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    final l = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        // ── Auth error → logout ──────────────────────────────────────────
        BlocListener<PurchaseCubit, PurchaseState>(
          listener: (context, state) {
            if (state is PurchaseFailure) {
              final msg = state.message.toLowerCase();
              if (msg.contains('session expired') ||
                  msg.contains('unauthori')) {
                context.read<AppAuthCubit>().onLogout();
              }
            }
          },
        ),

        // ── User loaded → wire HomeCubit + LocaleCubit ───────────────────
        BlocListener<UserCubit, UserState>(
          // Only react the first time user actually loads.
          listenWhen: (prev, curr) => curr is UserLoaded && prev is! UserLoaded,
          listener: (context, state) {
            if (state is UserLoaded) {
              context.read<HomeCubit>().load(state.user.id);
              context.read<LocaleCubit>().applyStoredLocale(
                state.user.settings?.locale,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<PurchaseCubit, PurchaseState>(
        builder: (context, purchaseState) {
          // ── Loading ────────────────────────────────────────────────────
          if (purchaseState is PurchaseLoading ||
              purchaseState is PurchaseInitial) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: isDark
                      ? AppColors.lightBackground
                      : AppColors.darkBackground,
                  strokeWidth: 2,
                ),
              ),
            );
          }

          // ── Error ──────────────────────────────────────────────────────
          if (purchaseState is PurchaseFailure) {
            return _ErrorScreen(
              message: purchaseState.message,
              onRetry: () => context.read<PurchaseCubit>().loadPurchases(),
            );
          }

          // ── Loaded ─────────────────────────────────────────────────────
          if (purchaseState is PurchaseLoaded) {
            return BlocBuilder<UserCubit, UserState>(
              // Only rebuild when the loaded user data actually changes —
              // ignore transient states like UserSaving, UserUpdated etc.
              buildWhen: (prev, curr) =>
                  curr is UserLoaded || curr is UserInitial,
              builder: (context, userState) {
                final userName = userState is UserLoaded
                    ? userState.user.name.split(' ').first
                    : '';
                final monthlyBudget = userState is UserLoaded
                    ? userState.user.settings?.monthlyBudget
                    : null;

                final purchases = purchaseState.purchases;

                // ── Derived data ─────────────────────────────────────────
                final summary = HomeSummary.fromPurchases(
                  l,
                  purchases,
                  monthlyBudget: monthlyBudget,
                );

                final todaySummary = TodaySummary.fromPurchases(purchases);

                final displayTotal = todaySummary.hasTodayPurchases
                    ? todaySummary.todayTotal
                    : _lastPurchaseAmount(purchases);

                final displaySummary = TodaySummary(
                  todayTotal: displayTotal,
                  yesterdayTotal: todaySummary.yesterdayTotal,
                  hasTodayPurchases: todaySummary.hasTodayPurchases,
                );

                final topRows = todaySummary.hasTodayPurchases
                    ? RawSpendingHelper.forToday(l, purchases)
                    : RawSpendingHelper.forLastPurchases(l, purchases);

                final recentItems = RecentActivityHelper.getRecent(
                  l,
                  purchases,
                  count: 3,
                );

                return Scaffold(
                  body: SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        // ── 1. Header ──────────────────────────────────
                        SliverToBoxAdapter(
                          child: HomeHeader(
                            name: userName,
                            date: DateFormat.yMMMMEEEEd(
                              locale,
                            ).format(DateTime.now()),
                            showInsightBanner:
                                displaySummary.spendingLessThanUsual,
                            insightBannerText: l.homeYoureSpendingLessThanUsual,
                          ),
                        ),

                        // ── 2. Setup card ──────────────────────────────
                        SliverToBoxAdapter(child: HomeSetupCard()),

                        // ── 3. Today's Spending ────────────────────────
                        SliverToBoxAdapter(
                          child: TodaySpendingCard(
                            todaySummary: displaySummary,
                            monthlyBudget: monthlyBudget,
                          ),
                        ),

                        // ── 4. Top Spending Today ──────────────────────
                        if (topRows.isNotEmpty)
                          SliverToBoxAdapter(
                            child: TopSpendingTodayCard(
                              rows: topRows,
                              onViewAll: () =>
                                  context.goNamed(RouteNames.purchase),
                            ),
                          ),

                        // ── 5. This Month ──────────────────────────────
                        SliverToBoxAdapter(
                          child: ThisMonthCard(summary: summary),
                        ),

                        // ── 6. Recent Activity ─────────────────────────
                        SliverToBoxAdapter(
                          child: RecentActivityCard(
                            items: recentItems,
                            onViewAll: () =>
                                context.goNamed(RouteNames.purchase),
                          ),
                        ),

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
      ),
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
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Scaffold(
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
                  color: theme.iconTheme.color,
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
                    backgroundColor: theme.appBarTheme.foregroundColor,
                    foregroundColor: theme.appBarTheme.backgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l.tryAgain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
