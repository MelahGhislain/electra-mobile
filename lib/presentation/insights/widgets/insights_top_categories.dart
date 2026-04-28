// import 'package:electra/core/configs/theme/app_colors.dart';
// import 'package:electra/domain/entities/insights/insights.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class InsightsTopCategories extends StatelessWidget {
//   final List<CategoryBreakdown> categories;

//   const InsightsTopCategories({super.key, required this.categories});

//   static const _palette = [
//     Color(0xFF1E1B4B),
//     Color(0xFFEA580C),
//     Color(0xFF7C3AED),
//     Color(0xFF06B6D4),
//     Color(0xFF22C55E),
//     Color(0xFFF59E0B),
//   ];

//   Color _colorFor(int index, CategoryBreakdown cat) {
//     if (cat.color != null) {
//       try {
//         return Color(int.parse(cat.color!.replaceFirst('#', '0xFF')));
//       } catch (_) {}
//     }
//     return _palette[index % _palette.length];
//   }

//   IconData _iconFor(String name) {
//     final lower = name.toLowerCase();
//     if (lower.contains('food') || lower.contains('drink')) {
//       return Icons.restaurant_rounded;
//     } else if (lower.contains('shop')) {
//       return Icons.shopping_bag_outlined;
//     } else if (lower.contains('health')) {
//       return Icons.favorite_rounded;
//     } else if (lower.contains('transport') || lower.contains('travel')) {
//       return Icons.directions_car_rounded;
//     } else if (lower.contains('entertain')) {
//       return Icons.movie_outlined;
//     }
//     return Icons.category_outlined;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
//     final displayed = categories.take(3).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Top spending categories',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.lightText,
//                 letterSpacing: -0.3,
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: const Text(
//                 'View all',
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Color(0xFF7C3AED),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),

//         // Category rows
//         ...List.generate(displayed.length, (i) {
//           final cat = displayed[i];
//           final color = _colorFor(i, cat);
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: Row(
//               children: [
//                 // Icon
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: color,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(_iconFor(cat.name), color: Colors.white, size: 20),
//                 ),
//                 const SizedBox(width: 12),

//                 // Name + bar
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         cat.name,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.lightText,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(4),
//                         child: LinearProgressIndicator(
//                           value: cat.percent / 100,
//                           backgroundColor: AppColors.dividerLight,
//                           valueColor: AlwaysStoppedAnimation(color),
//                           minHeight: 4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 // Amount + percent
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       fmt.format(cat.amount),
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.lightText,
//                       ),
//                     ),
//                     Text(
//                       '${cat.percent.toStringAsFixed(0)}%',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: AppColors.lightTextSecondary,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(width: 4),
//                 const Icon(Icons.chevron_right_rounded,
//                     size: 18, color: AppColors.lightTextSecondary),
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsTopCategories extends StatelessWidget {
  final List<CategoryBreakdown> categories;

  const InsightsTopCategories({super.key, required this.categories});

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

  IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('food') || n.contains('drink'))
      return Icons.restaurant_rounded;
    if (n.contains('shop')) return Icons.shopping_bag_outlined;
    if (n.contains('health')) return Icons.favorite_rounded;
    if (n.contains('transport') || n.contains('travel'))
      return Icons.directions_car_rounded;
    if (n.contains('entertain')) return Icons.movie_outlined;
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final displayed = categories.take(3).toList();

    return Column(
      children: List.generate(displayed.length, (i) {
        final cat = displayed[i];
        final color = _colorFor(i, cat);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              // Icon avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_iconFor(cat.name), color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),

              // Name + progress bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: cat.percent / 100,
                        backgroundColor: AppColors.dividerLight,
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Amount + percent
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fmt.format(cat.amount),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightText,
                    ),
                  ),
                  Text(
                    '${cat.percent.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.lightTextSecondary,
              ),
            ],
          ),
        );
      }),
    );
  }
}
