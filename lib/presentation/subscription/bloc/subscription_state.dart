import 'package:electra/data/source/subscription/iap_datasource.dart';
import 'package:electra/domain/entities/subscription/subscription.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

/// Products loaded from the store and subscription fetched from backend.
class SubscriptionLoaded extends SubscriptionState {
  final Subscription subscription;
  final List<ProductDetails> products;

  const SubscriptionLoaded({
    required this.subscription,
    required this.products,
  });

  ProductDetails? get monthlyProduct => _find(IAPProducts.monthlyId);
  ProductDetails? get annualProduct => _find(IAPProducts.annualId);

  ProductDetails? _find(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [subscription, products];
}

/// A purchase/restore flow is in progress — show loading on the button.
class SubscriptionPurchasing extends SubscriptionState {
  final Subscription subscription;
  final List<ProductDetails> products;

  const SubscriptionPurchasing({
    required this.subscription,
    required this.products,
  });

  @override
  List<Object?> get props => [subscription, products];
}

/// Purchase successfully verified with the backend.
class SubscriptionActivated extends SubscriptionState {
  final Subscription subscription;

  const SubscriptionActivated(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class SubscriptionFailure extends SubscriptionState {
  final String message;

  const SubscriptionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
