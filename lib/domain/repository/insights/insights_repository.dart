import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/insights/insights.dart';

abstract class InsightsRepository {
  Future<Either<Failure, SpendingInsights>> getInsights({
    required String period,
    String? date,
  });
}
