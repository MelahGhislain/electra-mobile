import 'package:minata/common/widgets/buttons/main_icon_button.dart';
import 'package:minata/presentation/purchase/blocs/voice/voice_cubit.dart';
import 'package:minata/presentation/purchase/blocs/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Top header with back button + centered voice pill.
class StartTalkingPill extends StatelessWidget {
  const StartTalkingPill({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (context, state) {
        final isListening = state.isListening;

        return SizedBox(
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: MainIconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: theme.iconTheme.color,
                    size: 18,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),

              /// Center Pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: theme.dividerColor, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isListening ? Icons.radio_button_on : Icons.mic_outlined,
                      size: 15,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: 7),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        isListening ? 'Listening…' : 'Start talking!',
                        key: ValueKey(isListening),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
