import 'package:electra/common/widgets/buttons/animated_icon_button.dart';
import 'package:electra/core/assets/app_images.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final VoidCallback? onEditPressed;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : const AssetImage(AppImages.defaultAvatar),
            backgroundColor: Theme.of(context).colorScheme.onSurface,
          ),

          const SizedBox(width: 16),

          // Name & Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // 👈 important
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: AppFontSize.lg,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // 👈 prevents overflow
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: AppFontSize.sm),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          AnimatedIconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
            onTap: onEditPressed ?? () {},
          ),
        ],
      ),
    );
  }
}
