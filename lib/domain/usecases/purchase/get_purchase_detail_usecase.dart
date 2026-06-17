import 'package:dartz/dartz.dart';
import 'package:qleo/core/errors/failures.dart';
import 'package:qleo/domain/entities/purchase/purchase.dart';
import 'package:qleo/domain/repository/purchase/purchase_repository.dart';

class GetPurchaseDetailUseCase {
  final PurchaseRepository repository;
  const GetPurchaseDetailUseCase(this.repository);

  Future<Either<Failure, Purchase>> call(String id) =>
      repository.getPurchaseById(id);
}
