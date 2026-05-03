import 'package:flutter/material.dart';

class AppColors {
  // =========================
  // BRAND (Primary Identity)
  // =========================
  static const Color primary = Color(
    0xFF22C55E,
  ); // your green — keep for buttons/FAB
  static const Color primaryDark = Color(0xFF16A34A);
  static const Color primarySoft = Color(0xFF86EFAC);

  // The blue-purple accent visible on icons/toggles in the screenshots
  static const Color accent = Color(0xFF6B7FD4);
  static const Color accentSoft = Color(0xFFEEF0FB);

  // =========================
  // SEMANTIC COLORS
  // =========================
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF6B7FD4); // matches accent

  // =========================
  // LIGHT THEME SURFACES
  // =========================
  static const Color lightBackground = Color(
    0xFFF2F3F7,
  ); // warm grey, matches screenshot
  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color lightSurfaceAlt = Color(0xFF9C9C9E);

  static const Color lightBorder = Color(0xFFE2E4ED);

  // =========================
  // DARK THEME SURFACES
  // deep navy, matches screenshot exactly
  // =========================

  static const Color darkBackground = Color(
    0xFF141416,
  ); // softer base (less harsh)
  static const Color darkSurface = Color(
    0xFF24262A,
  ); // clearly above background
  static const Color darkSurfaceAlt = Color(0xFF2E3136); // strong elevation

  static const Color darkBorder = Color(0xFF3F434B); // visible but still soft

  // =========================
  // TEXT
  // =========================
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  static const Color darkText = Color(0xFFEEF0F6);
  static const Color darkTextSecondary = Color(0xFF8891A8);

  // =========================
  // DIVIDERS
  // =========================
  static const Color dividerLight = lightBorder;
  static const Color dividerDark = darkBorder;
}
