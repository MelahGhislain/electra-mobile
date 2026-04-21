import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electra/domain/usecases/purchase/get_purchases_usecase.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final GetPurchasesUseCase _getPurchases;

  PurchaseCubit(this._getPurchases) : super(const PurchaseInitial());

  Future<void> loadPurchases() async {
    emit(const PurchaseLoading());
    final result = await _getPurchases();
    result.fold(
      (failure) => emit(PurchaseFailure(failure.message)),
      (purchases) => emit(PurchaseLoaded(purchases)),
    );
  }
}
