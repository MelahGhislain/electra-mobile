import 'package:electra/core/configs/fonts.dart';
import 'package:flutter/material.dart';

class AssistantGreeting extends StatelessWidget {
  const AssistantGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Hello Melah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'What expense should \n we log today?',
          style: TextStyle(
            fontSize: AppFontSize.xxl,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
