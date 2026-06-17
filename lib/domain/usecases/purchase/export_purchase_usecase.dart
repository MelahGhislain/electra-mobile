import 'package:dartz/dartz.dart';
import 'package:qleo/core/errors/failures.dart';
import 'package:qleo/domain/repository/purchase/purchase_repository.dart';

class ExportPurchaseUseCase {
  final PurchaseRepository _repository;
  const ExportPurchaseUseCase(this._repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> body) =>
      _repository.exportData(body);
}
