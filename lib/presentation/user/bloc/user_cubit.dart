import 'package:electra/data/models/user/user_settings_model.dart';
import 'package:electra/domain/entities/user/user.dart';
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

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<void> loadUser() async {
    emit(const UserLoading());
    final result = await _getUser();
    result.fold(
      // No previous user available on initial load failure
      (failure) => emit(UserFailure(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  // ── Update profile (name / avatar) ────────────────────────────────────────

  Future<void> updateUser(String id, Map<String, dynamic> body) async {
    final previous = _currentUser();
    if (previous == null) return;

    emit(UserSaving(previous));

    final result = await _updateUser(id, body);
    result.fold(
      (failure) {
        // Restore previous data AND surface the error in one state.
        // UserFailure now carries the user so the UI never wipes.
        emit(UserFailure(failure.message, user: previous));
        // Settle back to loaded so subsequent rebuilds show the data.
        emit(UserLoaded(previous));
      },
      (updated) {
        emit(UserUpdated(updated));
        emit(UserLoaded(updated));
      },
    );
  }

  // ── Update settings ───────────────────────────────────────────────────────

  Future<void> updateUserSetting(String id, Map<String, dynamic> body) async {
    final previous = _currentUser();
    if (previous == null) return;

    emit(UserSaving(previous));

// Merge existing settings with the new fields so no data is lost
  final existingSettings = previous.settings != null
      ? (previous.settings as UserSettingsModel).toJson()
      : <String, dynamic>{};

  final merged = {...existingSettings, ...body};

    final result = await _updateUserSetting(id, merged);
    result.fold(
      (failure) {
        emit(UserFailure(failure.message, user: previous));
        emit(UserLoaded(previous)); // rollback — UI keeps previous data
      },
      (_) {
        emit(const UserSettingUpdated());
        loadUser(); // re-fetch to stay in sync with server
      },
    );
  }

  // ── Delete account ────────────────────────────────────────────────────────

  Future<void> deleteAccount(String id) async {
    final previous = _currentUser();
    emit(UserLoading());

    final result = await _deleteUser(id);
    result.fold(
      (failure) {
        // Restore previous state so the screen doesn't go blank
        if (previous != null) {
          emit(UserFailure(failure.message, user: previous));
          emit(UserLoaded(previous));
        } else {
          emit(UserFailure(failure.message));
        }
      },
      (_) => emit(const UserDeleted()),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Extracts the current User from whatever state we are in,
  /// including UserFailure so rollback always has data to restore.
  User? _currentUser() {
    final s = state;
    if (s is UserLoaded) return s.user;
    if (s is UserSaving) return s.user;
    if (s is UserUpdated) return s.user;
    if (s is UserFailure) return s.user;
    return null;
  }

  bool get isSaving => state is UserSaving;
}
