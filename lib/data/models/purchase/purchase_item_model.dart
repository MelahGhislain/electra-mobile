// // data/models/item_model.dart

// import 'package:electra/domain/entities/purchase/purchase_item.dart';
// import 'package:equatable/equatable.dart';

// class PurchaseItemModel extends Equatable {
//   final String id;
//   final String name;
//   final String? normalizedName;

//   final int quantity;
//   final double unitPrice;
//   final double totalPrice;

//   final ItemCategoryModel category;
//   final ItemAIModel? ai;

//   final bool isEdited;
//   final bool isDeleted;

//   const PurchaseItemModel({
//     required this.id,
//     required this.name,
//     this.normalizedName,
//     required this.quantity,
//     required this.unitPrice,
//     required this.totalPrice,
//     required this.category,
//     this.ai,
//     this.isEdited = false,
//     this.isDeleted = false,
//   });

//   /// =========================
//   /// JSON
//   /// =========================

//   factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
//     // ✅ ai: {} is not null but has no fields — treat empty map as null
//       final aiRaw = json['ai'];
//       final ai = (aiRaw != null && (aiRaw as Map).isNotEmpty)
//           ? ItemAIModel.fromJson(aiRaw as Map<String, dynamic>)
//           : null;

//     return PurchaseItemModel(
//       id: json['id'] ?? json['_id'],
//       name: json['name'],
//       normalizedName: json['normalizedName'],
//       quantity: json['quantity'],
//       unitPrice: (json['unitPrice'] as num).toDouble(),
//       totalPrice: (json['totalPrice'] as num).toDouble(),
//       category: json['category'] != null
//           ? ItemCategoryModel.fromJson(json['category'])
//           : const ItemCategoryModel(name: 'Unknown', normalizedName: 'unknown'),
//       // ai: json['ai'] != null ? ItemAIModel.fromJson(json['ai']) : null,
//       ai: ai,
//       isEdited: json['isEdited'] ?? false,
//       isDeleted: json['isDeleted'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'normalizedName': normalizedName,
//     'quantity': quantity,
//     'unitPrice': unitPrice,
//     'totalPrice': totalPrice,
//     'category': category.toJson(),
//     'ai': ai?.toJson(),
//     'isEdited': isEdited,
//     'isDeleted': isDeleted,
//   };

//   /// =========================
//   /// MAPPER → ENTITY
//   /// =========================

//   PurchaseItem toEntity() {
//     return PurchaseItem(
//       id: id,
//       name: name,
//       normalizedName: normalizedName,
//       quantity: quantity,
//       unitPrice: unitPrice,
//       totalPrice: totalPrice,
//       category: category.toEntity(),
//       ai: ai?.toEntity(),
//       isEdited: isEdited,
//       isDeleted: isDeleted,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     id,
//     name,
//     normalizedName,
//     quantity,
//     unitPrice,
//     totalPrice,
//     category,
//     ai,
//     isEdited,
//     isDeleted,
//   ];
// }

// /// =========================
// /// CATEGORY MODEL
// /// =========================

// class ItemCategoryModel extends Equatable {
//   final String name;
//   final String normalizedName;
//   final String? color;

//   const ItemCategoryModel({
//     required this.name,
//     required this.normalizedName,
//     this.color,
//   });

//   factory ItemCategoryModel.fromJson(Map<String, dynamic> json) {
//     return ItemCategoryModel(
//       name: json['name'] ?? 'Unknown',
//       normalizedName: json['normalizedName'] ?? 'unknown',
//       color: json['color'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'normalizedName': normalizedName,
//     'color': color,
//   };

//   ItemCategory toEntity() {
//     return ItemCategory(
//       name: name,
//       normalizedName: normalizedName,
//       color: color,
//     );
//   }

//   @override
//   List<Object?> get props => [name, normalizedName, color];
// }

// /// =========================
// /// ITEM AI MODEL
// /// =========================

// class ItemAIModel extends Equatable {
//   final double? confidenceScore;
//   final bool inferredCategory;
//   final String? sourceText;

//   const ItemAIModel({
//     this.confidenceScore,
//     this.inferredCategory = false,
//     this.sourceText,
//   });

//   factory ItemAIModel.fromJson(Map<String, dynamic> json) {
//     return ItemAIModel(
//       confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
//       inferredCategory: json['inferredCategory'] ?? false,
//       sourceText: json['sourceText'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'confidenceScore': confidenceScore,
//     'inferredCategory': inferredCategory,
//     'sourceText': sourceText,
//   };

//   ItemAI toEntity() {
//     return ItemAI(
//       confidenceScore: confidenceScore,
//       inferredCategory: inferredCategory,
//       sourceText: sourceText,
//     );
//   }

//   @override
//   List<Object?> get props => [confidenceScore, inferredCategory, sourceText];
// }

import 'package:electra/domain/entities/purchase/purchase_item.dart';
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

  const PurchaseItemModel({
    required this.id,
    required this.name,
    this.normalizedName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.category,
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
