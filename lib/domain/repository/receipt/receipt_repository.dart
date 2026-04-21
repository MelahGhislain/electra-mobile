import 'package:electra/core/enums/image_source_enum.dart';
import 'package:electra/domain/entities/receipt/receipt_image.dart';

abstract class ReceiptRepository {
  Future<ReceiptImage?> pickImage({ImageSourceType source});
}
