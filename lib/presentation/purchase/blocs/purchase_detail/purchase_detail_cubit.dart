import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electra/domain/usecases/purchase/get_purchase_detail_usecase.dart';
import 'purchase_detail_state.dart';

class PurchaseDetailCubit extends Cubit<PurchaseDetailState> {
  final GetPurchaseDetailUseCase _getPurchaseDetail;

  PurchaseDetailCubit(this._getPurchaseDetail)
    : super(const PurchaseDetailInitial());

  Future<void> loadPurchase(String id) async {
    emit(const PurchaseDetailLoading());
    final result = await _getPurchaseDetail(id);
    result.fold(
      (failure) => emit(PurchaseDetailFailure(failure.message)),
      (purchase) => emit(PurchaseDetailLoaded(purchase)),
    );
  }
}
