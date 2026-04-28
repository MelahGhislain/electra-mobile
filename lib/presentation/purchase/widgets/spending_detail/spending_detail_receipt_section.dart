// import 'package:electra/core/configs/theme/app_colors.dart';
// import 'package:electra/domain/entities/purchase/purchase.dart';
// import 'package:flutter/material.dart';

// class SpendingDetailReceiptSection extends StatelessWidget {
//   final Receipt? receipt;
//   final VoidCallback? onView;

//   const SpendingDetailReceiptSection({super.key, this.receipt, this.onView});

//   String _formatUploadDate(DateTime? d) {
//     if (d == null) return '';
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return '${months[d.month - 1]} ${d.day}, ${d.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasReceipt = receipt != null && receipt!.imageUrl != null;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.lightSurface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.dividerLight),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.receipt_outlined,
//               size: 22,
//               color: AppColors.lightTextSecondary,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   hasReceipt ? (receipt!.name ?? 'Receipt') : 'No receipt',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.lightText,
//                   ),
//                 ),
//                 if (receipt?.uploadedAt != null) ...[
//                   const SizedBox(height: 2),
//                   Text(
//                     'Uploaded ${_formatUploadDate(receipt!.uploadedAt)} • Processed',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.lightTextSecondary,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           if (hasReceipt)
//             GestureDetector(
//               onTap: onView,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Icon(
//                       Icons.visibility_outlined,
//                       size: 14,
//                       color: AppColors.primary,
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       'View',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:flutter/material.dart';

class SpendingDetailReceiptSection extends StatelessWidget {
  final Receipt? receipt;
  final VoidCallback? onView;

  const SpendingDetailReceiptSection({super.key, this.receipt, this.onView});

  String _formatUploadDate(DateTime? d) {
    if (d == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Uploaded ${months[d.month - 1]} ${d.day}, ${d.year} • Processed';
  }

  bool get _hasReceipt => receipt != null && receipt!.imageUrl != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF0F3)),
      ),
      child: _hasReceipt
          ? _ReceiptPresent(receipt: receipt!, onView: onView)
          : _ReceiptAbsent(),
    );
  }
}

class _ReceiptPresent extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback? onView;

  const _ReceiptPresent({required this.receipt, this.onView});

  String _formatUploadDate(DateTime? d) {
    if (d == null) return 'Processed';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Uploaded ${months[d.month - 1]} ${d.day}, ${d.year} • Processed';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.receipt_outlined,
              size: 22,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.name ?? 'Receipt',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatUploadDate(receipt.uploadedAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onView,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.visibility_outlined,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'View',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptAbsent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 22,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'No receipt added',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
