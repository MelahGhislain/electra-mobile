import 'package:electra/domain/entities/user/user.dart';
import 'package:electra/domain/entities/user/user_settings.dart';
import 'package:electra/domain/usecases/user/setting_usecase.dart';
import 'package:electra/domain/usecases/user/user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUserUsecase _getUser;
  final UpdateUserUsecase _updateUser;
  final DeleteUserUsecase _deleteUser;
  final UpdateUserSettingUsecase _updateUserSetting;

  UserCubit({
    required GetCurrentUserUsecase getUser,
    required UpdateUserUsecase updateUser,
    required DeleteUserUsecase deleteUser,
    required UpdateUserSettingUsecase updateUserSetting,
  }) : _getUser = getUser,
       _updateUser = updateUser,
       _deleteUser = deleteUser,
       _updateUserSetting = updateUserSetting,
       super(const UserInitial());

  // ── Read ───────────────────────────────────────────────────────────────────

  Future<void> loadUser() async {
    emit(const UserLoading());
    final result = await _getUser();
    result.fold(
      (failure) => emit(UserFailure(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  // ── Update profile ─────────────────────────────────────────────────────────

  Future<void> updateUser(String id, Map<String, dynamic> body) async {
    final previous = _currentUser();
    if (previous == null) return;

    emit(UserSaving(previous));

    final result = await _updateUser(id, body);
    result.fold(
      (failure) {
        emit(UserFailure(failure.message, user: previous));
        emit(UserLoaded(previous));
      },
      (updated) {
        emit(UserUpdated(updated));
        emit(UserLoaded(updated));
      },
    );
  }

  // ── Update settings ────────────────────────────────────────────────────────

  Future<void> updateUserSetting(String id, Map<String, dynamic> body) async {
    final previous = _currentUser();
    if (previous == null) return;

    emit(UserSaving(previous));

    // Build the base map from the entity fields directly — no model cast needed.
    final existingSettings = _settingsToMap(previous.settings);
    final merged = {...existingSettings, ...body};

    final result = await _updateUserSetting(id, merged);
    result.fold(
      (failure) {
        emit(UserFailure(failure.message, user: previous));
        emit(UserLoaded(previous));
      },
      (settings) {
        emit(const UserSettingUpdated());
        emit(UserLoaded(previous.copyWith(settings: settings)));
      },
    );
  }

  // ── Delete account ─────────────────────────────────────────────────────────

  Future<void> deleteAccount(String id) async {
    final previous = _currentUser();
    emit(UserLoading());

    final result = await _deleteUser(id);
    result.fold((failure) {
      if (previous != null) {
        emit(UserFailure(failure.message, user: previous));
        emit(UserLoaded(previous));
      } else {
        emit(UserFailure(failure.message));
      }
    }, (_) => emit(const UserDeleted()));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  User? _currentUser() {
    final s = state;
    if (s is UserLoaded) return s.user;
    if (s is UserSaving) return s.user;
    if (s is UserUpdated) return s.user;
    if (s is UserFailure) return s.user;
    return null;
  }

  User? get currentUser => _currentUser();
  UserSettings? get currentUserSettings => _currentUser()?.settings;
  bool get isLoading => state is UserLoading || state is UserInitial;
  bool get isLoaded => state is UserLoaded;

  /// Converts a UserSettings entity to a plain map without any model cast.
  Map<String, dynamic> _settingsToMap(UserSettings? settings) {
    if (settings == null) return {};
    return {
      'currency': settings.currency,
      'locale': settings.locale,
      'pushNotification': settings.pushNotification,
      'accountMode': settings.accountMode,
      if (settings.monthlyBudget != null)
        'monthlyBudget': settings.monthlyBudget,
    };
  }

  bool get isSaving => state is UserSaving;
}
