import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:flutter/material.dart';

class PurchaseListItem extends StatelessWidget {
  final Purchase purchase;
  final VoidCallback? onTap;

  const PurchaseListItem({
    super.key,
    required this.purchase,
    this.onTap,
  });

  // Map category → icon + color
  static const Map<String, _CategoryMeta> _categoryMeta = {
    'groceries':    _CategoryMeta(Icons.shopping_basket_rounded, Color(0xFF16A34A)),
    'meat':         _CategoryMeta(Icons.set_meal_rounded,        Color(0xFFDC2626)),
    'poultry':      _CategoryMeta(Icons.egg_alt_rounded,         Color(0xFFF59E0B)),
    'poulry':       _CategoryMeta(Icons.egg_alt_rounded,         Color(0xFFF59E0B)),
    'drinks':       _CategoryMeta(Icons.local_drink_rounded,     Color(0xFF0EA5E9)),
    'bakery':       _CategoryMeta(Icons.bakery_dining_rounded,   Color(0xFFF97316)),
    'transport':    _CategoryMeta(Icons.directions_car_rounded,  Color(0xFF6366F1)),
    'restaurant':   _CategoryMeta(Icons.restaurant_rounded,      Color(0xFFEC4899)),
    'health':       _CategoryMeta(Icons.favorite_rounded,        Color(0xFFEF4444)),
    'entertainment':_CategoryMeta(Icons.movie_rounded,           Color(0xFF8B5CF6)),
    'shopping':     _CategoryMeta(Icons.shopping_bag_rounded,    Color(0xFF06B6D4)),
    'other':        _CategoryMeta(Icons.receipt_long_rounded,    Color(0xFF6B7280)),
  };

  _CategoryMeta _getMeta() {
    if (purchase.items.isEmpty) {
      return const _CategoryMeta(Icons.receipt_long_rounded, Color(0xFF6B7280));
    }
    final key = purchase.items.first.category.normalizedName.toLowerCase();
    return _categoryMeta[key] ??
        const _CategoryMeta(Icons.receipt_long_rounded, Color(0xFF6B7280));
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _itemsPreview() {
    if (purchase.items.isEmpty) return 'No items';
    final names = purchase.items.take(2).map((e) => e.name).join(', ');
    final extra = purchase.items.length > 2 ? ' +${purchase.items.length - 2}' : '';
    return '$names$extra';
  }

  @override
  Widget build(BuildContext context) {
    final meta = _getMeta();
    final merchantName = purchase.merchant?.name ?? 'Unknown';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            splashColor: meta.color.withOpacity(0.06),
            highlightColor: meta.color.withOpacity(0.03),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Category icon
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: meta.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(meta.icon, color: meta.color, size: 22),
                  ),
                  const SizedBox(width: 12),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          merchantName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightText,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _itemsPreview(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 11, color: Colors.grey.shade400),
                            const SizedBox(width: 3),
                            Text(
                              _formatTime(purchase.purchaseDate),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: meta.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                purchase.items.isNotEmpty
                                    ? purchase.items.first.category.name
                                    : 'Other',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: meta.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${purchase.totals.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightText,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${purchase.totals.itemCount} item${purchase.totals.itemCount == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryMeta {
  final IconData icon;
  final Color color;
  const _CategoryMeta(this.icon, this.color);
}
