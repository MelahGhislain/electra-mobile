import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_cubit.dart';
import 'package:electra/presentation/purchase/blocs/voice/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Central circular mic button.
/// Idle    → outlined circle with mic icon
/// Active  → filled primary colour, pulsing ring, stop icon
class MicButton extends StatefulWidget {
  const MicButton({super.key});

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceCubit, VoiceState>(
      builder: (context, state) {
        final isListening = state.isListening;

        return GestureDetector(
          onTap: () {
            final cubit = context.read<VoiceCubit>();
            isListening ? cubit.stopListening() : cubit.startListening();
          },
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Pulsing outer ring — only visible when listening
                  if (isListening)
                    Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.darkSurface.withValues(alpha: 0.18),
                        ),
                      ),
                    ),

                  // Core button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isListening ? AppColors.darkSurface : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkSurface.withValues(
                            alpha: isListening ? 0.35 : 0.15,
                          ),
                          blurRadius: isListening ? 16 : 8,
                          spreadRadius: isListening ? 2 : 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isListening
                            ? Colors.transparent
                            : AppColors.darkSurface.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: isListening ? Colors.white : AppColors.darkSurface,
                      size: 28,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
