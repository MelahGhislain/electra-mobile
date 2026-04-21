import 'package:electra/core/utils/constants/storage_keys.dart';
import 'package:electra/core/utils/storage/secure_storage.dart';

class AuthStorage {
  final SecureStorage _storage;

  AuthStorage(this._storage);

  Future<String?> get accessToken => _storage.read(StorageKeys.accessToken);
  Future<String?> get refreshToken => _storage.read(StorageKeys.refreshToken);

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: access);
    await _storage.write(key: StorageKeys.refreshToken, value: refresh);
  }

  Future<void> clearTokens() async {
    await _storage.delete(StorageKeys.accessToken);
    await _storage.delete(StorageKeys.refreshToken);
  }

  Future<bool> get hasTokens async {
    final token = await accessToken;
    return token != null;
  }
}
