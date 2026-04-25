import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/common/blocs/language_cubit.dart';
import 'package:electra/common/blocs/theme_cubit.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/core/services/app_info_service.dart';
import 'package:electra/core/utils/storage/onboarding_storage.dart';
import 'package:electra/presentation/auth/bloc/auth_cubit.dart';
import 'package:electra/presentation/auth/bloc/auth_state.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/currency_bottom_sheet.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/language_bottom_sheet.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/theme_bottom_sheet.dart';
import 'package:electra/presentation/settings/widgets/logout_confirmation_dialog.dart';
import 'package:electra/presentation/settings/widgets/profile_header_card.dart';
import 'package:electra/presentation/settings/widgets/settings_section_header.dart';
import 'package:electra/presentation/settings/widgets/settings_tile.dart';
import 'package:electra/presentation/settings/widgets/settings_toggle_tile.dart';
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

  // Local state — will be replaced by cubit/API later
  ThemeMode _themeMode = ThemeMode.light;
  AppLanguage _language = AppLanguage.systemDefault;
  AppCurrency _currency = AppCurrency.usd;
  bool _pushNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await AppInfoService.getVersion();
    if (mounted) setState(() => _version = version);
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await LogoutConfirmationDialog.show(context);
    if (confirmed && context.mounted) {
      context.read<AuthCubit>().logout();
      context.read<AppAuthCubit>().onLogout();
    }
  }

  Future<void> _openThemeSheet() async {
    final result = await ThemeBottomSheet.show(context, _themeMode);
    if (result != null && mounted) {
      setState(() => _themeMode = result);
      context.read<ThemeCubit>().updateTheme(result);
    }
  }

  Future<void> _openLanguageSheet() async {
    final result = await LanguageBottomSheet.show(context, _language);
    if (result != null && mounted) {
      setState(() => _language = result);
      // context.read<LanguageCubit>().changeLanguage(result);
    }
  }

  Future<void> _openCurrencySheet() async {
    final result = await CurrencyBottomSheet.show(context, _currency);
    if (result != null && mounted) {
      setState(() => _currency = result);
      // Wire to SettingsCubit later
    }
  }

  Future<void> _resetOnboarding(BuildContext context) async {
    await sl<OnboardingStorage>().resetOnboarding();
    if (!context.mounted) return;
    context.goNamed(RouteNames.onboarding);
  }

  String get _themeLabel {
    return switch (_themeMode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          context.read<AppAuthCubit>().onLogout();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: AppColors.lightBackground,
          title: const Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.lightText,
            ),
          ),
          elevation: 0,
          leading: const BackButton(color: AppColors.lightText),
          actions: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.lightText,
                          ),
                        )
                      : const Icon(Icons.logout, color: AppColors.lightText),
                  onPressed: isLoading ? null : () => _showLogoutDialog(context),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeaderCard(
                name: "Ethan Cole",
                email: "ethancoleux@gmail.com",
                onEditPressed: () {
                  // Navigate to edit profile or show dialog
                },
              ),

              // ── GENERAL ────────────────────────────────────────────────
              const SettingsSectionHeader(title: 'General'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.dividerLight),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.palette_outlined,
                      title: 'Theme',
                      subtitle: _themeLabel,
                      showDivider: true,
                      showChevron: true,
                      onTap: _openThemeSheet,
                    ),
                    SettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: _language.label,
                      showDivider: true,
                      showChevron: true,
                      onTap: _openLanguageSheet,
                    ),
                    SettingsTile(
                      icon: Icons.folder_outlined,
                      title: 'Currency',
                      subtitle: _currency.code,
                      showChevron: true,
                      showDivider: true,
                      onTap: _openCurrencySheet,
                    ),
                    SettingsToggleTile(
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Get reminders and updates',
                      value: _pushNotifications,
                      showDivider: true,
                      onChanged: (val) =>
                          setState(() => _pushNotifications = val),
                    ),
                    SettingsTile(
                      icon: Icons.wallet,
                      title: 'Budget & Income',
                      subtitle: 'Manage your budget and income',
                      showChevron: true,
                      onTap: () {
                        // Navigate to budget screen later
                      },
                    ),
                  ],
                ),
              ),

              // ── HELP ───────────────────────────────────────────────────
              const SettingsSectionHeader(title: 'Help'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.dividerLight),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.mail_outline,
                      title: 'Support',
                      subtitle: 'Contact our support team',
                      showDivider: true,
                      showChevron: true,
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.language,
                      title: 'Documentation',
                      subtitle: 'Learn how to use the app',
                      showDivider: true,
                      showChevron: true,
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.wallet,
                      title: 'Suggest Product Improvement',
                      subtitle: 'Share your feedback to help us improve',
                      showChevron: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // ── ABOUT ──────────────────────────────────────────────────
              const SettingsSectionHeader(title: 'About'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.dividerLight),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.info_outline,
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
                      icon: Icons.delete,
                      title: 'Delete Account',
                      subtitle: 'Permanently remove your account',
                      iconColor: Colors.red,
                      showChevron: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
