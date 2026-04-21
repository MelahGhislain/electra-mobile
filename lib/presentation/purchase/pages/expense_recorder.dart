import 'package:electra/common/blocs/receipt/receipt_cubit.dart';
import 'package:electra/common/blocs/receipt/receipt_state.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/enums/image_source_enum.dart';
import 'package:electra/presentation/purchase/widgets/animated_orb.dart';
import 'package:electra/presentation/purchase/widgets/bottom_nav_row.dart';
import 'package:electra/presentation/purchase/widgets/mic_button.dart';
import 'package:electra/presentation/purchase/widgets/recorder_heading.dart';
import 'package:electra/presentation/purchase/widgets/session_timer.dart';
import 'package:electra/presentation/purchase/widgets/start_talking_pill.dart';
import 'package:electra/presentation/purchase/widgets/waveform_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExpenseRecorderScreen extends StatelessWidget {
  const ExpenseRecorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
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

              // ── Green orb (unchanged from original) ───────────────────
              AnimatedOrb(),

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

              // ── Bottom row: home · [timer] · chat ──────────────────────
              BlocBuilder<ReceiptCubit, ReceiptState>(
                builder: (context, state) {
                  return BottomNavRow(
                    centerWidget: SizedBox.shrink(), // timer is above
                    onHome: () {
                      context.pop();
                    },
                    onChat: () {
                      context.read<ReceiptCubit>().pickImage(
                        ImageSourceType.camera,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
