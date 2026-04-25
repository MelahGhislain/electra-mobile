import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-width waveform visualiser shown below the orb.
/// Fades in when recording starts, fades out when idle.
class WaveformBar extends StatelessWidget {
  const WaveformBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (context, state) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: state.isListening ? 1.0 : 0.0,
          child: SizedBox(
            height: 72,
            child: AudioWaveforms(
              recorderController: context.read<VoiceCubit>().recorderController,
              size: const Size(double.infinity, 72),
              waveStyle: WaveStyle(
                waveColor: AppColors.primary.withValues(alpha: 0.75),
                extendWaveform: true,
                showMiddleLine: false,
                spacing: 4.5,
                waveThickness: 2.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
