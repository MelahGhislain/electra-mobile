// import 'package:electra/core/configs/theme/app_colors.dart';
// import 'package:electra/domain/entities/insights/insights.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class InsightsSpendingOverview extends StatefulWidget {
//   final List<CategoryBreakdown> categories;
//   final double total;

//   const InsightsSpendingOverview({
//     super.key,
//     required this.categories,
//     required this.total,
//   });

//   @override
//   State<InsightsSpendingOverview> createState() =>
//       _InsightsSpendingOverviewState();
// }

// class _InsightsSpendingOverviewState extends State<InsightsSpendingOverview> {
//   bool _showAll = false;

//   // Fixed palette – cycles if there are more categories than colors.
//   static const _palette = [
//     Color(0xFF1E1B4B), // dark navy
//     Color(0xFFEA580C), // orange
//     Color(0xFF7C3AED), // purple
//     Color(0xFF06B6D4), // cyan
//     Color(0xFF22C55E), // green
//     Color(0xFFF59E0B), // amber
//   ];

//   Color _colorFor(int index, CategoryBreakdown cat) {
//     if (cat.color != null) {
//       try {
//         return Color(
//             int.parse(cat.color!.replaceFirst('#', '0xFF')));
//       } catch (_) {}
//     }
//     return _palette[index % _palette.length];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
//     final displayed = _showAll
//         ? widget.categories
//         : widget.categories.take(3).toList();

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.lightSurface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.dividerLight),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Section header ────────────────────────────────────────────
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Spending overview',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.lightText,
//                   letterSpacing: -0.3,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => setState(() => _showAll = !_showAll),
//                 child: Row(
//                   children: [
//                     Text(
//                       'View by categories',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF7C3AED),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Icon(
//                       _showAll
//                           ? Icons.keyboard_arrow_up_rounded
//                           : Icons.keyboard_arrow_down_rounded,
//                       color: const Color(0xFF7C3AED),
//                       size: 16,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // ── Chart + legend ─────────────────────────────────────────────
//           Row(
//             children: [
//               // Donut chart
//               SizedBox(
//                 width: 150,
//                 height: 150,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     PieChart(
//                       PieChartData(
//                         sectionsSpace: 2,
//                         centerSpaceRadius: 44,
//                         sections: List.generate(
//                           widget.categories.length,
//                           (i) {
//                             final cat = widget.categories[i];
//                             return PieChartSectionData(
//                               value: cat.percent,
//                               color: _colorFor(i, cat),
//                               radius: 32,
//                               title: cat.percent >= 10
//                                   ? '${cat.percent.toStringAsFixed(0)}%'
//                                   : '',
//                               titleStyle: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Total',
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: AppColors.lightTextSecondary,
//                           ),
//                         ),
//                         Text(
//                           '\$${(widget.total / 1000).toStringAsFixed(0)},'
//                           '${((widget.total % 1000)).toStringAsFixed(0).padLeft(3, '0')}',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.lightText,
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 16),

//               // Legend list
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: List.generate(displayed.length, (i) {
//                     final cat = displayed[i];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 12,
//                             height: 12,
//                             decoration: BoxDecoration(
//                               color: _colorFor(i, cat),
//                               borderRadius: BorderRadius.circular(3),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               cat.name,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: AppColors.lightText,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 fmt.format(cat.amount),
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.lightText,
//                                 ),
//                               ),
//                               Text(
//                                 '${cat.percent.toStringAsFixed(0)}%',
//                                 style: const TextStyle(
//                                   fontSize: 11,
//                                   color: AppColors.lightTextSecondary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),

//           // ── View all categories ────────────────────────────────────────
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: () {},
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: const [
//                 Text(
//                   'View all categories',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF7C3AED),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(width: 2),
//                 Icon(Icons.chevron_right_rounded,
//                     color: Color(0xFF7C3AED), size: 16),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsSpendingOverview extends StatelessWidget {
  final List<CategoryBreakdown> categories;
  final double total;
  final String currency;

  const InsightsSpendingOverview({
    super.key,
    required this.categories,
    required this.total,
    required this.currency,
  });

  static const _palette = [
    Color(0xFF1E1B4B),
    Color(0xFFEA580C),
    Color(0xFF7C3AED),
    Color(0xFF06B6D4),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
  ];

  Color _colorFor(int index, CategoryBreakdown cat) {
    if (cat.color != null) {
      try {
        return Color(int.parse(cat.color!.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }
    return _palette[index % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final symbol = currency == 'USD' ? r'$' : currency;
    final fmt = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    final displayed = categories.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ── Donut ──────────────────────────────────────────────────
              SizedBox(
                width: 148,
                height: 148,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 42,
                        sections: List.generate(categories.length, (i) {
                          final cat = categories[i];
                          return PieChartSectionData(
                            value: cat.percent,
                            color: _colorFor(i, cat),
                            radius: 32,
                            title: cat.percent >= 10
                                ? '${cat.percent.toStringAsFixed(0)}%'
                                : '',
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _compactAmount(total, symbol),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightText,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ── Legend ─────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(displayed.length, (i) {
                    final cat = displayed[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: _colorFor(i, cat),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              cat.name,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.lightText,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                fmt.format(cat.amount),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightText,
                                ),
                              ),
                              Text(
                                '${cat.percent.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          // ── View all categories ─────────────────────────────────────────
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'View all categories',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7C3AED),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF7C3AED),
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _compactAmount(double value, String symbol) {
    if (value >= 1000) {
      final k = value / 1000;
      final s = k.truncateToDouble() == k
          ? k.toStringAsFixed(0)
          : k.toStringAsFixed(1);
      return '$symbol$s,${(value % 1000).toStringAsFixed(0).padLeft(3, '0')}';
    }
    return '$symbol${value.toStringAsFixed(0)}';
  }
}
