import 'package:equatable/equatable.dart';

enum ExportFileEnum { csv, pdf, excel }

class ExportPurchase extends Equatable {
  final ExportFileEnum format;
  final String? purchaseId;

  final DateTime? from;
  final DateTime? to;

  final bool includeAccountInfo;
  final bool includeTransactions;
  final bool includeSpendingSummary;

  const ExportPurchase({
    this.format = ExportFileEnum.csv,
    this.purchaseId,
    this.from,
    this.to,
    this.includeAccountInfo = true,
    this.includeTransactions = true,
    this.includeSpendingSummary = true,
  });

  @override
  List<Object?> get props => [
    format,
    purchaseId,
    from,
    to,
    includeAccountInfo,
    includeTransactions,
    includeSpendingSummary,
  ];
}
