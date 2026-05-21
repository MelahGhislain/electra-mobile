import 'package:electra/core/enums/image_source_enum.dart';
import 'package:electra/domain/entities/receipt/receipt_image.dart';
import 'package:electra/domain/repository/receipt/receipt_repository.dart';

class PickReceiptImage {
  final ReceiptRepository repository;

  PickReceiptImage(this.repository);

  Future<ReceiptImage?> call({
    ImageSourceType source = ImageSourceType.camera,
  }) {
    return repository.pickImage(source: source);
  }
}

class UploadReceipt {
  final ReceiptRepository repository;

  UploadReceipt(this.repository);

  Future<void> call(String imagePath) {
    return repository.uploadReceipt(imagePath);
  }
}
