import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Large two-line heading above the orb.
/// Idle  → "What expense should we log today?" with accent on last word
/// Active → shows live transcript text
class RecorderHeading extends StatelessWidget {
  const RecorderHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (context, state) {
        final hasTranscript = state.text.isNotEmpty;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: hasTranscript
              // ── Live transcript ──────────────────────────────────────────
              ? Text(
                  key: const ValueKey('transcript'),
                  state.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                    color: Color(0xFF1A1A2E),
                  ),
                  textAlign: TextAlign.center,
                )
              // ── Idle heading ──────────────────────────────────────────────
              : RichText(
                  key: const ValueKey('idle'),
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      height: 1.15,
                      color: Color(0xFF1A1A2E),
                    ),
                    children: [
                      TextSpan(text: 'What expense\nshould we log '),
                      TextSpan(
                        text: 'today?',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
