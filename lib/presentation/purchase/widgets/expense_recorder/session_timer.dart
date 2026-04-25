import 'dart:async';
import 'package:electra/presentation/purchase/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// MM:SS timer that counts up while the session is active.
/// Resets to 00:00 when recording stops.
class SessionTimer extends StatefulWidget {
  const SessionTimer({super.key});

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? _timer;
  int _seconds = 0;
  bool _wasListening = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _seconds = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  void _stop() {
    _timer?.cancel();
    if (mounted) setState(() => _seconds = 0);
  }

  String get _formatted {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoiceCubit, VoiceState>(
      listenWhen: (prev, curr) => prev.isListening != curr.isListening,
      listener: (context, state) {
        if (state.isListening && !_wasListening) {
          _start();
        } else if (!state.isListening && _wasListening) {
          _stop();
        }
        _wasListening = state.isListening;
      },
      child: Text(
        _formatted,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1A2E).withValues(alpha: 0.45),
          letterSpacing: 0.5,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
