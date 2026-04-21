// domain/entities/purchase.dart

import 'package:electra/domain/entities/purchase/purchase_item.dart';
import 'package:equatable/equatable.dart';

/// =========================
/// ENUMS
/// =========================

enum PaymentMethod { card, cash, other }

enum DataSource { manual, receipt, voice }

/// =========================
/// SUB ENTITIES
/// =========================

class Merchant extends Equatable {
  final String name;
  final String normalizedName;
  final String? brand;

  const Merchant({
    required this.name,
    required this.normalizedName,
    this.brand,
  });

  @override
  List<Object?> get props => [name, normalizedName, brand];
}

class Payment extends Equatable {
  final PaymentMethod method;
  final String? last4;

  const Payment({this.method = PaymentMethod.other, this.last4});

  @override
  List<Object?> get props => [method, last4];
}

class Totals extends Equatable {
  final double amount;
  final String currency;

  final int itemCount;
  final double? avgItemPrice;

  final double? tax;
  final double? discount;

  const Totals({
    required this.amount,
    required this.currency,
    required this.itemCount,
    this.avgItemPrice,
    this.tax,
    this.discount,
  });

  @override
  List<Object?> get props => [
    amount,
    currency,
    itemCount,
    avgItemPrice,
    tax,
    discount,
  ];
}

class CategorySummary extends Equatable {
  final String name;
  final double total;
  final int count;

  const CategorySummary({
    required this.name,
    required this.total,
    required this.count,
  });

  @override
  List<Object?> get props => [name, total, count];
}

class PurchaseAI extends Equatable {
  final bool isProcessed;
  final String? version;
  final double? confidenceScore;
  final List<String> parsingErrors;
  final Map<String, dynamic>? extractedData;

  const PurchaseAI({
    this.isProcessed = false,
    this.version,
    this.confidenceScore,
    this.parsingErrors = const [],
    this.extractedData,
  });

  @override
  List<Object?> get props => [
    isProcessed,
    version,
    confidenceScore,
    parsingErrors,
    extractedData,
  ];
}

class Receipt extends Equatable {
  final String? imageUrl;
  final String? rawText;
  final List<String>? parsedText;
  final DateTime? uploadedAt;
  final String? name;

  const Receipt({
    this.imageUrl,
    this.rawText,
    this.parsedText,
    this.uploadedAt,
    this.name,
  });

  @override
  List<Object?> get props => [imageUrl, rawText, parsedText, uploadedAt, name];
}

class Voice extends Equatable {
  final String? transcript;
  final double? confidence;

  const Voice({this.transcript, this.confidence});

  @override
  List<Object?> get props => [transcript, confidence];
}

/// =========================
/// MAIN ENTITY
/// =========================

class Purchase extends Equatable {
  final String id;
  final String userId;

  final Merchant? merchant;
  final Payment payment;

  final Totals totals;

  final DateTime purchaseDate;
  final DataSource dataSource;

  final List<PurchaseItem> items;
  final List<CategorySummary> categorySummary;

  final PurchaseAI ai;

  final Receipt? receipt;
  final Voice? voice;

  final List<String> tags;

  final bool isDeleted;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Purchase({
    required this.id,
    required this.userId,
    this.merchant,
    this.payment = const Payment(),
    required this.totals,
    required this.purchaseDate,
    this.dataSource = DataSource.manual,
    this.items = const [],
    this.categorySummary = const [],
    this.ai = const PurchaseAI(),
    this.receipt,
    this.voice,
    this.tags = const [],
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  /// 🔥 Domain helper (equivalent to your Mongoose filter)
  List<PurchaseItem> get activeItems =>
      items.where((i) => !i.isDeleted).toList();

  @override
  List<Object?> get props => [
    id,
    userId,
    merchant,
    payment,
    totals,
    purchaseDate,
    dataSource,
    items,
    categorySummary,
    ai,
    receipt,
    voice,
    tags,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
