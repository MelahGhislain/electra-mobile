enum ReceiptScanStatus { idle, picking, scanning, success, error }

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
      status == ReceiptScanStatus.picking || status == ReceiptScanStatus.scanning;

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
