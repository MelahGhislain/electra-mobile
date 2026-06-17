import 'package:qleo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoryMeta {
  final IconData icon;
  final Color color;
  final String label; // normalized English key — used as fallback

  const CategoryMeta(this.icon, this.color, this.label);

  static const Map<String, CategoryMeta> _map = {
    // 🍔 Food
    'food': CategoryMeta(Icons.restaurant_rounded, Color(0xFFEC4899), 'food'),

    // 🚗 Transport
    'transport': CategoryMeta(
      Icons.directions_car_rounded,
      Color(0xFF6366F1),
      'transport',
    ),

    // 🏠 Housing / Bills
    'housing': CategoryMeta(Icons.home_rounded, Color(0xFF0EA5E9), 'housing'),
    'bills': CategoryMeta(Icons.receipt_rounded, Color(0xFFF59E0B), 'bills'),

    // 🔁 Subscriptions
    'subscriptions': CategoryMeta(
      Icons.repeat_rounded,
      Color(0xFF8B5CF6),
      'subscriptions',
    ),

    // 🛍️ Shopping
    'shopping': CategoryMeta(
      Icons.shopping_bag_rounded,
      Color(0xFF06B6D4),
      'shopping',
    ),

    // 💊 Health
    'health': CategoryMeta(Icons.favorite_rounded, Color(0xFFEF4444), 'health'),

    // 🎬 Entertainment
    'entertainment': CategoryMeta(
      Icons.movie_rounded,
      Color(0xFF7C3AED),
      'entertainment',
    ),

    // ✈️ Travel
    'travel': CategoryMeta(Icons.flight_rounded, Color(0xFF14B8A6), 'travel'),

    // 📚 Education
    'education': CategoryMeta(
      Icons.school_rounded,
      Color(0xFF3B82F6),
      'education',
    ),

    // 👤 Personal
    'personal': CategoryMeta(
      Icons.person_rounded,
      Color(0xFF22C55E),
      'personal',
    ),

    // 🎁 Gifts
    'gifts': CategoryMeta(
      Icons.card_giftcard_rounded,
      Color(0xFFF43F5E),
      'gifts',
    ),

    // ❤️ Donations
    'donations': CategoryMeta(
      Icons.volunteer_activism_rounded,
      Color(0xFF10B981),
      'donations',
    ),

    // ❓ Other
    'other': CategoryMeta(
      Icons.receipt_long_rounded,
      Color(0xFF6B7280),
      'other',
    ),
  };

  static const CategoryMeta _fallback = CategoryMeta(
    Icons.receipt_long_rounded,
    Color(0xFF6B7280),
    'other',
  );

  static CategoryMeta fromKey(String key) =>
      _map[key.toLowerCase()] ?? _fallback;

  /// All categories — useful for pickers.
  static List<CategoryMeta> get all => _map.values.toList();

  /// All normalized keys.
  static List<String> get keys => _map.keys.toList();

  static String localizedKeyLabel(String key, AppLocalizations l) {
    switch (key) {
      case 'food':
        return l.categoryFood;
      case 'transport':
        return l.categoryTransport;
      case 'housing':
        return l.categoryHousing;
      case 'bills':
        return l.categoryBills;
      case 'subscriptions':
        return l.categorySubscriptions;
      case 'shopping':
        return l.categoryShopping;
      case 'health':
        return l.categoryHealth;
      case 'entertainment':
        return l.categoryEntertainment;
      case 'travel':
        return l.categoryTravel;
      case 'education':
        return l.categoryEducation;
      case 'personal':
        return l.categoryPersonal;
      case 'gifts':
        return l.categoryGifts;
      case 'donations':
        return l.categoryDonations;
      default:
        return l.categoryOther;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOCALIZATION EXTENSION
// Usage: meta.localizedLabel(AppLocalizations.of(context))
// ─────────────────────────────────────────────────────────────────────────────

extension CategoryMetaL10n on CategoryMeta {
  String localizedLabel(AppLocalizations l) {
    switch (label) {
      case 'food':
        return l.categoryFood;
      case 'transport':
        return l.categoryTransport;
      case 'housing':
        return l.categoryHousing;
      case 'bills':
        return l.categoryBills;
      case 'subscriptions':
        return l.categorySubscriptions;
      case 'shopping':
        return l.categoryShopping;
      case 'health':
        return l.categoryHealth;
      case 'entertainment':
        return l.categoryEntertainment;
      case 'travel':
        return l.categoryTravel;
      case 'education':
        return l.categoryEducation;
      case 'personal':
        return l.categoryPersonal;
      case 'gifts':
        return l.categoryGifts;
      case 'donations':
        return l.categoryDonations;
      default:
        return l.categoryOther;
    }
  }
}
