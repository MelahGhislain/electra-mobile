import 'package:qleo/common/blocs/auth/app_auth_cubit.dart';
import 'package:qleo/common/blocs/currency/currency_formatter_scope.dart';
import 'package:qleo/common/blocs/locale_cubit.dart';
import 'package:qleo/core/configs/theme/app_theme.dart';
import 'package:qleo/core/router/app_router.dart';
import 'package:qleo/common/blocs/theme_cubit.dart';
import 'package:qleo/presentation/receipt/bloc/receipt/receipt_cubit.dart';
import 'package:qleo/domain/usecases/receipt/pick_receipt_image.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:qleo/presentation/auth/bloc/auth_cubit.dart';
import 'package:qleo/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:qleo/presentation/settings/blocs/user_cubit.dart';
import 'package:qleo/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppAuthCubit _authCubit;
  late final ThemeCubit _themeCubit;
  late final LocaleCubit _localeCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AppAuthCubit>();
    _themeCubit = ThemeCubit();
    _localeCubit = LocaleCubit();
    _router = AppRouter.createRouter(_authCubit);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider.value(value: _themeCubit),
        BlocProvider.value(value: _localeCubit),
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(
            getUser: sl(),
            updateUser: sl(),
            deleteUser: sl(),
            updateUserSetting: sl(),
          ),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            loginUseCase: sl(),
            registerUseCase: sl(),
            logoutUseCase: sl(),
            socialLoginUseCase: sl(),
            repository: sl(),
          ),
        ),
        BlocProvider<ReceiptCubit>(
          create: (_) => ReceiptCubit(
            pickReceiptImage: sl<PickReceiptImage>(),
            extractReceiptText: sl<ExtractReceiptText>(),
            processReceiptText: sl<ProcessReceiptText>(),
            purchaseCubit: sl<PurchaseCubit>(),
          ),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                // ── Localization ─────────────────────────────────────
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('fr'),
                  Locale('es'),
                  Locale('de'),
                  Locale('pt'),
                  Locale('zh'),
                  Locale('ja'),
                  Locale('ko'),
                  Locale('ar'),
                ],
                title: 'qleo',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: _router,
                debugShowCheckedModeBanner: false,

                // ── Global text scale clamp ───────────────────────────
                // Intercepts Flutter's text scaling before it reaches
                // any Text widget. Respects user accessibility settings
                // but caps at 1.3x so layouts never break.
                // No widget changes needed — this applies globally.
                builder: (context, child) {
                  final mediaQuery = MediaQuery.of(context);
                  return MediaQuery(
                    data: mediaQuery.copyWith(
                      textScaler: mediaQuery.textScaler.clamp(
                        minScaleFactor: 1.0,
                        maxScaleFactor: 1.3,
                      ),
                    ),
                    child: CurrencyProvider(child: child!),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
