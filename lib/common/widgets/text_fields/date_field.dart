import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  String _format(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 0.4,
            ),
          ),
        ),

        /// ✅ Field
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.darkBackground,
                  ),
                  const SizedBox(width: 10),

                  Text(_format(value), style: const TextStyle(fontSize: 14)),

                  const Spacer(),

                  /// 🔥 subtle affordance (UX improvement)
                  const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
