import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:electra/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsTopCategories extends StatelessWidget {
  final List<CategoryBreakdown> categories;

  const InsightsTopCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final symbol = r'$';
    final fmt = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    final displayed = categories.take(5).toList();
    final l = AppLocalizations.of(context);

    if (displayed.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            l.noSpendingDataThisPeriod,
            style: TextStyle(fontSize: AppFontSize.md),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(displayed.length, (i) {
        final cat = displayed[i];
        final meta = CategoryMeta.fromKey(cat.normalizedName);
        final color = meta.color;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              // Icon avatar — matches screenshot's rounded square with icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(meta.icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),

              // Name + progress bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (cat.percent / 100).clamp(0.0, 1.0),
                        backgroundColor: theme.dividerColor,
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Amount + percent + chevron
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fmt.format(cat.amount),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${cat.percent.toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
