import 'package:flutter/material.dart';

class CategoryMeta {
  final IconData icon;
  final Color color;
  final String label;

  const CategoryMeta(this.icon, this.color, this.label);

  static const Map<String, CategoryMeta> _map = {
    // 🍔 Food
    'food': CategoryMeta(Icons.restaurant_rounded, Color(0xFFEC4899), 'Food'),

    // 🚗 Transport
    'transport': CategoryMeta(
      Icons.directions_car_rounded,
      Color(0xFF6366F1),
      'Transport',
    ),

    // 🏠 Housing / Bills
    'housing': CategoryMeta(Icons.home_rounded, Color(0xFF0EA5E9), 'Housing'),
    'bills': CategoryMeta(Icons.receipt_rounded, Color(0xFFF59E0B), 'Bills'),

    // 🔁 Subscriptions
    'subscriptions': CategoryMeta(
      Icons.repeat_rounded,
      Color(0xFF8B5CF6),
      'Subscriptions',
    ),

    // 🛍️ Shopping
    'shopping': CategoryMeta(
      Icons.shopping_bag_rounded,
      Color(0xFF06B6D4),
      'Shopping',
    ),

    // 💊 Health
    'health': CategoryMeta(Icons.favorite_rounded, Color(0xFFEF4444), 'Health'),

    // 🎬 Entertainment
    'entertainment': CategoryMeta(
      Icons.movie_rounded,
      Color(0xFF7C3AED),
      'Entertainment',
    ),

    // ✈️ Travel
    'travel': CategoryMeta(Icons.flight_rounded, Color(0xFF14B8A6), 'Travel'),

    // 📚 Education
    'education': CategoryMeta(
      Icons.school_rounded,
      Color(0xFF3B82F6),
      'Education',
    ),

    // 👤 Personal
    'personal': CategoryMeta(
      Icons.person_rounded,
      Color(0xFF22C55E),
      'Personal',
    ),

    // 🎁 Gifts
    'gifts': CategoryMeta(
      Icons.card_giftcard_rounded,
      Color(0xFFF43F5E),
      'Gifts',
    ),

    // ❤️ Donations
    'donations': CategoryMeta(
      Icons.volunteer_activism_rounded,
      Color(0xFF10B981),
      'Donations',
    ),

    // ❓ Other
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

  static CategoryMeta fromKey(String key) {
    return _map[key.toLowerCase()] ?? _fallback;
  }

  /// Optional: get all categories (useful for picker)
  static List<CategoryMeta> get all => _map.values.toList();

  /// Optional: get all keys
  static List<String> get keys => _map.keys.toList();
}
