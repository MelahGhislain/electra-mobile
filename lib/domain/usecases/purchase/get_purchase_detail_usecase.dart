import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/domain/entities/purchase/purchase.dart';
import 'package:minata/domain/repository/purchase/purchase_repository.dart';

class GetPurchaseDetailUseCase {
  final PurchaseRepository repository;
  const GetPurchaseDetailUseCase(this.repository);

  Future<Either<Failure, Purchase>> call(String id) =>
      repository.getPurchaseById(id);
}
