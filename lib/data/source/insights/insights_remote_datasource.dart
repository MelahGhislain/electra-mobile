import 'package:electra/core/network/api_client.dart';
import 'package:electra/data/models/insights/insights_model.dart';
import 'package:electra/domain/entities/insights/insights.dart';

abstract class InsightsRemoteDataSource {
  Future<SpendingInsights> getInsights({required String period, String? date});
}

class InsightsRemoteDataSourceImpl implements InsightsRemoteDataSource {
  final ApiClient apiClient;
  const InsightsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<SpendingInsights> getInsights({
    required String period,
    String? date,
  }) async {
    final queryParams = <String, String>{'period': period};
    if (date != null) queryParams['date'] = date;

    final query = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final response = await apiClient.get('/insights?$query');

    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    return SpendingInsightsModel.fromJson(data);
  }
}
