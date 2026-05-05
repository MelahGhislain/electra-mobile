import 'package:electra/core/configs/fonts.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:flutter/material.dart';

class SpendingListItem extends StatelessWidget {
  final Purchase purchase;
  final VoidCallback? onTap;

  const SpendingListItem({super.key, required this.purchase, this.onTap});

  String _formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _itemsPreview() {
    if (purchase.items.isEmpty) return 'No items';
    final names = purchase.items.take(2).map((e) => e.name).join(', ');
    final extra = purchase.items.length > 2
        ? ' +${purchase.items.length - 2}'
        : '';
    return '$names$extra';
  }

  @override
  Widget build(BuildContext context) {
    final categoryKey = purchase.items.isNotEmpty
        ? purchase.items.first.category.normalizedName
        : 'other';
    final meta = CategoryMeta.fromKey(categoryKey);
    final merchantName = purchase.merchant?.name ?? 'Unknown';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
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
            splashColor: meta.color.withValues(alpha: 0.06),
            highlightColor: meta.color.withValues(alpha: 0.03),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: meta.color.withValues(alpha: 0.12),
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
                        //  ===== Merchant name =====
                        Text(
                          merchantName,
                          style: const TextStyle(
                            fontSize: AppFontSize.md,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        //  ===== Item name =====
                        Text(
                          _itemsPreview(),
                          style: const TextStyle(fontSize: AppFontSize.sm),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: AppFontSize.sm,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              _formatTime(purchase.purchaseDate),
                              style: TextStyle(fontSize: AppFontSize.sm),
                            ),
                            const SizedBox(width: 8),
                            if (purchase.items.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: meta.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  purchase.items.first.category.name,
                                  style: TextStyle(
                                    fontSize: AppFontSize.sm,
                                    fontWeight: FontWeight.w600,
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

                  // =========== Amount + chevron ===========
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${purchase.totals.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: AppFontSize.lg,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${purchase.totals.itemCount} item${purchase.totals.itemCount == 1 ? '' : 's'}',
                        style: TextStyle(fontSize: AppFontSize.md),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: AppFontSize.xl,
                    color: Theme.of(context).iconTheme.color,
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
