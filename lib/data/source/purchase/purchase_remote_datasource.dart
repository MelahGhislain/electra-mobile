import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/purchase/purchase_model.dart';
import 'package:flutter/widgets.dart';

abstract class PurchaseRemoteDataSource {
  Future<List<PurchaseModel>> getPurchases();
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
}
