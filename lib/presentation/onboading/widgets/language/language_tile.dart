import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/user/language.dart';
import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBackground : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(language.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                language.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check, color: AppColors.darkText),
          ],
        ),
      ),
    );
  }
}
