import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/expense-recorder/widgets/action_button.dart';
import 'package:electra/presentation/expense-recorder/widgets/assistant_greeting.dart';
import 'package:electra/presentation/expense-recorder/widgets/assistant_input_bar.dart';
import 'package:electra/presentation/expense-recorder/widgets/animated_orb.dart';
import 'package:electra/presentation/expense-recorder/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class ExpenseRecorderScreen extends StatelessWidget {
  const ExpenseRecorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(),

            const Spacer(flex: 4),

            // AI Orb
            AnimatedOrb(),

            const Spacer(flex: 2),

            // Greeting Text
            const AssistantGreeting(),

            const Spacer(flex: 2),

            // Bottom Input Bar
            ActionButton(icon: Icons.center_focus_weak, label: 'Snap'),
            const SizedBox(height: 24),
            const AssistantInputBar(),
          ],
        ),
      ),
    );
  }
}