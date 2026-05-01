import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/user/user_model.dart';
import 'package:electra/data/models/user/user_settings_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser();
  Future<UserModel> updateUser(String id, Map<String, dynamic> body);
  Future<void> deleteUser(String id);
  Future<UserSettingsModel> getSettings(String id);
  Future<UserSettingsModel> updateSettings(
    String id,
    Map<String, dynamic> body,
  );
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl(this.apiClient);

  // ── User ──────────────────────────────────────────────────────────────────

  @override
  Future<UserModel> getUser() async {
    final response = await apiClient.get(ApiEndpoints.getMe);
    return UserModel.fromJson(_unwrap(response.data));
  }

  @override
  Future<UserModel> updateUser(String id, Map<String, dynamic> body) async {
    final endpoint = ApiEndpoints.updateUser.replaceAll('{id}', id);
    final response = await apiClient.patch(endpoint, data: body);
    return UserModel.fromJson(_unwrap(response.data));
  }

  @override
  Future<void> deleteUser(String id) async {
    final endpoint = ApiEndpoints.deleteUser.replaceAll('{id}', id);
    await apiClient.delete(endpoint);
  }

  @override
  Future<UserSettingsModel> getSettings(String id) async {
    final endpoint = ApiEndpoints.getSettings.replaceAll('{id}', id);
    final response = await apiClient.get(endpoint);
    return UserSettingsModel.fromJson(_unwrap(response.data));
  }

  @override
  Future<UserSettingsModel> updateSettings(
    String id,
    Map<String, dynamic> body,
  ) async {
    final endpoint = ApiEndpoints.updateSettings.replaceAll('{id}', id);
    final response = await apiClient.patch(endpoint, data: body);
    return UserSettingsModel.fromJson(_unwrap(response.data));
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  Map<String, dynamic> _unwrap(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Already the inner object (some endpoints return data directly)
      if (responseData.containsKey('data') &&
          responseData['data'] is Map<String, dynamic>) {
        return responseData['data'] as Map<String, dynamic>;
      }
      return responseData;
    }
    throw Exception('Unexpected response format: $responseData');
  }
}
