import 'package:electra/core/network/api_client.dart';
import 'package:electra/data/models/subscription/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<SubscriptionModel> getSubscription();
  Future<SubscriptionModel> verifyPurchase({
    required String provider,
    required String providerId,
    required String productId,
  });
  Future<SubscriptionModel> restorePurchases();
  Future<SubscriptionModel> cancelSubscription();
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final ApiClient apiClient;
  const SubscriptionRemoteDataSourceImpl(this.apiClient);

  @override
  Future<SubscriptionModel> getSubscription() async {
    final response = await apiClient.get('/subscriptions/me');
    final body = response.data as Map<String, dynamic>;
    return SubscriptionModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<SubscriptionModel> verifyPurchase({
    required String provider,
    required String providerId,
    required String productId,
  }) async {
    final response = await apiClient.post(
      '/subscriptions/verify',
      data: {
        'provider': provider,
        'providerId': providerId,
        'productId': productId,
      },
    );
    final body = response.data as Map<String, dynamic>;
    return SubscriptionModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<SubscriptionModel> restorePurchases() async {
    // Restore hits the same verify endpoint — the backend deduplicates
    // by providerId so re-sending an existing token is idempotent.
    final response = await apiClient.post('/subscriptions/restore');
    final body = response.data as Map<String, dynamic>;
    return SubscriptionModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<SubscriptionModel> cancelSubscription() async {
    final response = await apiClient.delete('/subscriptions/cancel');
    final body = response.data as Map<String, dynamic>;
    return SubscriptionModel.fromJson(body['data'] as Map<String, dynamic>);
  }
}
