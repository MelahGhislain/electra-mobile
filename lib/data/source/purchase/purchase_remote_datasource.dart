import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/purchase/purchase_model.dart';

abstract class PurchaseRemoteDataSource {
  Future<List<PurchaseModel>> getPurchases();
  Future<PurchaseModel> getPurchaseById(String id);
}

class PurchaseRemoteDataSourceImpl implements PurchaseRemoteDataSource {
  final ApiClient apiClient;
  const PurchaseRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<PurchaseModel>> getPurchases() async {
    final response = await apiClient.get(ApiEndpoints.getAllPurchases);
    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>? ?? [];
    final purchases = data
        .map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return purchases;
  }

  @override
  Future<PurchaseModel> getPurchaseById(String id) async {
    final endpoint = ApiEndpoints.getPurchase.replaceAll('{id}', id);
    final response = await apiClient.get(endpoint);
    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    return PurchaseModel.fromJson(data);
  }
}
