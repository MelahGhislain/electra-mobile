import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the active [Locale]. null = follow the device locale.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null);

  /// Called on app start from the stored locale code (UserSettings.locale).
  void applyStoredLocale(String? localeCode) {
    if (localeCode == null || localeCode.isEmpty) {
      emit(null); // system default
    } else {
      emit(Locale(localeCode));
    }
  }

  /// Called after the user picks a language and it's saved to the backend.
  void setLocale(String? localeCode) {
    if (localeCode == null || localeCode.isEmpty) {
      emit(null);
    } else {
      emit(Locale(localeCode));
    }
  }

  void resetToSystem() => emit(null);
}
