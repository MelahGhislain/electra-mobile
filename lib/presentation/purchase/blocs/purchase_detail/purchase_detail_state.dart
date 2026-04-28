import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/entities/purchase/purchase_item.dart';
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

// ── Item mutation states ──────────────────────────────────────────────────────

/// In-flight — purchase is still shown, a spinner can overlay the affected item.
class PurchaseDetailItemMutating extends PurchaseDetailState {
  final Purchase purchase;

  /// The item id being mutated so the UI can show a localised spinner.
  final String? itemId;

  const PurchaseDetailItemMutating(this.purchase, {this.itemId});

  @override
  List<Object?> get props => [purchase, itemId];
}

/// Item successfully created — purchase reflects the new item.
class PurchaseDetailItemCreated extends PurchaseDetailState {
  final Purchase purchase;
  final PurchaseItem item;

  const PurchaseDetailItemCreated({required this.purchase, required this.item});

  @override
  List<Object?> get props => [purchase, item];
}

/// Item mutation failed — purchase is unchanged.
class PurchaseDetailItemMutationFailure extends PurchaseDetailState {
  final String message;
  final Purchase purchase;

  const PurchaseDetailItemMutationFailure({
    required this.message,
    required this.purchase,
  });

  @override
  List<Object?> get props => [message, purchase];
}
