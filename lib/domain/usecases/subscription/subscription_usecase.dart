import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/subscription/subscription.dart';
import 'package:electra/domain/repository/subscription/subscription_repository.dart';

class GetSubscriptionUseCase {
  final SubscriptionRepository repository;
  const GetSubscriptionUseCase(this.repository);

  Future<Either<Failure, Subscription>> call() => repository.getSubscription();
}

class VerifySubscriptionUseCase {
  final SubscriptionRepository repository;
  const VerifySubscriptionUseCase(this.repository);

  Future<Either<Failure, Subscription>> call({
    required String provider,
    required String providerId,
    required String productId,
  }) => repository.verifyPurchase(
    provider: provider,
    providerId: providerId,
    productId: productId,
  );
}

class RestoreSubscriptionUseCase {
  final SubscriptionRepository repository;
  const RestoreSubscriptionUseCase(this.repository);

  Future<Either<Failure, Subscription>> call() => repository.restorePurchases();
}

class CancelSubscriptionUseCase {
  final SubscriptionRepository repository;
  const CancelSubscriptionUseCase(this.repository);

  Future<Either<Failure, Subscription>> call() =>
      repository.cancelSubscription();
}
