import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/repository/purchase/purchase_repository.dart';

class CheckHasPurchasesUseCase {
  final PurchaseRepository repository;
  const CheckHasPurchasesUseCase(this.repository);

  Future<Either<Failure, bool>> call() => repository.hasPurchases();
}
