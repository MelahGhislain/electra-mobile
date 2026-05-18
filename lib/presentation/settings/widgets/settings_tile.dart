import 'package:electra/common/widgets/buttons/animated_icon_button.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final bool showDivider;
  final bool showChevron;
  final bool isPremiumFeature;
  final bool isLocked;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.showDivider = false,
    this.showChevron = false,
    this.isPremiumFeature = false,
    this.isLocked = false,
    this.onTap,
  });

  // True when the feature is premium and the user doesn't have access
  bool get _isLocked => isPremiumFeature && !isLocked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: _isLocked
              ? () {
                  context.pushNamed(RouteNames.subscription);
                }
              : onTap, // disable tap when locked
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: Icon(
            icon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
            size: 26,
          ),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: showChevron
              ? AnimatedIconButton(
                  icon: Icon(
                    _isLocked ? Icons.lock_outline : Icons.chevron_right,
                    size: 26,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: _isLocked
                      ? () {
                          context.pushNamed(RouteNames.subscription);
                        }
                      : onTap ?? () {}, // Explicitly return void
                )
              : null,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 22, // Starts from after the icon
            endIndent: 22,
          ),
      ],
    );
  }
}
