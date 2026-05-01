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

  Future<void> loadUser() async {
    emit(const UserLoading());

    final result = await _getUser();
    result.fold(
      (failure) => emit(UserFailure(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> updateUser(String id, Map<String, dynamic> body) async {
    emit(const UserLoading());

    final result = await _updateUser(id, body);
    result.fold((failure) => emit(UserFailure(failure.message)), (user) {
      emit(UserUpdated(user));
      loadUser();
    });
  }

  Future<void> deleteUser(String id) async {
    emit(const UserLoading());

    final result = await _deleteUser(id);
    result.fold((failure) => emit(UserFailure(failure.message)), (_) {
      emit(const UserDeleted());
    });
  }

  Future<void> updateUserSetting(String id, Map<String, dynamic> body) async {
    emit(const UserLoading());

    final result = await _updateUserSetting(id, body);
    result.fold((failure) => emit(UserFailure(failure.message)), (_) {
      emit(const UserSettingUpdated());
      loadUser();
    });
  }
}
