import 'package:electra/core/utils/storage/app_storage_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SharedPreferences _prefs;

  static const _setupSkippedKey = AppStorageKeys.setupSkippedKey;

  HomeCubit(this._prefs) : super(const HomeInitial());

  void load(String userId) {
    final skipped = _prefs.getBool(_userKey(userId)) ?? false;
    emit(HomeLoaded(setupSkipped: skipped));
  }

  Future<void> skipSetup(String userId) async {
    await _prefs.setBool(_userKey(userId), true);
    emit(const HomeLoaded(setupSkipped: true));
  }

  String _userKey(String userId) => '${_setupSkippedKey}_$userId';
}
