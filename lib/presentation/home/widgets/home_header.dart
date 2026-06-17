import 'package:qleo/common/widgets/buttons/main_icon_button.dart';
import 'package:qleo/core/assets/app_images.dart';
import 'package:qleo/core/router/route_names.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:qleo/presentation/settings/blocs/user_cubit.dart';
import 'package:qleo/presentation/settings/blocs/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String date;
  final bool showInsightBanner;
  final String? insightBannerText;

  const HomeHeader({
    super.key,
    required this.name,
    required this.date,
    this.showInsightBanner = false,
    this.insightBannerText,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l.homeGreeting(name),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('👋', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Calendar + avatar
              Row(
                children: [
                  MainIconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    size: 40,
                    onTap: () {},
                  ),

                  const SizedBox(width: 10),
                  // Avatar
                  GestureDetector(
                    onTap: () {
                      context.goNamed(RouteNames.settings);
                    },
                    child: // Avatar
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        final cubit = context.read<UserCubit>();
                        final user = cubit.currentUser;
                        return CircleAvatar(
                          radius: 22,
                          backgroundImage:
                              user?.picture != null &&
                                  user?.picture?.isNotEmpty == true
                              ? NetworkImage(user!.picture!)
                              : const AssetImage(AppImages.defaultAvatar),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Insight banner
          if (showInsightBanner) ...[
            const SizedBox(height: 12),
            IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      insightBannerText ?? l.homeYoureSpendingLessThanUsual,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
