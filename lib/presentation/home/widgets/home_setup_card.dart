import 'package:electra/core/assets/app_images.dart';
import 'package:electra/domain/entities/user/user.dart';
import 'package:electra/domain/entities/user/user_settings.dart';
import 'package:electra/presentation/home/bloc/home_cubit.dart';
import 'package:electra/presentation/home/bloc/home_state.dart';
import 'package:electra/presentation/settings/widgets/bottom_sheets/budget_bottom_sheet.dart';
import 'package:electra/presentation/settings/blocs/user_cubit.dart';
import 'package:electra/presentation/settings/blocs/user_state.dart';
import 'package:flutter/material.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final hasNotifications = settings?.pushNotification == true;
    return hasBudget && hasNotifications;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                                "Let's set things up",
                                style: TextStyle(
                                  fontSize: AppFontSize.xxl,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Get the most out of the app by setting up a few things.",
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
                      title: "Set your monthly budget",
                      subtitle: "Help us personalize your spending plan",
                      onTap: user != null ? () => _openBudgetSheet(user) : null,
                    ),

                    const SizedBox(height: 12),

                    _SetupItem(
                      icon: Icons.notifications_none_outlined,
                      color: (settings?.pushNotification == true)
                          ? AppColors.accent
                          : theme.iconTheme.color!,
                      title: "Enable push notifications",
                      subtitle: "Stay updated on spending & reminders",
                      value: settings?.pushNotification ?? false,
                      onChanged: user != null
                          ? (val) => _toggleNotifications(user, val)
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // ── Skip ────────────────────────────────────────
                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () =>
                            context.read<HomeCubit>().skipSetup(user!.id),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            "Skip for now",
                            style: TextStyle(
                              fontSize: AppFontSize.md,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

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
                            "You can always change these later in Settings.",
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
    );
  }
}
