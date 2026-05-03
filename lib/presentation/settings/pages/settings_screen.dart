import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/common/blocs/theme_cubit.dart';
import 'package:electra/common/widgets/buttons/main_icon_button.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/core/services/app_info_service.dart';
import 'package:electra/core/utils/storage/onboarding_storage.dart';
import 'package:electra/domain/entities/user/user.dart';
import 'package:electra/domain/entities/user/user_settings.dart';
import 'package:electra/presentation/auth/bloc/auth_cubit.dart';
import 'package:electra/presentation/auth/bloc/auth_state.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/budget_bottom_sheet.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/currency_bottom_sheet.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/delete_account_dialog.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/edit_profile_bottom_sheet.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/language_bottom_sheet.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/theme_bottom_sheet.dart';
import 'package:electra/presentation/settings/widgets/logout_confirmation_dialog.dart';
import 'package:electra/presentation/settings/widgets/profile_header_card.dart';
import 'package:electra/presentation/settings/widgets/settings_section_header.dart';
import 'package:electra/presentation/settings/widgets/settings_tile.dart';
import 'package:electra/presentation/settings/widgets/settings_toggle_tile.dart';
import 'package:electra/presentation/user/bloc/user_cubit.dart';
import 'package:electra/presentation/user/bloc/user_state.dart';
import 'package:electra/service_locator.dart';
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Extracts the live User from whichever state is current.
  /// Includes UserFailure so the screen NEVER wipes on error.
  User? _user(UserState state) {
    if (state is UserLoaded) return state.user;
    if (state is UserSaving) return state.user;
    if (state is UserUpdated) return state.user;
    if (state is UserFailure) return state.user; // ← key fix
    return null;
  }

  UserSettings? _settings(UserState state) => _user(state)?.settings;

  String _themeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  String _currencyLabel(UserSettings? settings) {
    if (settings == null) return 'USD';
    try {
      final match = AppCurrency.values.firstWhere(
        (c) => c.code.toLowerCase() == settings.currency.toLowerCase(),
        orElse: () => AppCurrency.usd,
      );
      return match.code;
    } catch (_) {
      return settings.currency.toUpperCase();
    }
  }

  String _languageLabel(UserSettings? settings) {
    if (settings == null) return 'System Default';
    try {
      final match = AppLanguage.values.firstWhere(
        (l) => l.name.toLowerCase() == settings.locale.toLowerCase(),
        orElse: () => AppLanguage.systemDefault,
      );
      return match.label;
    } catch (_) {
      return settings.locale;
    }
  }

  String _budgetLabel(UserSettings? settings) {
    if (settings?.monthlyBudget == null || settings!.monthlyBudget! <= 0) {
      return 'Not set';
    }
    return '\$${settings.monthlyBudget!.toStringAsFixed(0)} / month';
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
    AppLanguage current = AppLanguage.systemDefault;
    try {
      current = AppLanguage.values.firstWhere(
        (l) =>
            l.name.toLowerCase() == (user.settings?.locale ?? '').toLowerCase(),
        orElse: () => AppLanguage.systemDefault,
      );
    } catch (_) {}
    final result = await LanguageBottomSheet.show(context, current);
    if (result != null && mounted) {
      await context.read<UserCubit>().updateUserSetting(user.id, {
        'locale': result.name,
      });
    }
  }

  Future<void> _openCurrencySheet(User user) async {
    AppCurrency current = AppCurrency.usd;
    try {
      current = AppCurrency.values.firstWhere(
        (c) =>
            c.code.toLowerCase() ==
            (user.settings?.currency ?? '').toLowerCase(),
        orElse: () => AppCurrency.usd,
      );
    } catch (_) {}
    final result = await CurrencyBottomSheet.show(context, current);
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
          final user = _user(userState);
          final settings = _settings(userState);
          final isSaving = userState is UserSaving;
          final isLoading =
              userState is UserLoading || userState is UserInitial;

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
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
                    final isAuthLoading = authState is AuthLoading;
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
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkBackground,
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
                              onEditPressed: user != null
                                  ? () => _openEditProfile(user)
                                  : null,
                            ),
                          ),

                          // ── ACCOUNT ───────────────────────────────────
                          const SettingsSectionHeader(title: 'Account'),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.wallet_rounded,
                                title: 'Budget & Income',
                                subtitle: _budgetLabel(settings),
                                showChevron: true,
                                onTap: user != null
                                    ? () => _openBudgetSheet(user)
                                    : null,
                              ),
                            ],
                          ),

                          // ── GENERAL ───────────────────────────────────
                          const SettingsSectionHeader(title: 'General'),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.palette_outlined,
                                title: 'Theme',
                                subtitle: _themeLabel(_themeMode),
                                showDivider: true,
                                showChevron: true,
                                onTap: _openThemeSheet,
                              ),
                              SettingsTile(
                                icon: Icons.language_rounded,
                                title: 'Language',
                                subtitle: _languageLabel(settings),
                                showDivider: true,
                                showChevron: true,
                                onTap: user != null
                                    ? () => _openLanguageSheet(user)
                                    : null,
                              ),
                              SettingsTile(
                                icon: Icons.attach_money_rounded,
                                title: 'Currency',
                                subtitle: _currencyLabel(settings),
                                showDivider: true,
                                showChevron: true,
                                onTap: user != null
                                    ? () => _openCurrencySheet(user)
                                    : null,
                              ),
                              SettingsToggleTile(
                                icon: Icons.notifications_outlined,
                                title: 'Push Notifications',
                                subtitle: 'Get reminders and spending alerts',
                                value: settings?.pushNotification ?? false,
                                onChanged: user != null
                                    ? (val) => _toggleNotifications(user, val)
                                    : null,
                              ),
                            ],
                          ),

                          // ── HELP ──────────────────────────────────────
                          const SettingsSectionHeader(title: 'Help'),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.mail_outline_rounded,
                                title: 'Support',
                                subtitle: 'Contact our support team',
                                showDivider: true,
                                showChevron: true,
                                onTap: () {},
                              ),
                              SettingsTile(
                                icon: Icons.menu_book_rounded,
                                title: 'Documentation',
                                subtitle: 'Learn how to use the app',
                                showDivider: true,
                                showChevron: true,
                                onTap: () {},
                              ),
                              SettingsTile(
                                icon: Icons.lightbulb_outline_rounded,
                                title: 'Suggest an Improvement',
                                subtitle: 'Share your feedback to help us',
                                showChevron: true,
                                onTap: () {},
                              ),
                            ],
                          ),

                          // ── ABOUT ─────────────────────────────────────
                          const SettingsSectionHeader(title: 'About'),
                          _SettingsGroup(
                            children: [
                              SettingsTile(
                                icon: Icons.info_outline_rounded,
                                title: 'Version',
                                subtitle: _version,
                                showDivider: true,
                              ),
                              SettingsTile(
                                icon: Icons.map_outlined,
                                title: 'Setup Guide',
                                subtitle: 'New here? Start with this',
                                showDivider: true,
                                showChevron: true,
                                onTap: () => _resetOnboarding(context),
                              ),
                              SettingsTile(
                                icon: Icons.delete_outline_rounded,
                                title: 'Delete Account',
                                subtitle: 'Permanently remove your account',
                                iconColor: Theme.of(context).colorScheme.error,
                                showChevron: true,
                                onTap: user != null
                                    ? () => _openDeleteAccount(user)
                                    : null,
                              ),
                            ],
                          ),

                          const SizedBox(height: 100),
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
