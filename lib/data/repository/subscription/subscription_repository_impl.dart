import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:electra/core/errors/dio_error_mapper.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/data/source/subscription/iap_datasource.dart';
import 'package:electra/data/source/subscription/subscription_remote_datasource.dart';
import 'package:electra/domain/entities/subscription/subscription.dart';
import 'package:electra/domain/repository/subscription/subscription_repository.dart';
import 'package:flutter/foundation.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;
  final IAPDataSource iapDataSource;

  const SubscriptionRepositoryImpl({
    required this.remoteDataSource,
    required this.iapDataSource,
  });

  @override
  Future<Either<Failure, Subscription>> getSubscription() async {
    try {
      final model = await remoteDataSource.getSubscription();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('[SubscriptionRepo] getSubscription error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Subscription>> verifyPurchase({
    required String provider,
    required String providerId,
    required String productId,
  }) async {
    try {
      final model = await remoteDataSource.verifyPurchase(
        provider: provider,
        providerId: providerId,
        productId: productId,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('[SubscriptionRepo] verifyPurchase error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Subscription>> restorePurchases() async {
    try {
      // 1. Ask the store for any previously purchased subscriptions.
      final results = await iapDataSource.restore();

      if (results.isEmpty) {
        return const Left(ServerFailure('No previous purchases found.'));
      }

      // 2. Send the most recent one to the backend to verify & activate.
      final latest = results.last;
      final model = await remoteDataSource.verifyPurchase(
        provider: latest.provider,
        providerId: latest.providerId,
        productId: latest.productId,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('[SubscriptionRepo] restorePurchases error: $e');
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Subscription>> cancelSubscription() async {
    try {
      final model = await remoteDataSource.cancelSubscription();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      debugPrint('[SubscriptionRepo] cancelSubscription error: $e');
      return Left(UnknownFailure());
    }
  }
}
