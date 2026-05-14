import 'package:electra/domain/entities/purchase/export_purchase.dart';
import 'package:equatable/equatable.dart';

class ExportPurchaseModel extends Equatable {
  final ExportFileEnum format;
  final String? purchaseId;

  final DateTime? from;
  final DateTime? to;

  final bool includeAccountInfo;
  final bool includeTransactions;
  final bool includeSpendingSummary;

  const ExportPurchaseModel({
    this.format = ExportFileEnum.csv,
    this.purchaseId,
    this.from,
    this.to,
    this.includeAccountInfo = true,
    this.includeTransactions = true,
    this.includeSpendingSummary = true,
  });

  factory ExportPurchaseModel.fromJson(Map<String, dynamic> json) {
    return ExportPurchaseModel(
      format: _parseFormat(json['format']),
      purchaseId: json['purchaseId'] != null
          ? json['purchaseId'] as String
          : null,
      from: json['from'] != null ? DateTime.tryParse(json['from']) : null,
      to: json['to'] != null ? DateTime.tryParse(json['to']) : null,
      includeAccountInfo: json['includeAccountInfo'] ?? true,
      includeTransactions: json['includeTransactions'] ?? true,
      includeSpendingSummary: json['includeSpendingSummary'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'format': format.name,
      if (purchaseId != null) 'purchaseId': purchaseId,
      if (from != null) 'from': from!.toUtc().toIso8601String(),
      if (to != null) 'to': to!.toUtc().toIso8601String(),
      'includeAccountInfo': includeAccountInfo,
      'includeTransactions': includeTransactions,
      'includeSpendingSummary': includeSpendingSummary,
    };
  }

  ExportPurchase toEntity() {
    return ExportPurchase(
      format: format,
      purchaseId: purchaseId,
      from: from,
      to: to,
      includeAccountInfo: includeAccountInfo,
      includeTransactions: includeTransactions,
      includeSpendingSummary: includeSpendingSummary,
    );
  }

  factory ExportPurchaseModel.fromEntity(ExportPurchase entity) {
    return ExportPurchaseModel(
      format: entity.format,
      purchaseId: entity.purchaseId,
      from: entity.from,
      to: entity.to,
      includeAccountInfo: entity.includeAccountInfo,
      includeTransactions: entity.includeTransactions,
      includeSpendingSummary: entity.includeSpendingSummary,
    );
  }

  static ExportFileEnum _parseFormat(dynamic value) {
    switch (value) {
      case 'csv':
        return ExportFileEnum.csv;
      case 'pdf':
        return ExportFileEnum.pdf;
      case 'excel':
      default:
        return ExportFileEnum.excel;
    }
  }

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
