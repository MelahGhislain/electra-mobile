import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/domain/entities/purchase/purchase.dart';
import 'package:minata/domain/repository/purchase/purchase_repository.dart';

class GetPurchasesUseCase {
  final PurchaseRepository repository;
  const GetPurchasesUseCase(this.repository);

  Future<Either<Failure, List<Purchase>>> call() => repository.getPurchases();
}
