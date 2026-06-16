import 'dart:math' as math;
import 'package:minata/common/blocs/currency/currency_formatter_scope.dart';
import 'package:minata/core/configs/fonts.dart';
import 'package:minata/core/utils/category_meta.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Shows spending categories for today (or most recent).
/// Each row: colored dot  •  rounded-square icon  •  label  •  amount  •  %
/// Right side: animated donut chart showing same categories
class TopSpendingTodayCard extends StatefulWidget {
  /// Raw (ungrouped) categories derived from today's purchases
  final List<RawSpendingRow> rows;
  final VoidCallback onViewAll;

  const TopSpendingTodayCard({
    super.key,
    required this.rows,
    required this.onViewAll,
  });

  @override
  State<TopSpendingTodayCard> createState() => _TopSpendingTodayCardState();
}

class _TopSpendingTodayCardState extends State<TopSpendingTodayCard>
    with SingleTickerProviderStateMixin {
  int? _selected;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double get _total => widget.rows.fold(0, (s, r) => s + r.amount);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fmt = CurrencyFormatterScope.of(context);
    if (widget.rows.isEmpty) return const SizedBox.shrink();

    final total = _total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l.mostRecentSpending,
                  style: const TextStyle(
                    fontSize: AppFontSize.lg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onViewAll,
                  child: Text(
                    l.viewAll,
                    style: TextStyle(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Body row: list + donut
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Category list
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.rows.asMap().entries.take(4).map((entry) {
                      final i = entry.key;
                      final row = entry.value;
                      final pct = total > 0
                          ? (row.amount / total * 100).round()
                          : 0;
                      final isSelected = _selected == i;

                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selected = isSelected ? null : i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              // Colored dot
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: row.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Rounded-square icon
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: row.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  row.icon,
                                  size: 16,
                                  color: row.color,
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Label
                              Expanded(
                                child: Text(
                                  row.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppFontSize.sm,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected ? row.color : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 1),
                              // Amount
                              Text(
                                fmt.format(row.amount),
                                style: TextStyle(
                                  fontSize: AppFontSize.md,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? row.color : null,
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Percentage
                              SizedBox(
                                width: 38,
                                child: Text(
                                  '$pct%',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: AppFontSize.sm,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data model for a single spending row ─────────────────────────────────────

class RawSpendingRow {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const RawSpendingRow({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  /// Build from the raw category key → use CategoryMeta for icon/color/label
  factory RawSpendingRow.fromCategoryKey(
    String key,
    double amount,
    AppLocalizations l,
  ) {
    final meta = CategoryMeta.fromKey(key);
    return RawSpendingRow(
      label: meta.localizedLabel(l),
      amount: amount,
      color: meta.color,
      icon: meta.icon,
    );
  }
}
