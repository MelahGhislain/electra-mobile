import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/domain/entities/insights/insights.dart';

abstract class InsightsRepository {
  Future<Either<Failure, SpendingInsights>> getInsights({
    required String period,
    String? date,
  });
}
