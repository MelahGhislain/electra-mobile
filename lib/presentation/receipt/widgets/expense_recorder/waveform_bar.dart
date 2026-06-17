import 'dart:async';
import 'dart:math' as math;

import 'package:qleo/core/configs/theme/app_colors.dart';
import 'package:qleo/presentation/receipt/bloc/voice/voice_cubit.dart';
import 'package:qleo/presentation/receipt/bloc/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-width waveform visualiser driven by real microphone amplitude.
/// Fades in when recording starts, fades out when idle.
///
/// Does NOT use audio_waveforms — driven directly from the amplitude
/// stream exposed by VoiceCubit, which polls AudioRecorder.getAmplitude()
/// at ~60 fps. No second mic consumer is opened.
class WaveformBar extends StatefulWidget {
  const WaveformBar({super.key});

  @override
  State<WaveformBar> createState() => _WaveformBarState();
}

class _WaveformBarState extends State<WaveformBar> {
  static const int _barCount = 40;
  static const int _historySize = _barCount;

  // Ring buffer — latest amplitude samples, one per bar.
  final List<double> _history = List.generate(_historySize, (_) => 0.0);
  StreamSubscription<double>? _amplitudeSub;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _subscribe() {
    _amplitudeSub?.cancel();
    _amplitudeSub = context.read<VoiceCubit>().amplitudeStream.listen((amp) {
      if (!mounted) return;
      setState(() {
        // Shift left and append the newest sample.
        _history.removeAt(0);
        _history.add(amp);
      });
    });
  }

  @override
  void dispose() {
    _amplitudeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (context, state) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: state.isListening ? 1.0 : 0.0,
          child: SizedBox(
            height: 72,
            child: CustomPaint(
              size: const Size(double.infinity, 72),
              painter: _WaveformPainter(
                samples: List.unmodifiable(_history),
                color: AppColors.primary.withValues(alpha: 0.75),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> samples;
  final Color color;

  _WaveformPainter({required this.samples, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5
      ..style = PaintingStyle.fill;

    final barCount = samples.length;
    const spacing = 4.5;
    final barWidth = (size.width - spacing * (barCount - 1)) / barCount;
    final midY = size.height / 2;
    const minBarHeight = 3.0;

    for (int i = 0; i < barCount; i++) {
      final amplitude = samples[i];
      // Give a subtle breathing motion to silent bars so the waveform
      // never looks completely dead while the mic is open.
      final barHeight = math.max(
        minBarHeight,
        amplitude * (size.height * 0.85),
      );

      final x = i * (barWidth + spacing);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, midY - barHeight / 2, barWidth, barHeight),
        const Radius.circular(2),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.samples != samples;
}
