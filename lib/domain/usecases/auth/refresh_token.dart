import 'package:electra/domain/repository/auth/auth_repository.dart';

class RefreshToken {
  final AuthRepository repository;

  RefreshToken(this.repository);

  Future<void> call({required String refreshToken}) {
    return repository.refresh(refreshToken: refreshToken);
  }
}
