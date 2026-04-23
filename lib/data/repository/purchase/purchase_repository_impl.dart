import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:electra/core/errors/dio_error_mapper.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/repository/purchase/purchase_repository.dart';
import 'package:electra/data/source/purchase/purchase_remote_datasource.dart';
import 'package:flutter/foundation.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource remoteDataSource;
  const PurchaseRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> hasPurchases() async {
    try {
      final purchases = await remoteDataSource.getPurchases();
      return Right(purchases.isNotEmpty);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<Purchase>>> getPurchases() async {
    try {
      final purchases = await remoteDataSource.getPurchases();
      return Right(purchases.map((p) => p.toEntity()).toList());
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }
}
