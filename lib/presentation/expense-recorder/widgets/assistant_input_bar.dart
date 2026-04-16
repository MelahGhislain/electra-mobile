import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:electra/common/widgets/buttons/animated_icon_button.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/expense-recorder/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/expense-recorder/blocs/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantInputBar extends StatelessWidget {
  const AssistantInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          // color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.dividerDark.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: BlocBuilder<VoiceCubit, VoiceState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state.isListening
                        ? AudioWaveforms(
                            key: const ValueKey('wave'),
                            recorderController: context
                                .read<VoiceCubit>()
                                .recorderController,
                            size: const Size(double.infinity, 40),
                            waveStyle: WaveStyle(
                              waveColor: AppColors.primary,
                              extendWaveform: true,
                              showMiddleLine: false,
                              spacing: 6,
                              waveThickness: 3,
                            ),
                          )
                        : const Text('Ask anything...', style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),

            BlocBuilder<VoiceCubit, VoiceState>(
              builder: (context, state) {
                return AnimatedIconButton(
                  icon: Icon(
                    state.isListening ? Icons.stop : Icons.graphic_eq,
                    color: AppColors.primary,
                    size: 26,
                  ),
                  onTap: () {
                    final cubit = context.read<VoiceCubit>();

                    if (state.isListening) {
                      cubit.stopListening();
                    } else {
                      cubit.startListening();
                    }
                  },
                );
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
