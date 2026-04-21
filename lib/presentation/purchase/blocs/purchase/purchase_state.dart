import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:equatable/equatable.dart';

abstract class PurchaseState extends Equatable {
  const PurchaseState();
  @override
  List<Object?> get props => [];
}

class PurchaseInitial extends PurchaseState {
  const PurchaseInitial();
}

class PurchaseLoading extends PurchaseState {
  const PurchaseLoading();
}

class PurchaseLoaded extends PurchaseState {
  final List<Purchase> purchases;
  const PurchaseLoaded(this.purchases);

  bool get isEmpty => purchases.isEmpty;

  @override
  List<Object?> get props => [purchases];
}

class PurchaseFailure extends PurchaseState {
  final String message;
  const PurchaseFailure(this.message);

  @override
  List<Object?> get props => [message];
}
