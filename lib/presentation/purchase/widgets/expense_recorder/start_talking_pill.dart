import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pill-shaped CTA at the top of the screen.
/// Shows "Start talking!" when idle, "Listening…" when active.
class StartTalkingPill extends StatelessWidget {
  const StartTalkingPill({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (context, state) {
        final isListening = state.isListening;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.darkSurface.withValues(alpha: 0.6),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isListening ? Icons.radio_button_on : Icons.mic_outlined,
                size: 15,
                color: AppColors.darkSurface,
              ),
              const SizedBox(width: 7),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  isListening ? 'Listening…' : 'Start talking!',
                  key: ValueKey(isListening),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightText,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
