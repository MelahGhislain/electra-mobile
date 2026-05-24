import 'package:minata/common/blocs/auth/app_auth_cubit.dart';
import 'package:minata/common/blocs/locale_cubit.dart';
import 'package:minata/core/configs/theme/app_theme.dart';
import 'package:minata/core/router/app_router.dart';
import 'package:minata/common/blocs/theme_cubit.dart';
import 'package:minata/presentation/receipt/bloc/receipt/receipt_cubit.dart';
import 'package:minata/domain/usecases/receipt/pick_receipt_image.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:minata/presentation/auth/bloc/auth_cubit.dart';
import 'package:minata/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:minata/presentation/settings/blocs/user_cubit.dart';
import 'package:minata/service_locator.dart';
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
  // ✅ Created once in initState — never recreated on rebuild
  late final AppAuthCubit _authCubit;
  late final ThemeCubit _themeCubit;
  late final LocaleCubit _localeCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AppAuthCubit>();
    _themeCubit = ThemeCubit(); // HydratedBloc restores persisted state
    _localeCubit = LocaleCubit();
    _router = AppRouter.createRouter(
      _authCubit,
    ); // created once, never recreated
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
        ), // Used both in recorder and home screens
      ],
      child: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                // ── Localization ─────────────────────────────────────
                locale: locale, // null = follow device locale
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
                // ── rest of your existing config ─────────────────────
                title: 'Electra',
                theme: AppTheme.lightTheme, // or let the system decide
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode, // respects user's system setting
                routerConfig: _router,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
