import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          // const BackButton()

          // Try Premium Button
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   decoration: BoxDecoration(
          //     gradient: const LinearGradient(
          //       colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          //     ),
          //     borderRadius: BorderRadius.circular(999),
          //   ),
          //   child: const Row(
          //     children: [
          //       Text(
          //         'Try Premium',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600,
          //           fontSize: 15,
          //         ),
          //       ),
          //       SizedBox(width: 4),
          //       Icon(Icons.add, color: Colors.white, size: 18),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
