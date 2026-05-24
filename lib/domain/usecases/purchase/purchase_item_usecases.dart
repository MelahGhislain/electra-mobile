import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/domain/entities/purchase/purchase_item.dart';
import 'package:minata/domain/repository/purchase/purchase_repository.dart';

class CreatePurchaseItemUseCase {
  final PurchaseRepository repository;
  const CreatePurchaseItemUseCase(this.repository);

  Future<Either<Failure, PurchaseItem>> call(
    String purchaseId,
    Map<String, dynamic> body,
  ) => repository.createPurchaseItem(purchaseId, body);
}

class UpdatePurchaseItemUseCase {
  final PurchaseRepository repository;
  const UpdatePurchaseItemUseCase(this.repository);

  Future<Either<Failure, PurchaseItem>> call(
    String purchaseId,
    String itemId,
    Map<String, dynamic> body,
  ) => repository.updatePurchaseItem(purchaseId, itemId, body);
}

class DeletePurchaseItemUseCase {
  final PurchaseRepository repository;
  const DeletePurchaseItemUseCase(this.repository);

  Future<Either<Failure, void>> call(String purchaseId, String itemId) =>
      repository.deletePurchaseItem(purchaseId, itemId);
}
