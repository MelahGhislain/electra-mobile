import 'package:electra/common/blocs/language_cubit.dart';
import 'package:electra/core/configs/theme/app_theme.dart';
import 'package:electra/core/router/app_router.dart';
import 'package:electra/common/blocs/theme_cubit.dart';
import 'package:electra/presentation/onboading/bloc/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
        BlocProvider<OnboardingCubit>(create: (_) => OnboardingCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Electra',
            theme: AppTheme.lightTheme, // or let the system decide
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode, // respects user's system setting
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
