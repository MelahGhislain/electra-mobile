import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/repository/purchase/purchase_repository.dart';

class GetPurchasesUseCase {
  final PurchaseRepository repository;
  const GetPurchasesUseCase(this.repository);

  Future<Either<Failure, List<Purchase>>> call() => repository.getPurchases();
}
