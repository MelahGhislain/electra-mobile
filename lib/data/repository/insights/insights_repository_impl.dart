import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:electra/core/errors/dio_error_mapper.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/data/source/insights/insights_remote_datasource.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:electra/domain/repository/insights/insights_repository.dart';
import 'package:flutter/foundation.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource remoteDataSource;
  const InsightsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SpendingInsights>> getInsights({
    required String period,
    String? date,
  }) async {
    try {
      final insights = await remoteDataSource.getInsights(
        period: period,
        date: date,
      );
      return Right(insights);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }
}
