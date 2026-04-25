import 'package:electra/presentation/purchase/pages/purchase_filter.dart';
import 'package:flutter/material.dart';

class ActiveFilterChips extends StatelessWidget {
  final PurchaseFilter filter;
  final ValueChanged<PurchaseFilter> onFilterChanged;

  const ActiveFilterChips({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!filter.hasActiveFilters) return const SizedBox.shrink();

    final chips = <Widget>[];

    if (filter.sort != PurchaseSortOption.newest) {
      chips.add(_ActiveChip(
        label: filter.sort.label,
        onRemove: () => onFilterChanged(
            filter.copyWith(sort: PurchaseSortOption.newest)),
      ));
    }

    if (filter.category != null) {
      chips.add(_ActiveChip(
        label: filter.category!,
        onRemove: () =>
            onFilterChanged(filter.copyWith(clearCategory: true)),
      ));
    }

    if (filter.merchant != null) {
      chips.add(_ActiveChip(
        label: filter.merchant!,
        onRemove: () =>
            onFilterChanged(filter.copyWith(clearMerchant: true)),
      ));
    }

    if (filter.dateFrom != null) {
      chips.add(_ActiveChip(
        label: 'Date range',
        onRemove: () => onFilterChanged(filter.copyWith(clearDate: true)),
      ));
    }

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => chips[i],
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
