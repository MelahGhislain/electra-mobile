import 'package:electra/core/enums/image_source_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'receipt_state.dart';
import 'package:electra/domain/usecases/receipt/pick_receipt_image.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  final PickReceiptImage pickReceiptImage;

  ReceiptCubit(this.pickReceiptImage) : super(const ReceiptState());

  Future<void> pickImage(ImageSourceType source) async {
    final granted = await _requestCameraPermission();

    if (!granted) {
      emit(state.copyWith(isLoading: false, error: "Camera permission denied"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final image = await pickReceiptImage(source: source);

      if (image == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      emit(state.copyWith(isLoading: false, imagePath: image.path));
    } catch (_) {
      emit(state.copyWith(isLoading: false, error: "Failed to pick image"));
    }
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    final result = await Permission.camera.request();

    if (result.isPermanentlyDenied) {
      openAppSettings();
    }

    return result.isGranted;
  }
}
