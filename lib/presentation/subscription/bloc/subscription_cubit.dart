import 'package:electra/data/source/subscription/iap_datasource.dart';
import 'package:electra/domain/usecases/subscription/subscription_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetSubscriptionUseCase _getSubscription;
  final VerifySubscriptionUseCase _verifyPurchase;
  final RestoreSubscriptionUseCase _restorePurchases;
  final CancelSubscriptionUseCase _cancelSubscription;
  final IAPDataSource _iap;

  SubscriptionCubit({
    required GetSubscriptionUseCase getSubscription,
    required VerifySubscriptionUseCase verifyPurchase,
    required RestoreSubscriptionUseCase restorePurchases,
    required CancelSubscriptionUseCase cancelSubscription,
    required IAPDataSource iap,
  }) : _getSubscription = getSubscription,
       _verifyPurchase = verifyPurchase,
       _restorePurchases = restorePurchases,
       _cancelSubscription = cancelSubscription,
       _iap = iap,
       super(const SubscriptionInitial());

  /// Load subscription from backend + products from the store in parallel.
  Future<void> load() async {
    emit(const SubscriptionLoading());

    final results = await Future.wait([_getSubscription(), _iap.getProducts()]);

    final subscriptionResult =
        results[0] as dynamic; // Either<Failure, Subscription>
    final products = results[1] as List<ProductDetails>;

    subscriptionResult.fold(
      (failure) => emit(SubscriptionFailure(failure.message)),
      (subscription) => emit(
        SubscriptionLoaded(subscription: subscription, products: products),
      ),
    );
  }

  /// Initiate a purchase for [product] then verify with backend.
  Future<void> subscribe(ProductDetails product) async {
    final current = _currentLoaded();
    if (current == null) return;

    emit(
      SubscriptionPurchasing(
        subscription: current.subscription,
        products: current.products,
      ),
    );

    try {
      // 1. Launch native store purchase sheet.
      final iapResult = await _iap.purchase(product);

      // 2. Send token/transactionId to backend for server-side verification.
      final result = await _verifyPurchase(
        provider: iapResult.provider,
        providerId: iapResult.providerId,
        productId: iapResult.productId,
      );

      result.fold((failure) {
        emit(SubscriptionFailure(failure.message));
        // Restore previous loaded state so user can retry.
        emit(current);
      }, (subscription) => emit(SubscriptionActivated(subscription)));
    } catch (e) {
      // User cancelled or store error.
      final msg = e.toString().contains('cancelled')
          ? 'Purchase cancelled.'
          : 'Purchase failed. Please try again.';
      emit(SubscriptionFailure(msg));
      emit(current); // restore UI
    }
  }

  /// Restore previously purchased subscriptions.
  Future<void> restore() async {
    final current = _currentLoaded();
    if (current == null) return;

    emit(
      SubscriptionPurchasing(
        subscription: current.subscription,
        products: current.products,
      ),
    );

    final result = await _restorePurchases();

    result.fold((failure) {
      emit(SubscriptionFailure(failure.message));
      emit(current);
    }, (subscription) => emit(SubscriptionActivated(subscription)));
  }

  /// Cancel the active subscription.
  Future<void> cancel() async {
    final current = _currentLoaded();
    if (current == null) return;

    emit(
      SubscriptionPurchasing(
        subscription: current.subscription,
        products: current.products,
      ),
    );

    final result = await _cancelSubscription();

    result.fold(
      (failure) {
        emit(SubscriptionFailure(failure.message));
        emit(current);
      },
      (subscription) => emit(
        SubscriptionLoaded(
          subscription: subscription,
          products: current.products,
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  SubscriptionLoaded? _currentLoaded() {
    final s = state;
    if (s is SubscriptionLoaded) return s;
    if (s is SubscriptionPurchasing) {
      return SubscriptionLoaded(
        subscription: s.subscription,
        products: s.products,
      );
    }
    return null;
  }
}
