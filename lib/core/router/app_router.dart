
import 'package:electra/presentation/onboading/pages/onboarding.dart';
import 'package:electra/presentation/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
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
      ],
    );
  }
}