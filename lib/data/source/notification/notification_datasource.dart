import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/notification/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<void> registerPushToken(String token, String platform);
  Future<void> removePushToken(String token);
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAllRead();
  Future<int> getUnreadCount();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<void> registerPushToken(String token, String platform) async {
    await apiClient.post(
      ApiEndpoints.registerPushToken,
      data: {'token': token, 'platform': platform},
    );
  }

  @override
  Future<void> removePushToken(String token) async {
    await apiClient.delete(
      ApiEndpoints.removePushToken,
      data: {'token': token},
    );
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiClient.get(ApiEndpoints.getNotifications);
    final list = _unwrapList(response.data);
    return list.map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<void> markAllRead() async {
    await apiClient.patch(ApiEndpoints.markAllRead);
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await apiClient.get(ApiEndpoints.getUnreadCount);
    final data = _unwrap(response.data);
    return data['count'] as int? ?? 0;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Map<String, dynamic> _unwrap(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data') &&
          responseData['data'] is Map<String, dynamic>) {
        return responseData['data'] as Map<String, dynamic>;
      }
      return responseData;
    }
    throw Exception('Unexpected response format: $responseData');
  }

  List<Map<String, dynamic>> _unwrapList(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final inner = responseData.containsKey('data')
          ? responseData['data']
          : responseData;
      if (inner is List) {
        return inner.cast<Map<String, dynamic>>();
      }
    }
    if (responseData is List) {
      return responseData.cast<Map<String, dynamic>>();
    }
    throw Exception('Unexpected list response format: $responseData');
  }
}
