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

// ── Mutation states ───────────────────────────────────────────────────────────

/// Emitted while a create/update/delete call is in flight.
/// [purchases] carries the last known list so the UI stays rendered.
class PurchaseMutating extends PurchaseState {
  final List<Purchase> purchases;
  const PurchaseMutating(this.purchases);

  @override
  List<Object?> get props => [purchases];
}

/// Emitted after a successful delete so the UI can pop/navigate away.
class PurchaseDeleted extends PurchaseState {
  const PurchaseDeleted();
}

/// Emitted after a successful create so the UI can navigate to the new purchase.
class PurchaseCreated extends PurchaseState {
  final Purchase purchase;
  const PurchaseCreated(this.purchase);

  @override
  List<Object?> get props => [purchase];
}

class PurchaseMutationFailure extends PurchaseState {
  final String message;

  /// The list before the failed mutation so the UI can restore it.
  final List<Purchase> purchases;

  const PurchaseMutationFailure({
    required this.message,
    required this.purchases,
  });

  @override
  List<Object?> get props => [message, purchases];
}
