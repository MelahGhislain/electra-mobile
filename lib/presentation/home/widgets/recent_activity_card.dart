import 'package:minata/common/blocs/currency/currency_formatter_scope.dart';
import 'package:minata/core/configs/fonts.dart';
import 'package:minata/core/router/route_names.dart';
import 'package:minata/domain/entities/purchase/purchase.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:minata/presentation/home/utils/home_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecentActivityCard extends StatelessWidget {
  final List<RecentActivityItem> items;
  final List<Purchase> purchases;
  final VoidCallback onViewAll;

  const RecentActivityCard({
    super.key,
    required this.items,
    required this.purchases,
    required this.onViewAll,
  });

  Purchase getPurchase(RecentActivityItem item) {
    return RecentActivityHelper.getPurchaseFromItem(purchases, item);
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.recentActivity,
                style: TextStyle(
                  fontSize: AppFontSize.lg,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  l.viewAll,
                  style: TextStyle(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items — no outer card, just rows separated by dividers
          ...items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final isLast = i == items.length - 1;

            return Column(
              children: [
                _ActivityRow(item: item, purchase: getPurchase(item)),
                if (!isLast) Divider(height: 1, thickness: 1, indent: 72),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final RecentActivityItem item;
  final Purchase purchase;
  const _ActivityRow({required this.item, required this.purchase});

  void _navigateToDetail(BuildContext context, Purchase purchase) {
    context.pushNamed(
      RouteNames.purchaseDetail,
      pathParameters: {'purchaseId': purchase.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fmt = CurrencyFormatterScope.of(context);

    return InkWell(
      onTap: () => _navigateToDetail(context, purchase),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Logo / icon circle
            _MerchantLogo(
              title: item.title,
              color: item.categoryColor,
              icon: item.categoryIcon,
            ),
            const SizedBox(width: 12),

            // Title + time + category chip
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        RecentActivityHelper.formatRelativeTime(item.date, l),
                        style: const TextStyle(fontSize: AppFontSize.xs),
                      ),
                      const SizedBox(width: 6),
                      _CategoryChip(
                        label: item.categoryLabel,
                        color: item.categoryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Amount + chevron
            Text(
              fmt.format(item.amount),
              style: const TextStyle(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a colored rounded-square with the category icon.
/// In the target design each merchant has a distinct colored logo-style icon.
class _MerchantLogo extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _MerchantLogo({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;

  const _CategoryChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: AppFontSize.xxs, color: color),
      ),
    );
  }
}
