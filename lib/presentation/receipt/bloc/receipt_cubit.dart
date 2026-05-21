import 'package:electra/core/enums/image_source_enum.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'receipt_state.dart';
import 'package:electra/domain/usecases/receipt/pick_receipt_image.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  final PickReceiptImage pickReceiptImage;
  final UploadReceipt uploadReceipt;
  final PurchaseCubit purchaseCubit;

  ReceiptCubit(this.pickReceiptImage, this.uploadReceipt, this.purchaseCubit) : super(const ReceiptState());

  Future<void> pickImageAndScan(ImageSourceType source) async {
    // ── 1. Permission (camera only) ────────────────────────────
    if (source == ImageSourceType.camera) {
      final granted = await _requestCameraPermission();

      if (!granted) {
        emit(state.copyWith(status: ReceiptScanStatus.error, error: "Camera permission denied"));
        return;
      }
    }

    // ── 2. Pick image using existing usecase ───────────────────
    emit(state.copyWith(status: ReceiptScanStatus.picking, error: null));

    try {
      final image = await pickReceiptImage(source: source);

      if (image == null) {
        emit(state.copyWith(status: ReceiptScanStatus.idle));
        return;
      }

      // ── 3. Upload as multipart ─────────────────────────────
      emit(state.copyWith(status: ReceiptScanStatus.scanning, imagePath: image.path));

      await uploadReceipt.call(image.path);

      // ── 4. Refresh purchase list ───────────────────────────
      await purchaseCubit.loadPurchases();

      emit(state.copyWith(status: ReceiptScanStatus.success));
    } on Exception catch (e){
      emit(state.copyWith(status: ReceiptScanStatus.error, error: _friendlyError(e)));
    }
  }

  void reset() => emit(const ReceiptState());

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    final result = await Permission.camera.request();

    if (result.isPermanentlyDenied) {
      openAppSettings();
    }

    return result.isGranted;
  }

  String _friendlyError(Exception e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket')) {
      return 'No internet connection. Please try again.';
    }
    if (msg.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    return 'Failed to scan receipt. Please try again.';
  }
}
