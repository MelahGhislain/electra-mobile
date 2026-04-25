import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:equatable/equatable.dart';

abstract class PurchaseDetailState extends Equatable {
  const PurchaseDetailState();
  @override
  List<Object?> get props => [];
}

class PurchaseDetailInitial extends PurchaseDetailState {
  const PurchaseDetailInitial();
}

class PurchaseDetailLoading extends PurchaseDetailState {
  const PurchaseDetailLoading();
}

class PurchaseDetailLoaded extends PurchaseDetailState {
  final Purchase purchase;
  const PurchaseDetailLoaded(this.purchase);

  @override
  List<Object?> get props => [purchase];
}

class PurchaseDetailFailure extends PurchaseDetailState {
  final String message;
  const PurchaseDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}
