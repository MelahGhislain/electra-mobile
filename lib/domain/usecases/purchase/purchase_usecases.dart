import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/repository/purchase/purchase_repository.dart';

class CreatePurchaseUseCase {
  final PurchaseRepository repository;
  const CreatePurchaseUseCase(this.repository);

  Future<Either<Failure, Purchase>> call(Map<String, dynamic> body) =>
      repository.createPurchase(body);
}

class UpdatePurchaseUseCase {
  final PurchaseRepository repository;
  const UpdatePurchaseUseCase(this.repository);

  Future<Either<Failure, Purchase>> call(
    String id,
    Map<String, dynamic> body,
  ) => repository.updatePurchase(id, body);
}

class DeletePurchaseUseCase {
  final PurchaseRepository repository;
  const DeletePurchaseUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) =>
      repository.deletePurchase(id);
}
