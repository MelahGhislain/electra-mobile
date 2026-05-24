import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:minata/core/errors/dio_error_mapper.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/data/source/insights/insights_remote_datasource.dart';
import 'package:minata/domain/entities/insights/insights.dart';
import 'package:minata/domain/repository/insights/insights_repository.dart';
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
