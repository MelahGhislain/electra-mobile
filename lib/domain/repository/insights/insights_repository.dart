import 'package:dartz/dartz.dart';
import 'package:qleo/core/errors/failures.dart';
import 'package:qleo/domain/entities/insights/insights.dart';

abstract class InsightsRepository {
  Future<Either<Failure, SpendingInsights>> getInsights({
    required String period,
    String? date,
  });
}
