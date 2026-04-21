class ReceiptState {
  final bool isLoading;
  final String? imagePath;
  final String? error;

  const ReceiptState({this.isLoading = false, this.imagePath, this.error});

  ReceiptState copyWith({bool? isLoading, String? imagePath, String? error}) {
    return ReceiptState(
      isLoading: isLoading ?? this.isLoading,
      imagePath: imagePath ?? this.imagePath,
      error: error,
    );
  }
}
