import 'package:dartz/dartz.dart';
import 'package:qleo/core/errors/failures.dart';
import 'package:qleo/domain/entities/purchase/purchase.dart';
import 'package:qleo/domain/repository/purchase/purchase_repository.dart';

class GetPurchasesUseCase {
  final PurchaseRepository repository;
  const GetPurchasesUseCase(this.repository);

  Future<Either<Failure, List<Purchase>>> call() => repository.getPurchases();
}
