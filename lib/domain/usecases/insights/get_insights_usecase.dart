import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:electra/domain/repository/insights/insights_repository.dart';

class GetInsightsUseCase {
  final InsightsRepository repository;
  const GetInsightsUseCase(this.repository);

  Future<Either<Failure, SpendingInsights>> call({
    required String period,
    String? date,
  }) => repository.getInsights(period: period, date: date);
}
