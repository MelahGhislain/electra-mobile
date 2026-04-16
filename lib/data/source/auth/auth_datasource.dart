import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/auth/auth_tokens_model.dart';
import 'package:electra/data/models/auth/signup_user_dto.dart';
import 'package:electra/data/models/auth/signin_user_dto.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<AuthTokensModel> login(SigninUserDto signinUserReq) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: {"email": signinUserReq.email, "password": signinUserReq.password},
    );

    return AuthTokensModel.fromJson(response.data);
  }

  Future<AuthTokensModel> register(SignupUserDto signupUser) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      data: {
        "name": signupUser.name,
        "email": signupUser.email,
        "password": signupUser.password,
      },
    );

    return AuthTokensModel.fromJson(response.data);
  }

  Future<AuthTokensModel> refresh({required String refreshToken}) async {
    final response = await apiClient.post(
      ApiEndpoints.refresh,
      data: {"refreshToken": refreshToken},
    );

    return AuthTokensModel.fromJson(response.data);
  }

  Future<void> logout() async {
    await apiClient.post(ApiEndpoints.logout);
  }
}
