import 'package:minata/data/models/purchase/export_purchase_model.dart';
import 'package:minata/domain/entities/purchase/export_purchase.dart';
import 'package:minata/domain/entities/purchase/purchase.dart';
import 'package:minata/domain/usecases/purchase/export_purchase_usecase.dart';
import 'package:minata/domain/usecases/purchase/get_purchases_usecase.dart';
import 'package:minata/domain/usecases/purchase/purchase_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final GetPurchasesUseCase _getPurchases;
  final CreatePurchaseUseCase _createPurchase;
  final UpdatePurchaseUseCase _updatePurchase;
  final DeletePurchaseUseCase _deletePurchase;
  final ExportPurchaseUseCase _exportPurchase;

  PurchaseCubit({
    required GetPurchasesUseCase getPurchases,
    required CreatePurchaseUseCase createPurchase,
    required UpdatePurchaseUseCase updatePurchase,
    required DeletePurchaseUseCase deletePurchase,
    required ExportPurchaseUseCase exportPurchase,
  }) : _getPurchases = getPurchases,
       _createPurchase = createPurchase,
       _updatePurchase = updatePurchase,
       _deletePurchase = deletePurchase,
       _exportPurchase = exportPurchase,
       super(const PurchaseInitial());

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<void> loadPurchases() async {
    emit(const PurchaseLoading());
    final result = await _getPurchases();
    result.fold(
      (failure) {
        emit(PurchaseFailure(failure.message));
      },
      (purchases){
        emit(PurchaseLoaded(purchases));
      },
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
      (purchase) async {
        // Prepend the new purchase and notify created so the UI can navigate.
        emit(PurchaseCreated(purchase));
        emit(PurchaseLoaded([purchase, ...current]));
        await loadPurchases();
      },
    );
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<void> updatePurchase(String id, Map<String, dynamic> body) async {
    final current = _currentList();
    emit(PurchaseMutating(current));

    final result = await _updatePurchase(id, body);
    result.fold(
      (failure) { 
        emit(
        PurchaseMutationFailure(message: failure.message, purchases: current),
      );
      },
      (updated) async {
        // final refreshed = current.map((p) => p.id == id ? updated : p).toList();
        // emit(PurchaseLoaded(refreshed));
        await loadPurchases();
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
      (_) async {
        emit(const PurchaseDeleted());
        emit(PurchaseLoaded(current.where((p) => p.id != id).toList()));
        await loadPurchases();
      },
    );
  }

  // ── Export ────────────────────────────────────────────────────────────────

  Future<void> exportData(ExportPurchase export) async {
    emit(const PurchaseExporting());

    final body = ExportPurchaseModel.fromEntity(export).toJson();
    final result = await _exportPurchase(body);

    result.fold(
      (failure) => emit(PurchaseExportFailure(failure.message)),
      (_) => emit(const PurchaseExported()),
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
