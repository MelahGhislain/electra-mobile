import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';

abstract class PurchaseRepository {
  Future<Either<Failure, bool>> hasPurchases();
  Future<Either<Failure, List<Purchase>>> getPurchases();
  Future<Either<Failure, Purchase>> getPurchaseById(String id);
}
