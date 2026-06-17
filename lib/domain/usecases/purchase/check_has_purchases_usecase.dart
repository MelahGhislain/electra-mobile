import 'package:dartz/dartz.dart';
import 'package:qleo/core/errors/failures.dart';
import 'package:qleo/domain/repository/purchase/purchase_repository.dart';

class CheckHasPurchasesUseCase {
  final PurchaseRepository repository;
  const CheckHasPurchasesUseCase(this.repository);

  Future<Either<Failure, bool>> call() => repository.hasPurchases();
}
