import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/subscription/subscription.dart';

abstract class SubscriptionRepository {
  /// Fetch the current user's subscription from the backend.
  Future<Either<Failure, Subscription>> getSubscription();

  /// Send the store receipt/token to the backend to verify and activate.
  Future<Either<Failure, Subscription>> verifyPurchase({
    required String provider, // 'APPLE' | 'GOOGLE'
    required String
    providerId, // transactionId (Apple) or purchaseToken (Google)
    required String productId, // e.g. 'com.electra.premium.monthly'
  });

  /// Restore previously purchased subscriptions (required by App Store guidelines).
  Future<Either<Failure, Subscription>> restorePurchases();

  /// Cancel the subscription.
  Future<Either<Failure, Subscription>> cancelSubscription();
}
