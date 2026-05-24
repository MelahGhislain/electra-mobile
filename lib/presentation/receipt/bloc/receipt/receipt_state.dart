enum ReceiptScanStatus {
  idle,
  picking, // user selecting image
  extracting, // ML Kit OCR running on device
  scanning, // sending text to BE, DeepSeek parsing
  success,
  error,
}

class ReceiptState {
  final ReceiptScanStatus status;
  final String? imagePath;
  final String? error;

  const ReceiptState({
    this.status = ReceiptScanStatus.idle,
    this.imagePath,
    this.error,
  });

  bool get isLoading =>
      status == ReceiptScanStatus.picking ||
      status == ReceiptScanStatus.extracting ||
      status == ReceiptScanStatus.scanning;

  ReceiptState copyWith({
    ReceiptScanStatus? status,
    String? imagePath,
    String? error,
  }) {
    return ReceiptState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      error: error,
    );
  }
}
