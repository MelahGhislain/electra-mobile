import 'package:electra/domain/entities/receipt/receipt_image.dart';
import 'package:electra/domain/repository/receipt/receipt_repository.dart';
import 'package:electra/data/source/receipt/receipt_data_source.dart';
import 'package:electra/core/enums/image_source_enum.dart';

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
}
