import 'package:minata/core/configs/fonts.dart';
import 'package:minata/domain/entities/purchase/purchase.dart';
import 'package:minata/core/utils/category_meta.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:minata/common/helpers/average.dart';
import 'package:intl/intl.dart';

class SpendingDetailHeroCard extends StatelessWidget {
  final Purchase purchase;

  const SpendingDetailHeroCard({super.key, required this.purchase});

  String _formatDateTime(BuildContext context, DateTime d) {
    final locale = Localizations.localeOf(context);

    final date = DateFormat.yMMMd(locale.toString()).format(d);
    final time = DateFormat.jm(locale.toString()).format(d);

    return '$date • $time';
  }

  String _avgPrice() {
    if (purchase.items.isEmpty) return '0.00';
    return average(purchase.totals.amount, purchase.totals.itemCount);
  }

  String _paymentLabel(AppLocalizations l) {
    switch (purchase.payment.method) {
      case PaymentMethod.card:
        return '${l.card}${purchase.payment.last4 != null ? ' ••${purchase.payment.last4}' : ''}';
      case PaymentMethod.cash:
        return l.cash;
      case PaymentMethod.other:
        return l.other;
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
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categoryKey = purchase.items.isNotEmpty
        ? purchase.items.first.category.normalizedName
        : 'other';
    final meta = CategoryMeta.fromKey(categoryKey);
    final merchantName = purchase.merchant?.name ?? l.unknown;

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
                        _formatDateTime(context, purchase.purchaseDate),
                        style: const TextStyle(fontSize: AppFontSize.sm),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(l.total, style: TextStyle(fontSize: AppFontSize.sm)),
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
                      '${purchase.totals.itemCount} ${purchase.totals.itemCount == 1 ? l.item : l.items}',
                  label: l.items,
                  color: meta.color,
                ),
                _VerticalDivider(color: meta.color),
                _SummaryCell(
                  icon: Icons.dialpad,
                  value: _avgPrice(),
                  label: l.avgPrice,
                  color: meta.color,
                ),
                _VerticalDivider(color: meta.color),
                _SummaryCell(
                  icon: _paymentIcon(),
                  value: _paymentLabel(l),
                  label: l.payment,
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
