import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/entities/purchase/purchase_item.dart';
import 'package:electra/domain/usecases/purchase/get_purchase_detail_usecase.dart';
import 'package:electra/domain/usecases/purchase/purchase_item_usecases.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'purchase_detail_state.dart';

class PurchaseDetailCubit extends Cubit<PurchaseDetailState> {
  final GetPurchaseDetailUseCase _getPurchaseDetail;
  final CreatePurchaseItemUseCase _createItem;
  final UpdatePurchaseItemUseCase _updateItem;
  final DeletePurchaseItemUseCase _deleteItem;

  /// The singleton PurchaseCubit that powers the spending list screen.
  /// After every successful mutation we:
  ///   1. Refetch this purchase from the BE (fresh totals, items, etc.)
  ///   2. Update the detail screen with the fresh data.
  ///   3. Tell PurchaseCubit to reload its full list so the spending screen
  ///      is never stale when the user navigates back.
  final PurchaseCubit _purchaseCubit;

  PurchaseDetailCubit({
    required GetPurchaseDetailUseCase getPurchaseDetail,
    required CreatePurchaseItemUseCase createItem,
    required UpdatePurchaseItemUseCase updateItem,
    required DeletePurchaseItemUseCase deleteItem,
    required PurchaseCubit purchaseCubit,
  }) : _getPurchaseDetail = getPurchaseDetail,
       _createItem = createItem,
       _updateItem = updateItem,
       _deleteItem = deleteItem,
       _purchaseCubit = purchaseCubit,
       super(const PurchaseDetailInitial());

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadPurchase(String id) async {
    emit(const PurchaseDetailLoading());
    final result = await _getPurchaseDetail(id);
    result.fold(
      (failure) => emit(PurchaseDetailFailure(failure.message)),
      (purchase) => emit(PurchaseDetailLoaded(purchase)),
    );
  }

  // ── Create item ───────────────────────────────────────────────────────────

  Future<void> createItem(Map<String, dynamic> body) async {
    final purchase = _currentPurchase();
    if (purchase == null) return;
    emit(PurchaseDetailItemMutating(purchase));

    final result = await _createItem(purchase.id, body);
    result.fold(
      (failure) => emit(
        PurchaseDetailItemMutationFailure(
          message: failure.message,
          purchase: purchase,
        ),
      ),
      (newItem) {
        final updated = _purchaseWithItems(purchase, [
          ...purchase.items,
          newItem,
        ]);
        emit(PurchaseDetailItemCreated(purchase: updated, item: newItem));
        emit(PurchaseDetailLoaded(updated));

        // 2. Reload the full purchases list in the background so the
        //    spending screen shows correct totals when the user goes back.
        //    This runs fire-and-forget — the detail screen is already updated.
        _purchaseCubit.loadPurchases();
      },
    );
  }

  // ── Update item ───────────────────────────────────────────────────────────

  Future<void> updateItem(String itemId, Map<String, dynamic> body) async {
    final purchase = _currentPurchase();
    if (purchase == null) return;

    emit(PurchaseDetailItemMutating(purchase, itemId: itemId));

    final result = await _updateItem(purchase.id, itemId, body);
    result.fold(
      (failure) => emit(
        PurchaseDetailItemMutationFailure(
          message: failure.message,
          purchase: purchase,
        ),
      ),
      (updatedItem) {
        final updatedItems = purchase.items
            .map((i) => i.id == itemId ? updatedItem : i)
            .toList();
        final updated = _purchaseWithItems(purchase, updatedItems);
        emit(PurchaseDetailLoaded(updated));

        // 2. Reload the full purchases list in the background so the
        //    spending screen shows correct totals when the user goes back.
        //    This runs fire-and-forget — the detail screen is already updated.
        _purchaseCubit.loadPurchases();
      },
    );
  }

  // ── Delete item ───────────────────────────────────────────────────────────

  Future<void> deleteItem(String itemId) async {
    final purchase = _currentPurchase();
    if (purchase == null) return;

    emit(PurchaseDetailItemMutating(purchase, itemId: itemId));

    final result = await _deleteItem(purchase.id, itemId);
    result.fold(
      (failure) => emit(
        PurchaseDetailItemMutationFailure(
          message: failure.message,
          purchase: purchase,
        ),
      ),
      (_) {
        final updatedItems = purchase.items
            .map((i) => i.id == itemId ? _markDeleted(i) : i)
            .toList();
        final updated = _purchaseWithItems(purchase, updatedItems);
        emit(PurchaseDetailLoaded(updated));

        // 2. Reload the full purchases list in the background so the
        //    spending screen shows correct totals when the user goes back.
        //    This runs fire-and-forget — the detail screen is already updated.
        _purchaseCubit.loadPurchases();
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Purchase? _currentPurchase() {
    final s = state;
    if (s is PurchaseDetailLoaded) return s.purchase;
    if (s is PurchaseDetailItemMutating) return s.purchase;
    if (s is PurchaseDetailItemMutationFailure) return s.purchase;
    if (s is PurchaseDetailItemCreated) return s.purchase;
    return null;
  }

  /// Returns a copy of [purchase] with a replaced items list.
  /// Since [Purchase] is immutable (Equatable) we rebuild it field-by-field.
  Purchase _purchaseWithItems(Purchase purchase, List<PurchaseItem> items) {
    return Purchase(
      id: purchase.id,
      userId: purchase.userId,
      merchant: purchase.merchant,
      payment: purchase.payment,
      totals: purchase.totals,
      purchaseDate: purchase.purchaseDate,
      dataSource: purchase.dataSource,
      items: items,
      categorySummary: purchase.categorySummary,
      ai: purchase.ai,
      receipt: purchase.receipt,
      voice: purchase.voice,
      tags: purchase.tags,
      isDeleted: purchase.isDeleted,
      createdAt: purchase.createdAt,
      updatedAt: purchase.updatedAt,
    );
  }

  /// Soft-deletes an item locally to match the API's behaviour.
  PurchaseItem _markDeleted(PurchaseItem item) {
    return PurchaseItem(
      id: item.id,
      name: item.name,
      normalizedName: item.normalizedName,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      totalPrice: item.totalPrice,
      category: item.category,
      ai: item.ai,
      isEdited: item.isEdited,
      isDeleted: true,
    );
  }
}
