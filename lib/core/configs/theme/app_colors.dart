import 'package:flutter/material.dart';

class AppColors {
  // Primary theme color (the one you specifically love)
  static const Color primary = Color(0xFF22C55E); // Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF16A34A);

  // Secondary colors
  static const Color secondary = Color(0xFF6B7280);
  static const Color secondaryDark = Color(0xFF4B5563);

  // Neutral colors extracted from screenshots (used for fine-tuning if needed)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1F1F1F);
  static const Color lightBackground =  Color.fromARGB(255, 241, 244, 239); // Color(0xFFF8F9FA) ;
  static const Color lightSurface = Color(0xFFFFFFFF);

  // Text colors (consistent with screenshots)
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color lightText = Color(0xFF1F1F1F);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Divider / subtle lines
  static const Color dividerDark = Color(0xFF2A2A2A); // dark mode
  static const Color dividerLight = Color(0xFFE0E0E0);
}
