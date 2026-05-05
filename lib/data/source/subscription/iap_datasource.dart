import 'dart:async';
import 'dart:io';
import 'package:electra/core/configs/env.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

/// Product IDs — must match exactly what you create in App Store Connect
/// and Google Play Console.
class IAPProducts {
  static String get monthlyId => Env.monthlyProductId;
  static String get annualId => Env.annualProductId;

  static Set<String> get all => {monthlyId, annualId};
}

/// Result returned after a purchase attempt.
class IAPResult {
  final String productId;
  final String providerId; // transactionId (iOS) or purchaseToken (Android)
  final String provider; // 'APPLE' | 'GOOGLE'

  const IAPResult({
    required this.productId,
    required this.providerId,
    required this.provider,
  });
}

class IAPDataSource {
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Completes when a purchase flow resolves (success or error).
  Completer<IAPResult>? _purchaseCompleter;

  /// Call once at app start (from service locator init).
  Future<void> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) return;

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        debugPrint('[IAP] Stream error: $error');
        _purchaseCompleter?.completeError(error);
        _purchaseCompleter = null;
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  /// Fetch product details from the store.
  Future<List<ProductDetails>> getProducts() async {
    final response = await _iap.queryProductDetails(IAPProducts.all);
    if (response.error != null) {
      debugPrint('[IAP] Product query error: ${response.error}');
    }
    return response.productDetails;
  }

  /// Launch the native purchase sheet and wait for the result.
  Future<IAPResult> purchase(ProductDetails product) async {
    if (_purchaseCompleter != null && !_purchaseCompleter!.isCompleted) {
      throw StateError('A purchase is already in progress.');
    }

    _purchaseCompleter = Completer<IAPResult>();

    final param = PurchaseParam(productDetails: product);

    // Subscriptions use buyNonConsumable on both platforms.
    final started = await _iap.buyNonConsumable(purchaseParam: param);
    if (!started) {
      _purchaseCompleter!.completeError(
        Exception('Failed to start purchase flow.'),
      );
      _purchaseCompleter = null;
    }

    return _purchaseCompleter!.future;
  }

  /// Restore previous purchases — required by Apple guidelines.
  Future<List<IAPResult>> restore() async {
    final results = <IAPResult>[];
    final completer = Completer<List<IAPResult>>();

    final sub = _iap.purchaseStream.listen((purchases) {
      for (final p in purchases) {
        if (p.status == PurchaseStatus.restored ||
            p.status == PurchaseStatus.purchased) {
          final result = _toIAPResult(p);
          if (result != null) results.add(result);
          _iap.completePurchase(p);
        }
      }
    });

    await _iap.restorePurchases();
    // Give the stream a moment to deliver restored purchases.
    await Future.delayed(const Duration(seconds: 2));
    await sub.cancel();

    completer.complete(results);
    return completer.future;
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _handlePurchase(purchase);
    }
  }

  void _handlePurchase(PurchaseDetails purchase) {
    switch (purchase.status) {
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        // Always call completePurchase to tell the store we handled it.
        _iap.completePurchase(purchase);
        final result = _toIAPResult(purchase);
        if (result != null) {
          _purchaseCompleter?.complete(result);
          _purchaseCompleter = null;
        }
        break;

      case PurchaseStatus.error:
        debugPrint('[IAP] Purchase error: ${purchase.error?.message}');
        _purchaseCompleter?.completeError(
          Exception(purchase.error?.message ?? 'Purchase failed'),
        );
        _purchaseCompleter = null;
        break;

      case PurchaseStatus.canceled:
        _purchaseCompleter?.completeError(Exception('Purchase was cancelled.'));
        _purchaseCompleter = null;
        break;

      case PurchaseStatus.pending:
        // Purchase is pending (e.g. parental approval on Android).
        // Don't complete yet — wait for the next update.
        debugPrint('[IAP] Purchase pending: ${purchase.productID}');
        break;
    }
  }

  IAPResult? _toIAPResult(PurchaseDetails purchase) {
    if (Platform.isIOS) {
      final skDetails = purchase as AppStorePurchaseDetails?;
      final transactionId =
          skDetails?.skPaymentTransaction.transactionIdentifier;
      if (transactionId == null) return null;
      return IAPResult(
        productId: purchase.productID,
        providerId: transactionId,
        provider: 'APPLE',
      );
    } else {
      final googleDetails = purchase as GooglePlayPurchaseDetails?;
      final token = googleDetails?.billingClientPurchase.purchaseToken;
      if (token == null) return null;
      return IAPResult(
        productId: purchase.productID,
        providerId: token,
        provider: 'GOOGLE',
      );
    }
  }
}
