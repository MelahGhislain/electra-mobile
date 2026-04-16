import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/user/user_model.dart';

class UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSource(this.apiClient);

  Future<UserModel> getUser() async {
    final response = await apiClient.get(ApiEndpoints.me);

    return UserModel.fromJson(response.data);
  }
}
