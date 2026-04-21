import 'package:image_picker/image_picker.dart';

class ReceiptDataSource {
  final ImagePicker _picker;

  ReceiptDataSource(this._picker);

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
}
