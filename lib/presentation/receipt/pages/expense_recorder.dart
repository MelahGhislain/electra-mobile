import 'package:qleo/presentation/receipt/bloc/voice/voice_cubit.dart';
import 'package:qleo/presentation/receipt/widgets/expense_recorder/animated_orb.dart';
import 'package:qleo/presentation/receipt/widgets/expense_recorder/mic_button.dart';
import 'package:qleo/presentation/receipt/widgets/expense_recorder/recorder_heading.dart';
import 'package:qleo/presentation/receipt/widgets/expense_recorder/session_timer.dart';
import 'package:qleo/presentation/receipt/widgets/expense_recorder/start_talking_pill.dart';
import 'package:qleo/presentation/receipt/widgets/expense_recorder/waveform_bar.dart';
import 'package:qleo/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseRecorderScreen extends StatelessWidget {
  const ExpenseRecorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VoiceCubit>(
      // sl<VoiceCubit>() hits the factory — fresh cubit + fresh
      // VoiceStreamService (with a fresh token) every time this
      // screen is opened. Auto-disposed when the screen is popped.
      create: (_) => sl<VoiceCubit>(),
      child: const _RecorderBody(),
    );
  }
}

class _RecorderBody extends StatelessWidget {
  const _RecorderBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ── "Start talking!" pill ──────────────────────────────────
              const StartTalkingPill(),

              const SizedBox(height: 28),

              // ── Hero heading / live transcript ─────────────────────────
              const RecorderHeading(),

              const Spacer(flex: 2),

              // ── Animated orb ───────────────────────────────────────────
              const AnimatedOrb(),

              const Spacer(flex: 2),

              // ── Full-width waveform (fades in when recording) ──────────
              const WaveformBar(),

              const SizedBox(height: 28),

              // ── Circular mic button ────────────────────────────────────
              const MicButton(),

              const SizedBox(height: 14),

              // ── Session timer ──────────────────────────────────────────
              const SessionTimer(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
