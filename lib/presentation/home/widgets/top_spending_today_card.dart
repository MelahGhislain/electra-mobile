import 'dart:math' as math;
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/utils/category_meta.dart';
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
                const Text(
                  'Top Spending Today',
                  style: TextStyle(
                    fontSize: AppFontSize.lg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onViewAll,
                  child: Text(
                    'View all',
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
                    children: widget.rows.asMap().entries.map((entry) {
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
                              const SizedBox(width: 8),

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
                              const SizedBox(width: 8),

                              // Label
                              Expanded(
                                child: Text(
                                  row.label,
                                  style: TextStyle(
                                    fontSize: AppFontSize.sm,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected ? row.color : null,
                                  ),
                                ),
                              ),

                              // Amount
                              Text(
                                '\$${row.amount.toStringAsFixed(2)}',
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

                const SizedBox(width: 14),

                // Donut chart
                AnimatedBuilder(
                  animation: _anim,
                  builder: (_, _) => SizedBox(
                    width: 115,
                    height: 115,
                    child: CustomPaint(
                      painter: _DonutPainter(
                        rows: widget.rows,
                        total: total,
                        progress: _anim.value,
                        selected: _selected,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: AppFontSize.sm,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'Total',
                              style: TextStyle(fontSize: AppFontSize.xs),
                            ),
                          ],
                        ),
                      ),
                    ),
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

// ─── Donut painter ────────────────────────────────────────────────────────────

class _DonutPainter extends CustomPainter {
  final List<RawSpendingRow> rows;
  final double total;
  final double progress;
  final int? selected;

  const _DonutPainter({
    required this.rows,
    required this.total,
    required this.progress,
    this.selected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const sw = 22.0;
    const gap = 0.025;

    // Background ring
    canvas.drawCircle(
      center,
      radius - sw / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw
        ..color = const Color.fromARGB(134, 243, 244, 246),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    double start = -math.pi / 2;
    for (int i = 0; i < rows.length; i++) {
      final fraction = rows[i].amount / total;
      final sweep = (fraction * 2 * math.pi - gap) * progress;
      if (sweep <= 0) {
        start += fraction * 2 * math.pi * progress;
        continue;
      }

      final isSel = selected == i;
      paint
        ..color = isSel
            ? rows[i].color
            : (selected != null
                  ? rows[i].color.withValues(alpha: 0.3)
                  : rows[i].color)
        ..strokeWidth = isSel ? sw + 6 : sw;

      final r = isSel ? radius - sw / 2 + 3 : radius - sw / 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        start,
        sweep,
        false,
        paint,
      );

      start += fraction * 2 * math.pi * progress + gap;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.progress != progress || old.selected != selected;
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
  factory RawSpendingRow.fromCategoryKey(String key, double amount) {
    final meta = CategoryMeta.fromKey(key);
    return RawSpendingRow(
      label: meta.label,
      amount: amount,
      color: meta.color,
      icon: meta.icon,
    );
  }
}
