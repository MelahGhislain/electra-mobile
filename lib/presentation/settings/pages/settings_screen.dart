import 'package:qleo/common/blocs/auth/app_auth_cubit.dart';
import 'package:qleo/common/blocs/currency/currency_formatter_scope.dart';
import 'package:qleo/common/blocs/locale_cubit.dart';
import 'package:qleo/common/blocs/theme_cubit.dart';
import 'package:qleo/common/widgets/buttons/main_icon_button.dart';
import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/core/configs/theme/app_colors.dart';
import 'package:qleo/core/router/route_names.dart';
import 'package:qleo/core/services/app_info_service.dart';
import 'package:qleo/core/utils/storage/onboarding_storage.dart';
import 'package:qleo/domain/entities/user/user.dart';
import 'package:qleo/domain/entities/user/user_settings.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:qleo/presentation/auth/bloc/auth_cubit.dart';
import 'package:qleo/presentation/auth/bloc/auth_state.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/budget_bottom_sheet.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/currency_bottom_sheet.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/delete_account_dialog.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/edit_profile_bottom_sheet.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/export_data_bottom_sheet.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/language_bottom_sheet.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/theme_bottom_sheet.dart';
import 'package:qleo/presentation/settings/widgets/logout_confirmation_dialog.dart';
import 'package:qleo/presentation/settings/widgets/profile_header_card.dart';
import 'package:qleo/presentation/settings/widgets/settings_section_header.dart';
import 'package:qleo/presentation/settings/widgets/settings_tile.dart';
import 'package:qleo/presentation/settings/widgets/settings_toggle_tile.dart';
import 'package:qleo/presentation/settings/blocs/user_cubit.dart';
import 'package:qleo/presentation/settings/blocs/user_state.dart';
import 'package:qleo/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = 'Loading...';
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadVersion();
    context.read<UserCubit>().loadUser();
    _themeMode = context.read<ThemeCubit>().state;
  }

  Future<void> _loadVersion() async {
    final v = await AppInfoService.getVersion();
    if (mounted) setState(() => _version = v);
  }

  // ── Auth ──────────────────────────────────────────────────────────────────

  Future<void> _showLogoutDialog(BuildContext context, User? user) async {
    final confirmed = await LogoutConfirmationDialog.show(context);
    if (confirmed && context.mounted) {
      context.read<AuthCubit>().logout(user);
      context.read<AppAuthCubit>().onLogout();
    }
  }

  String _themeLabel(ThemeMode mode, AppLocalizations l) => switch (mode) {
    ThemeMode.system => l.themeSystem,
    ThemeMode.light => l.themeLight,
    ThemeMode.dark => l.themeDark,
  };

  // String _currencyLabel(UserSettings? settings) {
  //   if (settings == null) return 'USD';
  //   try {
  //     final match = AppCurrency.values.firstWhere(
  //       (c) => c.code.toLowerCase() == settings.currency.toLowerCase(),
  //       orElse: () => AppCurrency.usd,
  //     );
  //     return match.code;
  //   } catch (_) {
  //     return settings.currency.toUpperCase();
  //   }
  // }
  String _currencyLabel(UserSettings? settings) {
  return settings?.currency.toUpperCase() ?? 'USD';
}

  String _languageLabel(UserSettings? settings) {
    final lang = AppLanguage.fromCode(settings?.locale);
    return lang.label;
  }

  String _budgetLabel(UserSettings? settings, AppLocalizations l, CurrencyFormatterScope fmt) {
    if (settings?.monthlyBudget == null || settings!.monthlyBudget! <= 0) {
      return l.budgetNotSet;
    }
    return l.budgetPerMonth(fmt.format(settings.monthlyBudget!));
  }

  String _subscriptionLabel(UserCubit cubit, AppLocalizations l) {
    if (!cubit.hasPremium) return 'Free · Tap to upgrade';
    // Check if annual or monthly
    final isAnnual =
        cubit.currentUser?.subscription?.productId?.contains('annual') ?? false;
    return isAnnual ? '👑 Premium · Annual' : '👑 Premium · Monthly';
  }

  // ── Sheet openers ─────────────────────────────────────────────────────────

  Future<void> _openThemeSheet() async {
    final result = await ThemeBottomSheet.show(context, _themeMode);
    if (result != null && mounted) {
      setState(() => _themeMode = result);
      context.read<ThemeCubit>().updateTheme(result);
    }
  }

  Future<void> _openLanguageSheet(User user) async {
    final current = AppLanguage.fromCode(user.settings?.locale);
    final result = await LanguageBottomSheet.show(context, current);
    if (result == null || !mounted) return;

    // 1. Save to backend (empty string = system default)
    await context.read<UserCubit>().updateUserSetting(user.id, {
      'locale': result.backendValue,
    });

    // 2. Apply immediately to the running app
    if (mounted) {
      context.read<LocaleCubit>().setLocale(result.code);
    }
  }

  // Future<void> _openCurrencySheet(User user) async {
  //   AppCurrency current = AppCurrency.usd;
  //   try {
  //     current = AppCurrency.values.firstWhere(
  //       (c) =>
  //           c.code.toLowerCase() ==
  //           (user.settings?.currency ?? '').toLowerCase(),
  //       orElse: () => AppCurrency.usd,
  //     );
  //   } catch (_) {}
  //   final result = await CurrencyBottomSheet.show(context, current);
  //   if (result != null && mounted) {
  //     await context.read<UserCubit>().updateUserSetting(user.id, {
  //       'currency': result.code,
  //     });
  //   }
  // }

  Future<void> _openCurrencySheet(User user) async {
    final result = await CurrencyBottomSheet.show(
      context,
      currentCode: user.settings?.currency,
    );
    print({result});
    if (result != null && mounted) {
      await context.read<UserCubit>().updateUserSetting(user.id, {
        'currency': result.code,
      });
    }
  }

  Future<void> _toggleNotifications(User user, bool value) async {
    await context.read<UserCubit>().updateUserSetting(user.id, {
      'pushNotification': value,
    });
  }

  Future<void> _openBudgetSheet(User user) async {
    await BudgetBottomSheet.show(
      context,
      userId: user.id,
      currentBudget: user.settings?.monthlyBudget,
    );
  }

  Future<void> _openEditProfile(User user) async {
    await EditProfileBottomSheet.show(context, user);
  }

  Future<void> _openExportData() async {
    await ExportDataBottomSheet.show(context);
  }

  Future<void> _openDeleteAccount(User user) async {
    final deleted = await DeleteAccountDialog.show(context, user.id);
    if (deleted && mounted) {
      context.read<AppAuthCubit>().onLogout();
    }
  }

  Future<void> _resetOnboarding(BuildContext context) async {
    await sl<OnboardingStorage>().resetOnboarding();
    if (!context.mounted) return;
    context.goNamed(RouteNames.onboarding);
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOut) {
              context.read<AppAuthCubit>().onLogout();
            } else if (state is AuthFailure) {
              _showErrorSnackbar(context, state.message);
            }
          },
        ),
        BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserFailure) {
              _showErrorSnackbar(context, state.message);
            }
            if (state is UserDeleted) {
              context.read<AppAuthCubit>().onLogout();
            }
          },
        ),
      ],
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          final cubit = context.read<UserCubit>();
          final user = cubit.currentUser;
          final settings = cubit.currentUserSettings;
          final isSaving = userState is UserSaving;
          final isLoading =
              userState is UserLoading || userState is UserInitial;
          final l = AppLocalizations.of(context);
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final fmt = CurrencyFormatterScope.of(context);

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                l.settingsTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: AppFontSize.xxl,
                ),
              ),
              actions: [
                // Non-blocking save indicator
                if (isSaving)
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                // Logout button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    final isAuthLoading =
                        authState is AuthEmailLoading ||
                        authState is AuthGoogleLoading;
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: MainIconButton(
                        icon: Icon(
                          Icons.logout_rounded,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          size: 20,
                        ),
                        onTap: isAuthLoading
                            ? null
                            : () => _showLogoutDialog(context, user),
                      ),
                    );
                  },
                ),
              ],
            ),

            body: isLoading && !isSaving
                ? Center(
                    child: CircularProgressIndicator(
                      color: isDark
                          ? AppColors.lightBackground
                          : AppColors.darkBackground,
                    ),
                  )
                : RefreshIndicator(
                    backgroundColor: AppColors.lightBackground,
                    color: AppColors.darkBackground,
                    onRefresh: () => context.read<UserCubit>().loadUser(),
                    child: SingleChildScrollView(
                      // Required so pull-to-refresh fires even on short content
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // ── Profile header ────────────────────────────
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ProfileHeaderCard(
                              name: user?.name ?? '—',
                              email: user?.email ?? '—',
                              avatarUrl: user?.picture,
                              onEditPressed: user != null
                                  ? () => _openEditProfile(user)
                                  : null,
                            ),
                          ),

                          // ── ACCOUNT ───────────────────────────────────
                          SettingsSectionHeader(title: l.settingsAccount),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.diamond_outlined,
                                title: l.subscription,
                                subtitle: _subscriptionLabel(cubit, l),
                                showChevron: true,
                                showDivider: true,
                                onTap: user != null
                                    ? () => context.pushNamed(
                                        RouteNames.subscription,
                                      )
                                    : null,
                              ),
                              SettingsTile(
                                icon: Icons.wallet_rounded,
                                title: l.settingsBudget,
                                subtitle: _budgetLabel(settings, l, fmt),
                                showChevron: true,
                                onTap: user != null
                                    ? () => _openBudgetSheet(user)
                                    : null,
                              ),
                            ],
                          ),

                          // ── GENERAL ───────────────────────────────────
                          SettingsSectionHeader(title: l.settingsGeneral),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.palette_outlined,
                                title: l.settingsTheme,
                                subtitle: _themeLabel(_themeMode, l),
                                showDivider: true,
                                showChevron: true,
                                onTap: _openThemeSheet,
                              ),
                              SettingsTile(
                                icon: Icons.language_rounded,
                                title: l.settingsLanguage,
                                subtitle: _languageLabel(settings),
                                showDivider: true,
                                showChevron: true,
                                onTap: user != null
                                    ? () => _openLanguageSheet(user)
                                    : null,
                              ),
                              SettingsTile(
                                icon: Icons.attach_money_rounded,
                                title: l.settingsCurrency,
                                subtitle: _currencyLabel(settings),
                                showDivider: true,
                                showChevron: true,
                                onTap: user != null
                                    ? () => _openCurrencySheet(user)
                                    : null,
                              ),
                              SettingsToggleTile(
                                icon: Icons.notifications_outlined,
                                title: l.settingsNotifications,
                                subtitle: l.settingsNotificationsSubtitle,
                                value: settings?.pushNotification ?? false,
                                onChanged: user != null
                                    ? (val) => _toggleNotifications(user, val)
                                    : null,
                              ),
                            ],
                          ),

                          // ── DATA ──────────────────────────────────────
                          SettingsSectionHeader(title: l.settingsData),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.download,
                                title: l.settingsExportData,
                                subtitle: l.settingsExportDataSubtitle,
                                showDivider: true,
                                showChevron: true,
                                isPremiumFeature: true,
                                isLocked: cubit.hasPremium,
                                onTap: user != null
                                    ? () => _openExportData()
                                    : null,
                              ),
                              SettingsTile(
                                icon: Icons.people,
                                title: l.settingsSharedAccount,
                                subtitle: l.settingsSharedAccountSubtitle,
                                showChevron: true,
                                onTap: () {},
                              ),
                            ],
                          ),

                          // ── HELP ──────────────────────────────────────
                          SettingsSectionHeader(title: l.settingsHelp),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.mail_outline_rounded,
                                title: l.settingsSupport,
                                subtitle: l.settingsSupportSubtitle,
                                showDivider: true,
                                showChevron: true,
                                onTap: () {},
                              ),
                              SettingsTile(
                                icon: Icons.menu_book_rounded,
                                title: l.settingsDocs,
                                subtitle: l.settingsDocsSubtitle,
                                showDivider: true,
                                showChevron: true,
                                onTap: () {},
                              ),
                              SettingsTile(
                                icon: Icons.lightbulb_outline_rounded,
                                title: l.settingsSuggest,
                                subtitle: l.settingsSuggestSubtitle,
                                showChevron: true,
                                onTap: () {},
                              ),
                            ],
                          ),

                          // ── ABOUT ─────────────────────────────────────
                          SettingsSectionHeader(title: l.settingsAbout),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.info_outline_rounded,
                                title: l.settingsVersion,
                                subtitle: _version,
                                showDivider: true,
                              ),
                              SettingsTile(
                                icon: Icons.map_outlined,
                                title: l.settingsSetupGuide,
                                subtitle: l.settingsSetupGuideSubtitle,
                                showDivider: true,
                                showChevron: true,
                                onTap: () => _resetOnboarding(context),
                              ),
                              SettingsTile(
                                icon: Icons.delete_outline_rounded,
                                title: l.settingsDeleteAccount,
                                subtitle: l.settingsDeleteAccountSubtitle,
                                iconColor: Theme.of(context).colorScheme.error,
                                showChevron: true,
                                onTap: user != null
                                    ? () => _openDeleteAccount(user)
                                    : null,
                              ),
                            ],
                          ),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

// ── Reusable grouped container ────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(children: children),
    );
  }
}
