import 'package:qleo/core/enums/image_source_enum.dart';
import 'package:qleo/data/source/receipt/receipt_data_source.dart';
import 'package:qleo/domain/entities/receipt/receipt_image.dart';
import 'package:qleo/domain/repository/receipt/receipt_repository.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptDataSource dataSource;

  ReceiptRepositoryImpl(this.dataSource);

  @override
  Future<ReceiptImage?> pickImage({
    ImageSourceType source = ImageSourceType.camera,
  }) async {
    final path = source == ImageSourceType.camera
        ? await dataSource.pickImageFromCamera()
        : await dataSource.pickImageFromGallery();

    if (path == null) return null;
    return ReceiptImage(path: path);
  }

  @override
  Future<String> extractTextFromImage(String imagePath) {
    return dataSource.extractTextFromImage(imagePath);
  }

  @override
  Future<void> processReceiptText(String rawText) {
    return dataSource.processReceiptText(rawText);
  }

  @override
  Future<void> uploadReceipt(String imagePath) {
    return dataSource.uploadReceipt(imagePath);
  }
}
