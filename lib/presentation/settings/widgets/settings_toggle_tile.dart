// lib/presentation/settings/widgets/settings_toggle_tile.dart
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool showDivider;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
    this.showDivider = false,
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
          leading: Icon(icon, color: AppColors.primary, size: 26),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              color: AppColors.lightText,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14.5, color: Colors.grey[700]),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.lightSurface,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.dividerLight,
            
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            indent: 22,
            endIndent: 22,
            color: AppColors.dividerLight,
          ),
      ],
    );
  }
}
