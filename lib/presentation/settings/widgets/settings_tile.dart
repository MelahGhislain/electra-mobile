import 'package:electra/common/widgets/buttons/animated_icon_button.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final bool showDivider;
  final bool showChevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.showDivider = false,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 26),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              color: AppColors.lightText,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(fontSize: 14.5, color: Colors.grey[700]),
                )
              : null,
          trailing: showChevron
              ? AnimatedIconButton(
                  icon: Icon(Icons.chevron_right, size: 26),
                  onTap: () {},
                )
              : null,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 22, // Starts from after the icon
            endIndent: 22,
            color: AppColors.dividerLight,
          ),
      ],
    );
  }
}
