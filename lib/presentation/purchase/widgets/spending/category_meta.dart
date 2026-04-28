import 'package:flutter/material.dart';

class CategoryMeta {
  final IconData icon;
  final Color color;
  final String label;
  const CategoryMeta(this.icon, this.color, this.label);

  static const Map<String, CategoryMeta> _map = {
    'groceries': CategoryMeta(
      Icons.shopping_basket_rounded,
      Color(0xFF16A34A),
      'Groceries',
    ),
    'meat': CategoryMeta(Icons.set_meal_rounded, Color(0xFFDC2626), 'Meat'),
    'poultry': CategoryMeta(
      Icons.egg_alt_rounded,
      Color(0xFFF59E0B),
      'Poultry',
    ),
    'poulry': CategoryMeta(Icons.egg_alt_rounded, Color(0xFFF59E0B), 'Poultry'),
    'drinks': CategoryMeta(
      Icons.local_drink_rounded,
      Color(0xFF0EA5E9),
      'Drinks',
    ),
    'bakery': CategoryMeta(
      Icons.bakery_dining_rounded,
      Color(0xFFF97316),
      'Bakery',
    ),
    'transport': CategoryMeta(
      Icons.directions_car_rounded,
      Color(0xFF6366F1),
      'Transport',
    ),
    'restaurant': CategoryMeta(
      Icons.restaurant_rounded,
      Color(0xFFEC4899),
      'Restaurant',
    ),
    'health': CategoryMeta(Icons.favorite_rounded, Color(0xFFEF4444), 'Health'),
    'pharmacy': CategoryMeta(
      Icons.local_pharmacy_rounded,
      Color(0xFF22C55E),
      'Pharmacy',
    ),
    'entertainment': CategoryMeta(
      Icons.movie_rounded,
      Color(0xFF8B5CF6),
      'Entertainment',
    ),
    'shopping': CategoryMeta(
      Icons.shopping_bag_rounded,
      Color(0xFF06B6D4),
      'Shopping',
    ),
    'food': CategoryMeta(Icons.restaurant_rounded, Color(0xFFEC4899), 'Food'),
    'other': CategoryMeta(
      Icons.receipt_long_rounded,
      Color(0xFF6B7280),
      'Other',
    ),
  };

  static const CategoryMeta _fallback = CategoryMeta(
    Icons.receipt_long_rounded,
    Color(0xFF6B7280),
    'Other',
  );

  static CategoryMeta fromKey(String key) =>
      _map[key.toLowerCase()] ?? _fallback;
}
