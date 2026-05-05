import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SpendingEmptyState extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback? onClearFilters;

  const SpendingEmptyState({
    super.key,
    this.isFiltered = false,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isFiltered
                    ? Icons.filter_list_off_rounded
                    : Icons.receipt_long_rounded,
                size: 32,
                color: AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isFiltered ? 'No results found' : 'No purchases yet',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              isFiltered
                  ? 'Try adjusting your filters or search query'
                  : 'Your purchase history will appear here',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightTextSecondary,
              ),
            ),
            if (isFiltered && onClearFilters != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onClearFilters,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.darkBackground),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(
                    color: AppColors.darkBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
