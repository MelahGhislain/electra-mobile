

import 'package:electra/core/utils/constants/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {

  ThemeCubit() : super(ThemeMode.dark);

  void updateTheme(ThemeMode themeMode) => emit(themeMode);


  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json[StorageKeys.theme] as int];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
   return {StorageKeys.theme: state.index};
  }
}
