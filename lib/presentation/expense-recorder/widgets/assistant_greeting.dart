import 'package:electra/core/configs/fonts.dart';
import 'package:electra/presentation/expense-recorder/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/expense-recorder/blocs/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantGreeting extends StatelessWidget {
  const AssistantGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (context, state) {
        // Show greeting only when there's no transcribed text yet
        final bool showGreeting = state.text.isEmpty;

        return Column(
          children: [
            if (showGreeting) ...[
              const Text(
                'Hello Melah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
            ] else ...[
              //  Show transcribed text when available
              Text(
                state.text,
                style: TextStyle(
                  fontSize: AppFontSize.lg,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      },
    );
  }
}
