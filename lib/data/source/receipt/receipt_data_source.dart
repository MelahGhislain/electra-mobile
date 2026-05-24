import 'package:dio/dio.dart';
import 'package:minata/core/network/api_client.dart';
import 'package:minata/core/network/api_endpoints.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptDataSource {
  final ImagePicker _picker;
  final ApiClient apiClient;

  ReceiptDataSource(this._picker, this.apiClient);

  // ── Image picking ──────────────────────────────────────────────────────────
  Future<String?> pickImageFromCamera() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // compress a bit
      );
      return file?.path;
    } catch (_) {
      return null;
    }
  }

  /// 🖼️ Pick from gallery (optional but useful)
  Future<String?> pickImageFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      return file?.path;
    } catch (_) {
      return null;
    }
  }

  // ── On-device OCR via ML Kit ───────────────────────────────────────────────

  /// Extracts raw text from an image using ML Kit (on-device, free, no API key).
  /// Works on both iOS (Vision framework) and Android (ML Kit).
  Future<String> extractTextFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);

    // Script.latin covers English and most Western European languages.
    // Use TextRecognitionScript.chinese / .japanese / .korean if needed.
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText result = await recognizer.processImage(inputImage);
      return result.text; // full extracted text, newlines preserved
    } finally {
      // Always close to release native resources
      await recognizer.close();
    }
  }

  // ── Remote: send extracted text to BE for DeepSeek parsing ────────────────
  Future<void> processReceiptText(String rawText) async {
    await apiClient.post(
      ApiEndpoints.processReceiptText,
      data: {'text': rawText},
    );
  }

  // ── Kept: original multipart upload (existing endpoint untouched) ─────────
  Future<void> uploadReceipt(String imagePath) async {
    final formData = FormData.fromMap({
      'receipt': await MultipartFile.fromFile(
        imagePath,
        filename: 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });

    await apiClient.post(
      ApiEndpoints.scanReceipt,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
