import 'package:minata/domain/entities/purchase/purchase_item.dart';
import 'package:equatable/equatable.dart';

class PurchaseItemModel extends Equatable {
  final String id;
  final String name;
  final String? normalizedName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final ItemCategoryModel category;
  final ItemAIModel? ai;
  final bool isEdited;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  const PurchaseItemModel({
    required this.id,
    required this.name,
    this.normalizedName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.ai,
    this.isEdited = false,
    this.isDeleted = false,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    // ✅ ai: null OR {} both treated as null
    final aiRaw = json['ai'];
    final ai = (aiRaw != null && aiRaw is Map && aiRaw.isNotEmpty)
        ? ItemAIModel.fromJson(aiRaw as Map<String, dynamic>)
        : null;

    return PurchaseItemModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      normalizedName: json['normalizedName']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      category:
          (json['category'] != null && (json['category'] as Map).isNotEmpty)
          ? ItemCategoryModel.fromJson(json['category'])
          : const ItemCategoryModel(name: 'Unknown', normalizedName: 'unknown'),
      ai: ai,
      isEdited: json['isEdited'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      updatedAt: json['updatedAt']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'normalizedName': normalizedName,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
    'category': category.toJson(),
    'ai': ai?.toJson(),
    'isEdited': isEdited,
    'isDeleted': isDeleted,
    'updatedAt': updatedAt,
    'createdAt': createdAt,
  };

  PurchaseItem toEntity() => PurchaseItem(
    id: id,
    name: name,
    normalizedName: normalizedName,
    quantity: quantity,
    unitPrice: unitPrice,
    totalPrice: totalPrice,
    category: category.toEntity(),
    ai: ai?.toEntity(),
    isEdited: isEdited,
    isDeleted: isDeleted,
    updatedAt: updatedAt,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    normalizedName,
    quantity,
    unitPrice,
    totalPrice,
    category,
    ai,
    isEdited,
    isDeleted,
    updatedAt,
    createdAt,
  ];
}

class ItemCategoryModel extends Equatable {
  final String name;
  final String normalizedName;
  final String? color;

  const ItemCategoryModel({
    required this.name,
    required this.normalizedName,
    this.color,
  });

  factory ItemCategoryModel.fromJson(Map<String, dynamic> json) =>
      ItemCategoryModel(
        name: json['name']?.toString() ?? 'Unknown',
        normalizedName: json['normalizedName']?.toString() ?? 'unknown',
        color: json['color']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'normalizedName': normalizedName,
    'color': color,
  };

  ItemCategory toEntity() =>
      ItemCategory(name: name, normalizedName: normalizedName, color: color);

  @override
  List<Object?> get props => [name, normalizedName, color];
}

class ItemAIModel extends Equatable {
  final double? confidenceScore;
  final bool inferredCategory;
  final String? sourceText;

  const ItemAIModel({
    this.confidenceScore,
    this.inferredCategory = false,
    this.sourceText,
  });

  factory ItemAIModel.fromJson(Map<String, dynamic> json) => ItemAIModel(
    confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
    inferredCategory: json['inferredCategory'] ?? false,
    sourceText: json['sourceText']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'confidenceScore': confidenceScore,
    'inferredCategory': inferredCategory,
    'sourceText': sourceText,
  };

  ItemAI toEntity() => ItemAI(
    confidenceScore: confidenceScore,
    inferredCategory: inferredCategory,
    sourceText: sourceText,
  );

  @override
  List<Object?> get props => [confidenceScore, inferredCategory, sourceText];
}
