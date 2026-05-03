import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/domain/entities/purchase/purchase_item.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/item_form_sheet.dart';
import 'package:flutter/material.dart';

class SpendingDetailItemRow extends StatelessWidget {
  final PurchaseItem item;
  final double purchaseTotal;
  final bool isLast;
  final void Function(PurchaseItem)? onEdit;
  final void Function(String)? onDelete;
  final String average;
  final bool? isMutating;

  const SpendingDetailItemRow({
    super.key,
    required this.item,
    required this.purchaseTotal,
    required this.average,
    this.isLast = false,
    this.onEdit,
    this.onDelete,
    this.isMutating = false,
  });

  double get _percentOfTotal =>
      purchaseTotal > 0 ? (item.totalPrice / purchaseTotal) * 100 : 0;

  String get label {
    final cmp = item.totalPrice.compareTo(double.tryParse(average) ?? 0);
    if (cmp < 0) return '↓ Below';
    if (cmp > 0) return '↑ Above';
    return 'At';
  }

  String _itemInsights() {
    return '↑ +12% vs last purchase • $label average price';
  }

  void _showItemOptions(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: item.name,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Icon(
              Icons.edit_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
            title: const Text(
              'Edit item',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              onEdit?.call(item);
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Icon(
              Icons.delete_outline_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 20,
            ),
            title: Text(
              'Delete item',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              final confirmed = await showDeleteItemConfirmation(
                context,
                item: item,
              );
              if (confirmed == true) onDelete?.call(item.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final meta = CategoryMeta.fromKey(item.category.normalizedName);
    final pct = _percentOfTotal;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: icon + name + 3-dots + price ───────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: meta.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(meta.icon, color: meta.color, size: 22),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: AppFontSize.md,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: meta.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.category.name,
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w600,
                            color: meta.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.quantity} × \$${item.unitPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: AppFontSize.xs),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${pct.toStringAsFixed(1)}% of total',
                      style: const TextStyle(fontSize: AppFontSize.sm),
                    ),
                  ],
                ),

                const SizedBox(width: 2),

                GestureDetector(
                  onTap: () => _showItemOptions(context),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4, top: 2),
                    child: Icon(Icons.more_vert_rounded, size: AppFontSize.lg),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Insights row ─────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: theme.listTileTheme.iconColor?.withValues(alpha: 0.09),
                border: Border.all(color: theme.dividerColor, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    _itemInsights(),
                    style: const TextStyle(fontSize: AppFontSize.xs),
                  ),
                  const SizedBox(width: 14),
                  if (item.isEdited) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Edited',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
