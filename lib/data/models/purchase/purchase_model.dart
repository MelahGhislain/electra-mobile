import 'package:electra/data/models/purchase/purchase_item_model.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:equatable/equatable.dart';

class PurchaseModel extends Equatable {
  final String id;
  final String userId;

  final MerchantModel? merchant;
  final PaymentModel payment;

  final TotalsModel totals;

  final DateTime purchaseDate;
  final DataSource dataSource;

  final List<PurchaseItemModel> items;

  final bool isDeleted;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PurchaseModel({
    required this.id,
    required this.userId,
    this.merchant,
    required this.payment,
    required this.totals,
    required this.purchaseDate,
    required this.dataSource,
    required this.items,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  /// =========================
  /// JSON
  /// =========================

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] ?? json['_id'],
      userId: json['userId'],
      merchant: json['merchant'] != null
          ? MerchantModel.fromJson(json['merchant'])
          : null,
      payment: json['payment'] != null
          ? PaymentModel.fromJson(json['payment'])
          : const PaymentModel(),
      totals: TotalsModel.fromJson(json['totals']),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      dataSource: _mapDataSource(json['dataSource']),
      items: (json['items'] as List? ?? [])
          .map((e) => PurchaseItemModel.fromJson(e))
          .toList(),
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'merchant': merchant?.toJson(),
    'payment': payment.toJson(),
    'totals': totals.toJson(),
    'purchaseDate': purchaseDate.toIso8601String(),
    'dataSource': dataSource.name,
    'items': items.map((e) => e.toJson()).toList(),
    'isDeleted': isDeleted,
  };

  /// =========================
  /// MAPPER → ENTITY
  /// =========================

  Purchase toEntity() {
    return Purchase(
      id: id,
      userId: userId,
      merchant: merchant?.toEntity(),
      payment: payment.toEntity(),
      totals: totals.toEntity(),
      purchaseDate: purchaseDate,
      dataSource: dataSource,
      items: items.map((e) => e.toEntity()).toList(),
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DataSource _mapDataSource(String? value) {
    switch (value) {
      case 'receipt':
        return DataSource.receipt;
      case 'voice':
        return DataSource.voice;
      default:
        return DataSource.manual;
    }
  }

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
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

/// =========================
/// SUB MODELS
/// =========================

class MerchantModel {
  final String name;
  final String normalizedName;
  final String? brand;

  MerchantModel({required this.name, required this.normalizedName, this.brand});

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      name: json['name'],
      normalizedName: json['normalizedName'],
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'normalizedName': normalizedName,
    'brand': brand,
  };

  Merchant toEntity() {
    return Merchant(name: name, normalizedName: normalizedName, brand: brand);
  }
}

class PaymentModel {
  final PaymentMethod method;
  final String? last4;

  const PaymentModel({this.method = PaymentMethod.other, this.last4});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      method: _mapMethod(json['method']),
      last4: json['last4'],
    );
  }

  Map<String, dynamic> toJson() => {'method': method.name, 'last4': last4};

  Payment toEntity() {
    return Payment(method: method, last4: last4);
  }

  static PaymentMethod _mapMethod(String? value) {
    switch (value) {
      case 'card':
        return PaymentMethod.card;
      case 'cash':
        return PaymentMethod.cash;
      default:
        return PaymentMethod.other;
    }
  }
}

class TotalsModel {
  final double amount;
  final String currency;
  final int itemCount;

  TotalsModel({
    required this.amount,
    required this.currency,
    required this.itemCount,
  });

  factory TotalsModel.fromJson(Map<String, dynamic> json) {
    return TotalsModel(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      itemCount: json['itemCount'],
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currency': currency,
    'itemCount': itemCount,
  };

  Totals toEntity() {
    return Totals(amount: amount, currency: currency, itemCount: itemCount);
  }
}
