import 'package:electra/core/enums/image_source_enum.dart';
import 'package:electra/domain/entities/receipt/receipt_image.dart';

abstract class ReceiptRepository {
  /// Pick image from camera or gallery
  Future<ReceiptImage?> pickImage({ImageSourceType source});

  /// On-device OCR — extracts raw text from image using ML Kit
  Future<String> extractTextFromImage(String imagePath);

  /// Send extracted text to backend for DeepSeek parsing
  Future<void> processReceiptText(String rawText);

  /// Original multipart upload endpoint (kept, untouched)
  Future<void> uploadReceipt(String imagePath);
}
