import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Email / password form is submitting
class AuthEmailLoading extends AuthState {
  const AuthEmailLoading();
}

/// OAuth (Google / Apple) is in progress
class AuthGoogleLoading extends AuthState {
  const AuthGoogleLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

class AuthCancelled extends AuthState {
  const AuthCancelled();
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}
