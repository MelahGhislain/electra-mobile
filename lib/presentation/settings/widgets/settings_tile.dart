import 'package:electra/common/widgets/buttons/animated_icon_button.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final bool showDivider;
  final bool showChevron;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.showDivider = false,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
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
                    Icons.chevron_right,
                    size: 26,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: onTap ?? () {},
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
