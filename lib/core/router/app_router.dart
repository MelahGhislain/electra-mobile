import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/common/widgets/layout/layout_scaffold.dart';
import 'package:electra/core/router/go_router_refresh_stream.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/presentation/auth/pages/signin_page.dart';
import 'package:electra/presentation/auth/pages/signup_page.dart';
import 'package:electra/presentation/home/pages/home.dart';
import 'package:electra/presentation/insights/bloc/insights_cubit.dart';
import 'package:electra/presentation/insights/pages/insights_screen.dart';
import 'package:electra/presentation/onboading/bloc/onboarding_cubit.dart';
import 'package:electra/presentation/onboading/pages/onboarding.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase_detail/purchase_detail_cubit.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/purchase/pages/expense_recorder.dart';
import 'package:electra/presentation/purchase/pages/spending_detail_screen.dart';
import 'package:electra/presentation/purchase/pages/spending_screen.dart';
import 'package:electra/presentation/settings/pages/settings_screen.dart';
import 'package:electra/presentation/splash/splash.dart';
import 'package:electra/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  // Public routes — accessible without auth
  static const _publicRoutes = {
    '/sign-in',
    '/sign-up',
    '/', // splash
    '/onboarding',
  };

  static GoRouter createRouter(AppAuthCubit authCubit) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      debugLogDiagnostics: true,

      // Re-evaluates redirect() whenever AppAuthCubit emits
      refreshListenable: GoRouterRefreshStream(authCubit.stream),

      redirect: (context, state) {
        final authState = authCubit.state;
        final location = state.matchedLocation;
        final isPublic = _publicRoutes.contains(location);

        // Still bootstrapping — stay on splash, don't redirect yet
        if (authState.isUnknown) {
          return location == '/' ? null : '/';
        }

        // Unauthenticated user trying to access a protected route
        if (!authState.isAuthenticated && !isPublic) {
          return '/sign-in';
        }

        // Authenticated user trying to access auth pages
        // (redirect handled by splash after purchase check)
        if (authState.isAuthenticated &&
            (location == '/sign-in' || location == '/sign-up')) {
          // Don't redirect here — let splash handle the post-login destination
          return '/';
        }

        return null; // no redirect needed
      },

      routes: [
        // ── Public ───────────────────────────────────────────────────────────
        GoRoute(
          path: '/',
          name: RouteNames.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          name: RouteNames.onboarding,
          pageBuilder: (context, state) => MaterialPage(
            child: BlocProvider(
              create: (_) => OnboardingCubit(),
              child: const OnboardingScreen(),
            ),
          ),
        ),
        GoRoute(
          path: '/sign-in',
          name: RouteNames.signIn,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: '/sign-up',
          name: RouteNames.signUp,
          builder: (context, state) => const SignUpScreen(),
        ),

        // ── Protected: expense recorder (full-screen, no shell) ───────────
        GoRoute(
          path: '/expense-recorder',
          name: RouteNames.expenseRecorder,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl<PurchaseCubit>()),
                BlocProvider(
                  create: (_) => VoiceCubit(
                    startVoiceStream: sl(),
                    stopVoiceStream: sl(),
                    listenVoiceStream: sl(),
                    repository: sl(),
                  ),
                ),
              ],
              child: const ExpenseRecorderScreen(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
          ),
        ),

        GoRoute(
          path: '/purchase-detail/:purchaseId',
          name: RouteNames.purchaseDetail,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) {
            final id = state.pathParameters['purchaseId']!;

            return CustomTransitionPage(
              key: state.pageKey,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<PurchaseDetailCubit>(
                    create: (_) => PurchaseDetailCubit(
                      getPurchaseDetail: sl(),
                      createItem: sl(),
                      updateItem: sl(),
                      deleteItem: sl(),
                      purchaseCubit: sl<PurchaseCubit>(),
                    )..loadPurchase(id),
                  ),
                  BlocProvider<PurchaseCubit>(
                    create: (_) => PurchaseCubit(
                      getPurchases: sl(),
                      createPurchase: sl(),
                      updatePurchase: sl(),
                      deletePurchase: sl(),
                    ),
                  ),
                ],
                child: SpendingDetailScreen(purchaseId: id),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
            );
          },
        ),

        // ── Protected: bottom nav shell ───────────────────────────────────
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => BlocProvider.value(
            value: sl<PurchaseCubit>(),
            child: LayoutScaffold(navigationShell: navigationShell),
          ),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: RouteNames.home,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/purchase',
                  name: RouteNames.purchase,
                  builder: (context, state) => const SpendingScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/insights',
                  name: RouteNames.insights,
                  builder: (context, state) => BlocProvider(
                    create: (_) => InsightsCubit(sl()),
                    child: const InsightsScreen(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  name: RouteNames.settings,
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
