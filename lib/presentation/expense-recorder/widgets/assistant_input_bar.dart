import 'package:electra/common/widgets/buttons/animated_icon_button.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AssistantInputBar extends StatelessWidget {
  const AssistantInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          // color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.dividerDark.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            const Expanded(
              child: Text(
                'Ask anything...',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            AnimatedIconButton(
              icon: const Icon(
                Icons.graphic_eq,
                color: AppColors.primary,
                size: 26,
              ),
              onTap: () {},
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
