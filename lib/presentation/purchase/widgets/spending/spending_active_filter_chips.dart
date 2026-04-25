import 'package:electra/presentation/purchase/pages/purchase_filter.dart';
import 'package:flutter/material.dart';
import 'package:electra/core/configs/theme/app_colors.dart';

class SpendingActiveFilterChips extends StatelessWidget {
  final PurchaseFilter filter;
  final ValueChanged<PurchaseFilter> onFilterChanged;

  const SpendingActiveFilterChips({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!filter.hasActiveFilters) return const SizedBox.shrink();

    final chips = <Widget>[];

    if (filter.sort != PurchaseSortOption.newest) {
      chips.add(
        _Chip(
          label: filter.sort.label,
          onRemove: () =>
              onFilterChanged(filter.copyWith(sort: PurchaseSortOption.newest)),
        ),
      );
    }
    if (filter.category != null) {
      chips.add(
        _Chip(
          label: filter.category!,
          onRemove: () => onFilterChanged(filter.copyWith(clearCategory: true)),
        ),
      );
    }
    if (filter.merchant != null) {
      chips.add(
        _Chip(
          label: filter.merchant!,
          onRemove: () => onFilterChanged(filter.copyWith(clearMerchant: true)),
        ),
      );
    }
    if (filter.dateFrom != null) {
      chips.add(
        _Chip(
          label: 'Date range',
          onRemove: () => onFilterChanged(filter.copyWith(clearDate: true)),
        ),
      );
    }

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => chips[i],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _Chip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 13,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
