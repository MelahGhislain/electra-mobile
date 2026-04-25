import 'package:flutter/material.dart';

class CategoryMeta {
  final IconData icon;
  final Color color;
  const CategoryMeta(this.icon, this.color);

  static const Map<String, CategoryMeta> _map = {
    'groceries': CategoryMeta(Icons.shopping_basket_rounded, Color(0xFF16A34A)),
    'meat': CategoryMeta(Icons.set_meal_rounded, Color(0xFFDC2626)),
    'poultry': CategoryMeta(Icons.egg_alt_rounded, Color(0xFFF59E0B)),
    'poulry': CategoryMeta(Icons.egg_alt_rounded, Color(0xFFF59E0B)),
    'drinks': CategoryMeta(Icons.local_drink_rounded, Color(0xFF0EA5E9)),
    'bakery': CategoryMeta(Icons.bakery_dining_rounded, Color(0xFFF97316)),
    'transport': CategoryMeta(Icons.directions_car_rounded, Color(0xFF6366F1)),
    'restaurant': CategoryMeta(Icons.restaurant_rounded, Color(0xFFEC4899)),
    'health': CategoryMeta(Icons.favorite_rounded, Color(0xFFEF4444)),
    'pharmacy': CategoryMeta(Icons.local_pharmacy_rounded, Color(0xFF22C55E)),
    'entertainment': CategoryMeta(Icons.movie_rounded, Color(0xFF8B5CF6)),
    'shopping': CategoryMeta(Icons.shopping_bag_rounded, Color(0xFF06B6D4)),
    'food': CategoryMeta(Icons.restaurant_rounded, Color(0xFFEC4899)),
    'other': CategoryMeta(Icons.receipt_long_rounded, Color(0xFF6B7280)),
  };

  static const CategoryMeta _fallback = CategoryMeta(
    Icons.receipt_long_rounded,
    Color(0xFF6B7280),
  );

  static CategoryMeta fromKey(String key) =>
      _map[key.toLowerCase()] ?? _fallback;
}
