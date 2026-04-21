import 'package:equatable/equatable.dart';

enum AppAuthStatus { unknown, authenticated, unauthenticated }

class AppAuthState extends Equatable {
  final AppAuthStatus status;
  final String? errorMessage;

  const AppAuthState._({required this.status, this.errorMessage});

  const AppAuthState.unknown() : this._(status: AppAuthStatus.unknown);

  const AppAuthState.authenticated()
    : this._(status: AppAuthStatus.authenticated);

  const AppAuthState.unauthenticated()
    : this._(status: AppAuthStatus.unauthenticated);

  const AppAuthState.unauthenticatedWithError(String message)
    : this._(status: AppAuthStatus.unauthenticated, errorMessage: message);

  bool get isAuthenticated => status == AppAuthStatus.authenticated;
  bool get isUnknown => status == AppAuthStatus.unknown;
  bool get isUnauthenticated => status == AppAuthStatus.unauthenticated;

  @override
  List<Object?> get props => [status, errorMessage];
}
