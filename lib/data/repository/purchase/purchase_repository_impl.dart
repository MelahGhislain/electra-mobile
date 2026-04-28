import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:electra/core/errors/dio_error_mapper.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/data/source/purchase/purchase_remote_datasource.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/entities/purchase/purchase_item.dart';
import 'package:electra/domain/repository/purchase/purchase_repository.dart';
import 'package:flutter/foundation.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource remoteDataSource;
  const PurchaseRepositoryImpl(this.remoteDataSource);

  // ── Purchase ──────────────────────────────────────────────────────────────

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
      final models = await remoteDataSource.getPurchases();
      return Right(models.map((p) => p.toEntity()).toList());
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Purchase>> getPurchaseById(String id) async {
    try {
      final model = await remoteDataSource.getPurchaseById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Purchase>> createPurchase(
    Map<String, dynamic> body,
  ) async {
    try {
      final model = await remoteDataSource.createPurchase(body);
      return Right(model.toEntity());
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Purchase>> updatePurchase(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final model = await remoteDataSource.updatePurchase(id, body);
      return Right(model.toEntity());
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePurchase(String id) async {
    try {
      await remoteDataSource.deletePurchase(id);
      return const Right(null);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }

  // ── Purchase Item ─────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, PurchaseItem>> createPurchaseItem(
    String purchaseId,
    Map<String, dynamic> body,
  ) async {
    try {
      final model = await remoteDataSource.createPurchaseItem(purchaseId, body);
      return Right(model.toEntity());
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, PurchaseItem>> updatePurchaseItem(
    String purchaseId,
    String itemId,
    Map<String, dynamic> body,
  ) async {
    try {
      final model = await remoteDataSource.updatePurchaseItem(
        purchaseId,
        itemId,
        body,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePurchaseItem(
    String purchaseId,
    String itemId,
  ) async {
    try {
      await remoteDataSource.deletePurchaseItem(purchaseId, itemId);
      return const Right(null);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(UnknownFailure());
    }
  }
}
