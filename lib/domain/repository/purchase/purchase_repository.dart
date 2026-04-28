import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/entities/purchase/purchase_item.dart';

abstract class PurchaseRepository {
  // ── Purchase ──────────────────────────────────────────────────────────────
  Future<Either<Failure, bool>> hasPurchases();
  Future<Either<Failure, List<Purchase>>> getPurchases();
  Future<Either<Failure, Purchase>> getPurchaseById(String id);
  Future<Either<Failure, Purchase>> createPurchase(Map<String, dynamic> body);
  Future<Either<Failure, Purchase>> updatePurchase(
    String id,
    Map<String, dynamic> body,
  );
  Future<Either<Failure, void>> deletePurchase(String id);

  // ── Purchase Item ─────────────────────────────────────────────────────────
  Future<Either<Failure, PurchaseItem>> createPurchaseItem(
    String purchaseId,
    Map<String, dynamic> body,
  );
  Future<Either<Failure, PurchaseItem>> updatePurchaseItem(
    String purchaseId,
    String itemId,
    Map<String, dynamic> body,
  );
  Future<Either<Failure, void>> deletePurchaseItem(
    String purchaseId,
    String itemId,
  );
}
