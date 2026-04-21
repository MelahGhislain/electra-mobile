import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/core/utils/storage/onboarding_storage.dart';
import 'package:electra/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      context.read<AppAuthCubit>().checkAuthStatus(), // local only, no network
      Future.delayed(const Duration(seconds: 2)),
    ]);

    if (!mounted) return;

    final authState = context.read<AppAuthCubit>().state;

    if (authState.isAuthenticated) {
      // Always go to Home — Home decides purchases routing
      context.goNamed(RouteNames.home);
    } else {
      await _routeUnauthenticatedUser();
    }
  }

  // Route unauthenticated users: onboarding or sign in
  Future<void> _routeUnauthenticatedUser() async {
    final hasSeen = await sl<OnboardingStorage>().hasSeenOnboarding;
    if (!mounted) return;
    context.goNamed(hasSeen ? RouteNames.signIn : RouteNames.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FlutterLogo(size: 72),
            const SizedBox(height: 24),
            Text(
              'Electra',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.lightText,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
