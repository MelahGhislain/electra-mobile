import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/auth/auth_tokens_model.dart';
import 'package:electra/domain/entities/auth/social_auth_credential.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  });
  Future<AuthTokensModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<AuthTokensModel> refresh({required String refreshToken});
  Future<void> logout();
  Future<AuthTokensModel> loginWithSocial(SocialAuthCredential credential);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  const AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return AuthTokensModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<AuthTokensModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'provider': 'email',
      },
    );
    return AuthTokensModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<AuthTokensModel> refresh({required String refreshToken}) async {
    final res = await apiClient.post(
      ApiEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );
    return AuthTokensModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() => apiClient.post(ApiEndpoints.logout, data: {});

  @override
  Future<AuthTokensModel> loginWithSocial(
    SocialAuthCredential credential,
  ) async {
    // POST /auth/oauth  →  { "provider": "google"|"apple", "token": "<idToken>" }
    final res = await apiClient.post(
      ApiEndpoints.oauth,
      data: {
        'provider': credential.provider.name, // 'google' | 'apple'
        'token': credential.providerId,       // idToken from Google / Apple
      },
    );
    return AuthTokensModel.fromJson(res.data as Map<String, dynamic>);
  }
}
