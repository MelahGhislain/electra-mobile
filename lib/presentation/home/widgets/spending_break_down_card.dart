import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:electra/core/configs/theme/app_colors.dart';

// ─────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────

class SpendingCategory {
  final String label;
  final double amount;
  final Color color;

  const SpendingCategory({
    required this.label,
    required this.amount,
    required this.color,
  });
}

// ─────────────────────────────────────────
// MAIN CARD WIDGET
// ─────────────────────────────────────────

class SpendingBreakdownCard extends StatefulWidget {
  final List<SpendingCategory> categories;
  final String currency;

  const SpendingBreakdownCard({
    super.key,
    required this.categories,
    this.currency = '\$',
  });

  /// Factory — builds from your PurchaseModel/entity list
  /// Pass your list of purchases and it groups by category automatically.
  /// For hardcoded/demo use, call SpendingBreakdownCard.demo()
  factory SpendingBreakdownCard.demo() {
    return SpendingBreakdownCard(
      categories: [
        SpendingCategory(label: 'Groceries', amount: 550, color: const Color(0xFFEF4444)),
        SpendingCategory(label: 'Grocery', amount: 1200, color: const Color(0xFF22C55E)),
        SpendingCategory(label: 'Lunch', amount: 350, color: const Color(0xFFF97316)),
        SpendingCategory(label: 'Uber', amount: 180, color: const Color(0xFF8B5CF6)),
        SpendingCategory(label: 'CNG', amount: 150, color: const Color(0xFF06B6D4)),
        SpendingCategory(label: 'Movie Ticket', amount: 600, color: const Color(0xFFA855F7)),
        SpendingCategory(label: 'Dinner', amount: 400, color: const Color(0xFF92400E)),
      ],
    );
  }

  @override
  State<SpendingBreakdownCard> createState() => _SpendingBreakdownCardState();
}

class _SpendingBreakdownCardState extends State<SpendingBreakdownCard>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _selectedIndex = 0;
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _total =>
      widget.categories.fold(0, (sum, c) => sum + c.amount);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.dividerLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Spending Breakdown',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.lightText,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),

            // Body: legend + chart side by side
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Legend list
                Expanded(
                  child: Column(
                    children: [
                      // Column headers
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Label',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                            Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Category rows
                      ...widget.categories.asMap().entries.map((entry) {
                        final i = entry.key;
                        final cat = entry.value;
                        final isSelected = _selectedIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() =>
                              _selectedIndex = isSelected ? null : i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(bottom: 2),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cat.color.withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: cat.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    cat.label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? cat.color
                                          : AppColors.lightText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${cat.amount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? cat.color
                                        : AppColors.lightText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Donut chart
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    return SizedBox(
                      width: 120,
                      height: 120,
                      child: CustomPaint(
                        painter: _DonutChartPainter(
                          categories: widget.categories,
                          total: _total,
                          progress: _animation.value,
                          selectedIndex: _selectedIndex,
                        ),
                        child: Center(
                          child: _selectedIndex != null
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '\$${widget.categories[_selectedIndex!].amount.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: widget
                                            .categories[_selectedIndex!].color,
                                      ),
                                    ),
                                    Text(
                                      '${(widget.categories[_selectedIndex!].amount / _total * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '\$${_total.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.lightText,
                                      ),
                                    ),
                                    Text(
                                      'total',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// DONUT CHART PAINTER
// ─────────────────────────────────────────

class _DonutChartPainter extends CustomPainter {
  final List<SpendingCategory> categories;
  final double total;
  final double progress;
  final int? selectedIndex;

  _DonutChartPainter({
    required this.categories,
    required this.total,
    required this.progress,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 22.0;
    const gap = 0.03; // gap between segments in radians

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Background ring
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.grey.shade100;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    double startAngle = -math.pi / 2;

    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final fraction = cat.amount / total;
      final sweepAngle = (fraction * 2 * math.pi - gap) * progress;

      if (sweepAngle <= 0) {
        startAngle += fraction * 2 * math.pi * progress;
        continue;
      }

      final isSelected = selectedIndex == i;
      final r = isSelected
          ? radius - strokeWidth / 2 + 4
          : radius - strokeWidth / 2;

      paint.color = isSelected
          ? cat.color
          : (selectedIndex != null
              ? cat.color.withValues(alpha: 0.35)
              : cat.color);
      paint.strokeWidth = isSelected ? strokeWidth + 6 : strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += fraction * 2 * math.pi * progress + gap;
    }
  }

  @override
  bool shouldRepaint(_DonutChartPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.selectedIndex != selectedIndex;
}
