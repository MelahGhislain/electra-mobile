import 'dart:io';

import 'package:dio/dio.dart';
import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/data/models/purchase/purchase_item_model.dart';
import 'package:electra/data/models/purchase/purchase_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class PurchaseRemoteDataSource {
  // ── Purchase ──────────────────────────────────────────────────────────────
  Future<List<PurchaseModel>> getPurchases();
  Future<PurchaseModel> getPurchaseById(String id);
  Future<PurchaseModel> createPurchase(Map<String, dynamic> body);
  Future<PurchaseModel> updatePurchase(String id, Map<String, dynamic> body);
  Future<void> deletePurchase(String id);

  // ── Purchase Item ─────────────────────────────────────────────────────────
  Future<PurchaseItemModel> createPurchaseItem(
    String purchaseId,
    Map<String, dynamic> body,
  );
  Future<PurchaseItemModel> updatePurchaseItem(
    String purchaseId,
    String itemId,
    Map<String, dynamic> body,
  );
  Future<void> deletePurchaseItem(String purchaseId, String itemId);
  Future<String> exportData(
    Map<String, dynamic> body,
  ); // returns saved file path
}

class PurchaseRemoteDataSourceImpl implements PurchaseRemoteDataSource {
  final ApiClient apiClient;
  const PurchaseRemoteDataSourceImpl(this.apiClient);

  // ── Options that force Dio to always send a JSON content-type header,
  //    even when the body map happens to be small. Fastify rejects requests
  //    where content-type is application/json but the body is absent/empty.
  static final _jsonOptions = Options(
    contentType: 'application/json',
    headers: {'Accept': 'application/json'},
  );

  // ── Purchase ──────────────────────────────────────────────────────────────

  @override
  Future<List<PurchaseModel>> getPurchases() async {
    final response = await apiClient.get(ApiEndpoints.getAllPurchases);
    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PurchaseModel> getPurchaseById(String id) async {
    final endpoint = ApiEndpoints.getPurchase.replaceAll('{id}', id);
    final response = await apiClient.get(endpoint);
    final body = response.data as Map<String, dynamic>;
    return PurchaseModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<PurchaseModel> createPurchase(Map<String, dynamic> body) async {
    final response = await apiClient.post(
      ApiEndpoints.createPurchase,
      data: body,
    );
    final resBody = response.data as Map<String, dynamic>;
    return PurchaseModel.fromJson(resBody['data'] as Map<String, dynamic>);
  }

  @override
  Future<PurchaseModel> updatePurchase(
    String id,
    Map<String, dynamic> body,
  ) async {
    final endpoint = ApiEndpoints.updatePurchase.replaceAll('{id}', id);
    final response = await apiClient.patch(endpoint, data: body);
    final resBody = response.data as Map<String, dynamic>;
    return PurchaseModel.fromJson(resBody['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deletePurchase(String id) async {
    final endpoint = ApiEndpoints.deletePurchase.replaceAll('{id}', id);
    await apiClient.delete(endpoint, data: {}, options: _jsonOptions);
  }

  // ── Purchase Item ─────────────────────────────────────────────────────────

  @override
  Future<PurchaseItemModel> createPurchaseItem(
    String purchaseId,
    Map<String, dynamic> body,
  ) async {
    final endpoint = ApiEndpoints.createPurchaseItem.replaceAll(
      '{purchaseId}',
      purchaseId,
    );
    final response = await apiClient.post(endpoint, data: body);
    final resBody = response.data as Map<String, dynamic>;
    return PurchaseItemModel.fromJson(resBody['data'] as Map<String, dynamic>);
  }

  @override
  Future<PurchaseItemModel> updatePurchaseItem(
    String purchaseId,
    String itemId,
    Map<String, dynamic> body,
  ) async {
    final endpoint = ApiEndpoints.updatePurchaseItem
        .replaceAll('{purchaseId}', purchaseId)
        .replaceAll('{itemId}', itemId);
    final response = await apiClient.patch(endpoint, data: body);
    final resBody = response.data as Map<String, dynamic>;
    return PurchaseItemModel.fromJson(resBody['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deletePurchaseItem(String purchaseId, String itemId) async {
    final endpoint = ApiEndpoints.deletePurchaseItem
        .replaceAll('{purchaseId}', purchaseId)
        .replaceAll('{itemId}', itemId);
    await apiClient.delete(endpoint, data: {}, options: _jsonOptions);
  }

  // ── Export ───────────────────────────────────────────────────────────────

  @override
  Future<String> exportData(Map<String, dynamic> body) async {
    final format = body['format'] as String? ?? 'csv';

    final response = await apiClient.get(
      ApiEndpoints.exportData,
      params: body,
      options: Options(responseType: ResponseType.bytes), // ← binary response
    );

    // Pick the right extension
    final extension = _extensionFromFormat(format);
    final fileName =
        'electra_export_${DateTime.now().millisecondsSinceEpoch}.$extension';

    // Save to the device's temp/downloads directory
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(response.data as List<int>);

    return filePath;
  }

  static String _extensionFromFormat(String format) {
    switch (format) {
      case 'pdf':
        return 'pdf';
      case 'excel':
        return 'xlsx';
      case 'csv':
      default:
        return 'csv';
    }
  }
}
