import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/domain/repository/purchase/purchase_repository.dart';

class CheckHasPurchasesUseCase {
  final PurchaseRepository repository;
  const CheckHasPurchasesUseCase(this.repository);

  Future<Either<Failure, bool>> call() => repository.hasPurchases();
}
