import 'package:dio/dio.dart';
import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptDataSource {
  final ImagePicker _picker;
  final ApiClient apiClient;

  ReceiptDataSource(this._picker, this.apiClient);

  /// 📸 Pick from camera
  Future<String?> pickImageFromCamera() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // compress a bit
      );

      return file?.path;
    } catch (e) {
      // You can log this later
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
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadReceipt(String imagePath) async {
    final formData = FormData.fromMap({
      'receipt': await MultipartFile.fromFile(
        imagePath,
        filename: 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });

    await apiClient.post(ApiEndpoints.scanReceipt, data: formData);
  }
}
