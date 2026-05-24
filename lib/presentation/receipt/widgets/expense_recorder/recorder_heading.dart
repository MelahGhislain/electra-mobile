// import 'package:minata/core/configs/fonts.dart';
// import 'package:minata/presentation/receipt/bloc/voice/voice_cubit.dart';
// import 'package:minata/presentation/receipt/bloc/voice/voice_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// Large two-line heading above the orb.
// /// Idle  → "What expense should we log today?" with accent on last word
// /// Active → shows live transcript text
// class RecorderHeading extends StatelessWidget {
//   const RecorderHeading({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return BlocBuilder<VoiceCubit, VoiceState>(
//       builder: (context, state) {
//         final hasTranscript = state.text.isNotEmpty;

//         return AnimatedSwitcher(
//           duration: const Duration(milliseconds: 350),
//           switchInCurve: Curves.easeOut,
//           switchOutCurve: Curves.easeIn,
//           transitionBuilder: (child, animation) => FadeTransition(
//             opacity: animation,
//             child: SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(0, 0.06),
//                 end: Offset.zero,
//               ).animate(animation),
//               child: child,
//             ),
//           ),
//           child: hasTranscript
//               // ── Live transcript ──────────────────────────────────────────
//               ? Text(
//                   key: const ValueKey('transcript'),
//                   state.text,
//                   style: const TextStyle(
//                     fontSize: AppFontSize.xxl,
//                     fontWeight: FontWeight.w500,
//                     height: 1.35,
//                   ),
//                   textAlign: TextAlign.center,
//                 )
//               // ── Idle heading ──────────────────────────────────────────────
//               : RichText(
//                   key: const ValueKey('idle'),
//                   textAlign: TextAlign.center,
//                   text: TextSpan(
//                     style: TextStyle(
//                       fontSize: AppFontSize.xxxl,
//                       fontWeight: FontWeight.bold,
//                       color: theme.textTheme.bodyMedium?.color,
//                       height: 1.15,
//                     ),
//                     children: [
//                       TextSpan(text: 'What expense\nshould we log '),
//                       TextSpan(
//                         text: 'today?',
//                         style: TextStyle(color: theme.colorScheme.primary),
//                       ),
//                     ],
//                   ),
//                 ),
//         );
//       },
//     );
//   }
// }

import 'package:minata/core/configs/fonts.dart';
import 'package:minata/presentation/receipt/bloc/voice/voice_cubit.dart';
import 'package:minata/presentation/receipt/bloc/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Large heading above the orb. Changes based on VoiceStatus:
///
///  idle       → "What expense should we log today?"
///  listening  → live transcript (or idle heading if transcript is empty)
///  processing → "Analyzing your expenses…"
///  done       → "Saved! Great job."
///  error      → error message
class RecorderHeading extends StatelessWidget {
  const RecorderHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (context, state) {
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
          child: _buildContent(context, theme, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, VoiceState state) {
    switch (state.status) {
      // ── Live transcript while listening ─────────────────────────────────
      case VoiceStatus.listening:
        if (state.transcript.isNotEmpty) {
          return Text(
            key: const ValueKey('transcript'),
            state.transcript,
            style: const TextStyle(
              fontSize: AppFontSize.xxl,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          );
        }
        // No transcript yet — show idle heading
        return _idleHeading(theme);

      // ── LLM processing ───────────────────────────────────────────────────
      case VoiceStatus.processing:
        return Column(
          key: const ValueKey('processing'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Analyzing your\nexpenses…',
              style: TextStyle(
                fontSize: AppFontSize.xxxl,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium?.color,
                height: 1.15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        );

      // ── Done ─────────────────────────────────────────────────────────────
      case VoiceStatus.done:
        return Column(
          key: const ValueKey('done'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.primary,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              'Expenses saved!',
              style: TextStyle(
                fontSize: AppFontSize.xxxl,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                height: 1.15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );

      // ── Error ─────────────────────────────────────────────────────────────
      case VoiceStatus.error:
        return Column(
          key: const ValueKey('error'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: theme.colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              state.error ?? 'Something went wrong',
              style: TextStyle(
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.error,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );

      // ── Idle ─────────────────────────────────────────────────────────────
      case VoiceStatus.idle:
      default:
        return _idleHeading(theme);
    }
  }

  Widget _idleHeading(ThemeData theme) {
    return RichText(
      key: const ValueKey('idle'),
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: AppFontSize.xxxl,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyMedium?.color,
          height: 1.15,
        ),
        children: const [
          TextSpan(text: 'What expense\nshould we log '),
          // accent colour applied inline — avoids a separate Builder
        ],
      ),
    );
  }
}
