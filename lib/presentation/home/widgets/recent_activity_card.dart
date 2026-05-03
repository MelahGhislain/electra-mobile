import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/home/utils/home_utils.dart';
import 'package:flutter/material.dart';

class RecentActivityCard extends StatelessWidget {
  final List<RecentActivityItem> items;
  final VoidCallback onViewAll;

  const RecentActivityCard({
    super.key,
    required this.items,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: AppFontSize.lg,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View all',
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
                _ActivityRow(item: item),
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
  const _ActivityRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  style: const TextStyle(
                    fontSize: AppFontSize.lg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      RecentActivityHelper.formatRelativeTime(item.date),
                      style: const TextStyle(fontSize: AppFontSize.sm),
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
            '-\$${item.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: AppFontSize.lg,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppFontSize.sm,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
