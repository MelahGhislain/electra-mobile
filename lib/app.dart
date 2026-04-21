import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/common/blocs/language_cubit.dart';
import 'package:electra/core/configs/theme/app_theme.dart';
import 'package:electra/core/router/app_router.dart';
import 'package:electra/common/blocs/theme_cubit.dart';
import 'package:electra/common/blocs/receipt/receipt_cubit.dart';
import 'package:electra/presentation/auth/bloc/auth_cubit.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/onboading/bloc/onboarding_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = sl<AppAuthCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
        BlocProvider<OnboardingCubit>(create: (_) => OnboardingCubit()),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            loginUseCase: sl(),
            registerUseCase: sl(),
            logoutUseCase: sl(),
            socialLoginUseCase: sl(),
            repository: sl(),
          ),
        ),
        BlocProvider<ReceiptCubit>(create: (_) => ReceiptCubit(sl())),
        BlocProvider<VoiceCubit>(
          create: (_) => VoiceCubit(
            startVoiceStream: sl(),
            stopVoiceStream: sl(),
            listenVoiceStream: sl(),
            repository: sl(),
          ),
        ),
        BlocProvider<PurchaseCubit>(create: (_) => PurchaseCubit(sl())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Electra',
            theme: AppTheme.lightTheme, // or let the system decide
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode, // respects user's system setting
            routerConfig: AppRouter.createRouter(authCubit),
          );
        },
      ),
    );
  }
}
