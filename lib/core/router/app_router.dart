import 'package:electra/common/widgets/layout/layout_scaffold.dart';
import 'package:electra/presentation/auth/pages/sign_in.dart';
import 'package:electra/presentation/auth/pages/sign_up.dart';
import 'package:electra/presentation/expense-recorder/pages/expense_recorder.dart';
import 'package:electra/presentation/home/pages/home.dart';
import 'package:electra/presentation/onboading/pages/onboarding.dart';
import 'package:electra/presentation/settings/pages/settings_screen.dart';
import 'package:electra/presentation/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

class AppRouter {
  static final _rootNavigationKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      navigatorKey: _rootNavigationKey,
      initialLocation: '/',

      // redirect: (context, state) {
      //   final status = authBloc.state.status;
      //   final isOnWelcome = state.matchedLocation == '/welcome';

      //   if (status == AuthenticationStatus.unauthenticated && isOnWelcome) {
      //     return '/welcome';
      //   }

      //   if (status == AuthenticationStatus.authenticated && !isOnWelcome) {
      //     return '/';
      //   }

      //   return null;
      // },
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          name: RouteNames.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),

        // GoRoute(
        //   path: '/sign-in',
        //   name: RouteNames.signIn,
        //   builder: (context, state) => const SignInScreen(),
        // ),
        // GoRoute(
        //   path: '/sign-up',
        //   name: RouteNames.signUp,
        //   builder: (context, state) => const SignUpScreen(),
        // ),
        // GoRoute(
        //   path: '/details/:id',
        //   name: 'details',
        //   builder: (context, state) {
        //     final id = state.pathParameters['id']!;
        //     return DetailsScreen(id: id);
        //   },
        // ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return LayoutScaffold(navigationShell: navigationShell);
          },
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
                  path: '/signin',
                  name: RouteNames.signIn,
                  builder: (context, state) => const SignInScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/expense-recorder',
                  name: RouteNames.expenseRecorder,
                  builder: (context, state) => const ExpenseRecorderScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/signup',
                  name: RouteNames.signUp,
                  builder: (context, state) => const SignUpScreen(),
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
