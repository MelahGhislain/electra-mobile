import 'package:equatable/equatable.dart';

class ItemCategory extends Equatable {
  final String name;
  final String normalizedName;
  final String? color;

  const ItemCategory({
    required this.name,
    required this.normalizedName,
    this.color,
  });

  @override
  List<Object?> get props => [name, normalizedName, color];
}

class ItemAI extends Equatable {
  final double? confidenceScore;
  final bool inferredCategory;
  final String? sourceText;

  const ItemAI({
    this.confidenceScore,
    this.inferredCategory = false,
    this.sourceText,
  });

  @override
  List<Object?> get props => [confidenceScore, inferredCategory, sourceText];
}

class PurchaseItem extends Equatable {
  final String id;
  final String name;
  final String? normalizedName;

  final int quantity;
  final double unitPrice;
  final double totalPrice;

  final ItemCategory category;
  final ItemAI? ai;

  final bool isEdited;
  final bool isDeleted;

  const PurchaseItem({
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
