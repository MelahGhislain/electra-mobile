import 'package:electra/core/enums/image_source_enum.dart';
import 'package:electra/domain/usecases/receipt/pick_receipt_image.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  final PickReceiptImage pickReceiptImage;
  final ExtractReceiptText extractReceiptText;
  final ProcessReceiptText processReceiptText;
  final PurchaseCubit purchaseCubit;

  ReceiptCubit({
    required this.pickReceiptImage,
    required this.extractReceiptText,
    required this.processReceiptText,
    required this.purchaseCubit,
  }) : super(const ReceiptState());

  Future<void> pickImageAndScan(ImageSourceType source) async {
    // ── 1. Camera permission ───────────────────────────────────
    if (source == ImageSourceType.camera) {
      final granted = await _requestCameraPermission();
      if (!granted) {
        emit(
          state.copyWith(
            status: ReceiptScanStatus.error,
            error: 'Camera permission denied',
          ),
        );
        return;
      }
    }

    // ── 2. Pick image ──────────────────────────────────────────
    emit(state.copyWith(status: ReceiptScanStatus.picking, error: null));

    try {
      final image = await pickReceiptImage(source: source);

      if (image == null) {
        // User cancelled
        emit(state.copyWith(status: ReceiptScanStatus.idle));
        return;
      }

      emit(
        state.copyWith(
          status: ReceiptScanStatus.extracting,
          imagePath: image.path,
        ),
      );

      // // ── 3. Upload as multipart ─────────────────────────────
      //       await uploadReceipt.call(image.path);

      // ── 3. On-device OCR — ML Kit, no network, no cost ────────
      final rawText = await extractReceiptText(image.path);

      if (rawText.trim().isEmpty) {
        emit(
          state.copyWith(
            status: ReceiptScanStatus.error,
            error: 'Could not read text from receipt. Try a clearer photo.',
          ),
        );
        return;
      }

      // ── 4. Send text to BE — DeepSeek parses it ───────────────
      emit(state.copyWith(status: ReceiptScanStatus.scanning));

      await processReceiptText(rawText);

      // ── 5. Refresh purchase list ───────────────────────────────
      await purchaseCubit.loadPurchases();

      emit(state.copyWith(status: ReceiptScanStatus.success));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ReceiptScanStatus.error,
          error: _friendlyError(e),
        ),
      );
    }
  }

  void reset() => emit(const ReceiptState());

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    final result = await Permission.camera.request();
    if (result.isPermanentlyDenied) openAppSettings();
    return result.isGranted;
  }

  String _friendlyError(Exception e) {
    final msg = e.toString().toLowerCase();
    debugPrint('============ $msg ============');
    if (msg.contains('network') || msg.contains('socket')) {
      return 'No internet connection. Please try again.';
    }
    if (msg.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (msg.contains('could not read') || msg.contains('empty')) {
      return 'Could not read receipt. Try a clearer photo.';
    }
    return 'Failed to scan receipt. Please try again.';
  }
}
