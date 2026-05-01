import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/user/user_model.dart';
import 'package:electra/data/models/user/user_settings_model.dart';

// static const updateUser = "/users/{id}";
// static const deleteUser = "/users/{id}";
// static const getSettings = "/users/{id}/settings";
// static const updateSettings = "/users/{id}/settings";

abstract class UserRemoteDataSource {
  // ── User ──────────────────────────────────────────────────────────────
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

  @override
  Future<UserModel> getUser() async {
    final response = await apiClient.get(ApiEndpoints.getMe);

    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> updateUser(String id, Map<String, dynamic> body) async {
    final endpoint = ApiEndpoints.updateUser.replaceAll('{id}', id);
    final response = await apiClient.patch(endpoint, data: body);

    return UserModel.fromJson(response.data);
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

    return UserSettingsModel.fromJson(response.data);
  }

  @override
  Future<UserSettingsModel> updateSettings(
    String id,
    Map<String, dynamic> body,
  ) async {
    final endpoint = ApiEndpoints.updateSettings.replaceAll('{id}', id);
    final response = await apiClient.patch(endpoint, data: body);

    return UserSettingsModel.fromJson(response.data);
  }
}
