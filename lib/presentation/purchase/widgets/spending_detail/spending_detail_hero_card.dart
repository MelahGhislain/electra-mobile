import 'package:electra/core/configs/fonts.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:flutter/material.dart';
import 'package:electra/common/helpers/average.dart';

class SpendingDetailHeroCard extends StatelessWidget {
  final Purchase purchase;

  const SpendingDetailHeroCard({super.key, required this.purchase});

  String _formatDateTime(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '${months[d.month - 1]} ${d.day}, ${d.year} • $hour:$minute $period';
  }

  String _avgPrice() {
    if (purchase.items.isEmpty) return '0.00';
    return average(purchase.totals.amount, purchase.totals.itemCount);
  }

  String _paymentLabel() {
    switch (purchase.payment.method) {
      case PaymentMethod.card:
        return 'Card${purchase.payment.last4 != null ? ' ••${purchase.payment.last4}' : ''}';
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  IconData _paymentIcon() {
    switch (purchase.payment.method) {
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.cash:
        return Icons.payments_rounded;
      case PaymentMethod.other:
        return Icons.account_balance_wallet_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categoryKey = purchase.items.isNotEmpty
        ? purchase.items.first.category.normalizedName
        : 'other';
    final meta = CategoryMeta.fromKey(categoryKey);
    final merchantName = purchase.merchant?.name ?? 'Unknown';

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: !isDark
            ? meta.color.withValues(alpha: 0.06)
            : meta.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: !isDark
              ? meta.color.withValues(alpha: 0.15)
              : meta.color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          // Top row: icon + merchant + total
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: meta.color.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(meta.icon, color: meta.color, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        merchantName,
                        style: const TextStyle(
                          fontSize: AppFontSize.xl,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDateTime(purchase.purchaseDate),
                        style: const TextStyle(fontSize: AppFontSize.sm),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: AppFontSize.sm),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${purchase.totals.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: AppFontSize.xl,
                        fontWeight: FontWeight.bold,
                        color: meta.color,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, indent: 16, endIndent: 16),

          // Summary row: items | avg price | payment
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                _SummaryCell(
                  icon: Icons.shopping_bag_outlined,
                  value:
                      '${purchase.totals.itemCount} Item${purchase.totals.itemCount == 1 ? '' : 's'}',
                  label: 'Items',
                  color: meta.color,
                ),
                _VerticalDivider(color: meta.color),
                _SummaryCell(
                  icon: Icons.dialpad,
                  value: _avgPrice(),
                  label: 'Avg price',
                  color: meta.color,
                ),
                _VerticalDivider(color: meta.color),
                _SummaryCell(
                  icon: _paymentIcon(),
                  value: _paymentLabel(),
                  label: 'Payment',
                  color: meta.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryCell({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  final Color color;
  const _VerticalDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: color.withValues(alpha: 0.2));
  }
}
