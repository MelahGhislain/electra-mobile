import 'package:qleo/core/assets/app_images.dart';
import 'package:qleo/domain/entities/user/user.dart';
import 'package:qleo/domain/entities/user/user_settings.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:qleo/presentation/home/bloc/home_cubit.dart';
import 'package:qleo/presentation/home/bloc/home_state.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/budget_bottom_sheet.dart';
import 'package:qleo/presentation/settings/blocs/user_cubit.dart';
import 'package:qleo/presentation/settings/blocs/user_state.dart';
import 'package:flutter/material.dart';
import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/core/configs/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qleo/presentation/settings/widgets/bottom_sheets/currency_bottom_sheet.dart';

class HomeSetupCard extends StatefulWidget {
  const HomeSetupCard({super.key});

  @override
  State<HomeSetupCard> createState() => _HomeSetupCardState();
}

class _HomeSetupCardState extends State<HomeSetupCard> {
  Future<void> _openBudgetSheet(User user) async {
    await BudgetBottomSheet.show(
      context,
      userId: user.id,
      currentBudget: user.settings?.monthlyBudget,
    );
  }

  Future<void> _toggleNotifications(User user, bool value) async {
    await context.read<UserCubit>().updateUserSetting(user.id, {
      'pushNotification': value,
    });
  }

  /// Setup is complete when BOTH budget and notifications are configured.
  bool _isSetupComplete(UserSettings? settings) {
    final hasBudget = (settings?.monthlyBudget ?? 0) > 0;
    final hasCurrency = settings?.currency != null;
    final hasNotifications = settings?.pushNotification == true;
    return hasBudget && hasCurrency && hasNotifications;
  }

  //   String _currencyLabel(UserSettings? settings) {
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
    if (result != null && mounted) {
      await context.read<UserCubit>().updateUserSetting(user.id, {
        'currency': result.code,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final cubit = context.read<UserCubit>();
            final user = cubit.currentUser;
            final settings = cubit.currentUserSettings;
            final isUserLoading =
                userState is UserLoading || userState is UserInitial;
            final setupComplete = _isSetupComplete(settings);

            // Determine visibility from HomeCubit
            final shouldShow = homeState is HomeLoaded
                ? homeState.showSetupCard(setupComplete)
                : false;

            // Hide entirely if not needed
            if (!shouldShow) return const SizedBox.shrink();

            // Show loader only on first user load
            if (isUserLoading) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(AppImages.bell, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.letsSetThingsUp,
                                style: TextStyle(
                                  fontSize: AppFontSize.xxl,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l.getTheMostOutOfTheAppBySetting,
                                style: TextStyle(fontSize: AppFontSize.sm),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ── Options ─────────────────────────────────────
                    _SetupItem(
                      icon: Icons.track_changes_rounded,
                      color: (settings?.monthlyBudget ?? 0) > 0
                          ? AppColors.primary
                          : theme.iconTheme.color!,
                      title: l.setMonthlyBudgetTitle,
                      subtitle: l.helpUsPersonalizeYourSpending,
                      onTap: user != null ? () => _openBudgetSheet(user) : null,
                    ),

                    const SizedBox(height: 12),

                    _SetupItem(
                      icon: Icons.attach_money_rounded,
                      color: (settings?.currency != null)
                          ? AppColors.primary
                          : theme.iconTheme.color!,
                      title: l.settingsCurrency,
                      subtitle: _currencyLabel(settings),
                      onTap: user != null
                          ? () => _openCurrencySheet(user)
                          : null,
                    ),

                    const SizedBox(height: 12),

                    _SetupItem(
                      icon: Icons.notifications_none_outlined,
                      color: (settings?.pushNotification == true)
                          ? AppColors.accent
                          : theme.iconTheme.color!,
                      title: l.enablePushNotifications,
                      subtitle: l.stayUpdatedOnSpending,
                      value: settings?.pushNotification ?? false,
                      onChanged: user != null
                          ? (val) => _toggleNotifications(user, val)
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // ── Skip ────────────────────────────────────────
                    // Center(
                    //   child: InkWell(
                    //     borderRadius: BorderRadius.circular(8),
                    //     onTap: () =>
                    //         context.read<HomeCubit>().skipSetup(user!.id),
                    //     child: Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: 8,
                    //         vertical: 4,
                    //       ),
                    //       child: Text(
                    //         l.skipForNow,
                    //         style: TextStyle(
                    //           fontSize: AppFontSize.md,
                    //           color: AppColors.primary,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 4),

                    // ── Footer note ─────────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: theme.iconTheme.color,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l.youCanChangeTheseLater,
                            style: TextStyle(fontSize: AppFontSize.xs),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SetupItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onChanged;

  const _SetupItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.value = false,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: onChanged != null
                  ? Switch(value: value, onChanged: onChanged)
                  : Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: theme.iconTheme.color,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
