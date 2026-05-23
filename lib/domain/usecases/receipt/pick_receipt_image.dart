import 'package:electra/core/enums/image_source_enum.dart';
import 'package:electra/domain/entities/receipt/receipt_image.dart';
import 'package:electra/domain/repository/receipt/receipt_repository.dart';

/// Picks an image from camera or gallery
class PickReceiptImage {
  final ReceiptRepository repository;

  PickReceiptImage(this.repository);

  Future<ReceiptImage?> call({
    ImageSourceType source = ImageSourceType.camera,
  }) {
    return repository.pickImage(source: source);
  }
}

/// Extracts text from image using on-device ML Kit OCR
class ExtractReceiptText {
  final ReceiptRepository repository;

  ExtractReceiptText(this.repository);

  Future<String> call(String imagePath) {
    return repository.extractTextFromImage(imagePath);
  }
}

/// Sends extracted OCR text to backend for DeepSeek parsing
class ProcessReceiptText {
  final ReceiptRepository repository;

  ProcessReceiptText(this.repository);

  Future<void> call(String rawText) {
    return repository.processReceiptText(rawText);
  }
}

/// Original multipart upload usecase — kept untouched
class UploadReceipt {
  final ReceiptRepository repository;

  UploadReceipt(this.repository);

  Future<void> call(String imagePath) {
    return repository.uploadReceipt(imagePath);
  }
}
