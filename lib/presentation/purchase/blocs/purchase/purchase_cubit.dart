import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/usecases/purchase/get_purchases_usecase.dart';
import 'package:electra/domain/usecases/purchase/purchase_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final GetPurchasesUseCase _getPurchases;
  final CreatePurchaseUseCase _createPurchase;
  final UpdatePurchaseUseCase _updatePurchase;
  final DeletePurchaseUseCase _deletePurchase;

  PurchaseCubit({
    required GetPurchasesUseCase getPurchases,
    required CreatePurchaseUseCase createPurchase,
    required UpdatePurchaseUseCase updatePurchase,
    required DeletePurchaseUseCase deletePurchase,
  }) : _getPurchases = getPurchases,
       _createPurchase = createPurchase,
       _updatePurchase = updatePurchase,
       _deletePurchase = deletePurchase,
       super(const PurchaseInitial());

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<void> loadPurchases() async {
    emit(const PurchaseLoading());
    final result = await _getPurchases();
    result.fold(
      (failure) => emit(PurchaseFailure(failure.message)),
      (purchases) => emit(PurchaseLoaded(purchases)),
    );
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<void> createPurchase(Map<String, dynamic> body) async {
    final current = _currentList();
    emit(PurchaseMutating(current));

    final result = await _createPurchase(body);
    result.fold(
      (failure) => emit(
        PurchaseMutationFailure(message: failure.message, purchases: current),
      ),
      (purchase) {
        // Prepend the new purchase and notify created so the UI can navigate.
        emit(PurchaseCreated(purchase));
        emit(PurchaseLoaded([purchase, ...current]));
      },
    );
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<void> updatePurchase(String id, Map<String, dynamic> body) async {
    final current = _currentList();
    emit(PurchaseMutating(current));

    final result = await _updatePurchase(id, body);
    result.fold(
      (failure) => emit(
        PurchaseMutationFailure(message: failure.message, purchases: current),
      ),
      (updated) {
        final refreshed = current.map((p) => p.id == id ? updated : p).toList();
        emit(PurchaseLoaded(refreshed));
      },
    );
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> deletePurchase(String id) async {
    final current = _currentList();
    emit(PurchaseMutating(current));

    final result = await _deletePurchase(id);
    result.fold(
      (failure) => emit(
        PurchaseMutationFailure(message: failure.message, purchases: current),
      ),
      (_) {
        emit(const PurchaseDeleted());
        emit(PurchaseLoaded(current.where((p) => p.id != id).toList()));
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Safely extracts the current purchase list from whatever state we are in.
  List<Purchase> _currentList() {
    final s = state;
    if (s is PurchaseLoaded) return s.purchases;
    if (s is PurchaseMutating) return s.purchases;
    if (s is PurchaseMutationFailure) return s.purchases;
    return [];
  }
}
