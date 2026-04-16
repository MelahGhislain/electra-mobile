import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/user/language.dart';
import 'package:flutter/material.dart';
import 'language_tile.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedCode;
  final Function(Language) onSelect;

  const LanguageSelector({
    super.key,
    required this.selectedCode,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          /// Drag handle (nice UX touch)
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              const Text(
                'Interface Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightText,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.lightText),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// List (scrollable)
          Expanded(
            child: ListView.separated(
              itemCount: languages.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected = lang.code == selectedCode;

                return LanguageTile(
                  language: lang,
                  isSelected: isSelected,
                  onTap: () {
                    onSelect(lang);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const List<Language> languages = [
  Language(code: 'en', name: 'English', flag: '🇺🇸', currency: 'USD'),
  Language(code: 'es', name: 'Español', flag: '🇪🇸', currency: 'USD'),
  Language(
    code: 'pt-br',
    name: 'Português (Brasil)',
    flag: '🇧🇷',
    currency: 'BRL',
  ),
  Language(code: 'pt', name: 'Português', flag: '🇵🇹', currency: 'EUR'),
  Language(code: 'fr', name: 'Français', flag: '🇫🇷', currency: 'EUR'),
  Language(code: 'de', name: 'Deutsch', flag: '🇩🇪', currency: 'EUR'),
  Language(code: 'ru', name: 'Русский', flag: '🇷🇺', currency: 'RUB'),
  Language(code: 'it', name: 'Italiano', flag: '🇮🇹', currency: 'EUR'),
  Language(code: 'nl', name: 'Nederlands', flag: '🇳🇱', currency: 'EUR'),
];
