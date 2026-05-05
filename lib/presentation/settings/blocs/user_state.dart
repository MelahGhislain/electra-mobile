// import 'package:electra/domain/entities/user/user.dart';
// import 'package:equatable/equatable.dart';

// abstract class UserState extends Equatable {
//   const UserState();
//   @override
//   List<Object?> get props => [];
// }

// class UserInitial extends UserState {
//   const UserInitial();
// }

// class UserLoading extends UserState {
//   const UserLoading();
// }

// /// Emitted during a save/update so the UI can show a non-blocking indicator
// /// while keeping the current user data rendered.
// class UserSaving extends UserState {
//   final User user;
//   const UserSaving(this.user);

//   @override
//   List<Object?> get props => [user];
// }

// class UserLoaded extends UserState {
//   final User user;
//   const UserLoaded(this.user);

//   @override
//   List<Object?> get props => [user];
// }

// class UserFailure extends UserState {
//   final String message;
//   const UserFailure(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class UserUpdated extends UserState {
//   final User user;
//   const UserUpdated(this.user);

//   @override
//   List<Object?> get props => [user];
// }

// class UserDeleted extends UserState {
//   const UserDeleted();
// }

// class UserSettingUpdated extends UserState {
//   const UserSettingUpdated();
// }

import 'package:electra/domain/entities/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

/// Emitted during a save/update so the UI can show a non-blocking indicator
/// while keeping the current user data rendered.
class UserSaving extends UserState {
  final User user;
  const UserSaving(this.user);

  @override
  List<Object?> get props => [user];
}

class UserLoaded extends UserState {
  final User user;
  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserFailure extends UserState {
  final String message;

  /// The last known user — retained so the UI never resets on error.
  /// Null only when failure occurs before any user was ever loaded
  /// (e.g. initial load failure).
  final User? user;

  const UserFailure(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}

class UserUpdated extends UserState {
  final User user;
  const UserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserDeleted extends UserState {
  const UserDeleted();
}

class UserSettingUpdated extends UserState {
  const UserSettingUpdated();
}
