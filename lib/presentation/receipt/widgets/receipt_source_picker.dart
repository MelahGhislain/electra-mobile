import 'dart:math' as math;

import 'package:qleo/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/core/enums/image_source_enum.dart';
import 'package:qleo/presentation/receipt/bloc/receipt/receipt_cubit.dart';
import 'package:qleo/presentation/receipt/bloc/receipt/receipt_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point — call ReceiptSourcePicker.show(context) from your FAB / button
// ─────────────────────────────────────────────────────────────────────────────

class ReceiptSourcePicker {
  static Future<void> show(BuildContext context) {
    final receiptCubit = context.read<ReceiptCubit>();

    return AppBottomSheet.show(
      context,
      title: 'Scan Receipt',
      icon: Icons.camera_alt_outlined,
      child: BlocProvider.value(
        value: receiptCubit,
        child: const _ReceiptSourceBody(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body — switches between idle picker and animated loading states
// ─────────────────────────────────────────────────────────────────────────────

class _ReceiptSourceBody extends StatelessWidget {
  const _ReceiptSourceBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ReceiptCubit, ReceiptState>(
      listener: (context, state) {
        if (state.status == ReceiptScanStatus.success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Receipt scanned and purchase created'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<ReceiptCubit>().reset();
        }

        if (state.status == ReceiptScanStatus.error) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Something went wrong'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: theme.colorScheme.error,
            ),
          );
          context.read<ReceiptCubit>().reset();
        }
      },
      builder: (context, state) {
        final isScanning = state.status == ReceiptScanStatus.scanning;
        final isExtracting = state.status == ReceiptScanStatus.extracting;
        final isProcessing = isScanning || isExtracting;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isProcessing
              ? _LoadingBody(key: ValueKey(state.status), status: state.status)
              : _PickerBody(
                  key: const ValueKey('picker'),
                  isLoading: state.isLoading,
                ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Idle state — camera / gallery picker
// ─────────────────────────────────────────────────────────────────────────────

class _PickerBody extends StatelessWidget {
  final bool isLoading;

  const _PickerBody({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose how you would like to add your receipt.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: AppFontSize.sm,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  enabled: !isLoading,
                  onTap: () => context.read<ReceiptCubit>().pickImageAndScan(
                    ImageSourceType.camera,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SourceOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  enabled: !isLoading,
                  onTap: () => context.read<ReceiptCubit>().pickImageAndScan(
                    ImageSourceType.gallery,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading state — animated ring, switches between scanning and extracting
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  final ReceiptScanStatus status;

  const _LoadingBody({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isExtracting = status == ReceiptScanStatus.extracting;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Animated ring — swaps between two distinct animations ────────
          SizedBox(
            height: 200,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isExtracting
                  ? const _AiExtractionRing(key: ValueKey('extract'))
                  : const _OcrScanningRing(key: ValueKey('scan')),
            ),
          ),

          const SizedBox(height: 20),

          // ── Title ─────────────────────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isExtracting
                  ? 'Extracting purchase details'
                  : 'Reading text from your receipt',
              key: ValueKey('title_$isExtracting'),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 6),

          // ── Subtitle ──────────────────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isExtracting
                  ? 'Our AI is analysing your receipt'
                  : 'This may take a few seconds',
              key: ValueKey('sub_$isExtracting'),
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE 1 — OCR scanning ring
// Single rotating arc + pulsing outer glow — feels like active reading
// ─────────────────────────────────────────────────────────────────────────────

class _OcrScanningRing extends StatefulWidget {
  const _OcrScanningRing({super.key});

  @override
  State<_OcrScanningRing> createState() => _OcrScanningRingState();
}

class _OcrScanningRingState extends State<_OcrScanningRing>
    with TickerProviderStateMixin {
  late final AnimationController _rotateCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.93,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.colorScheme.primary;
    final size = 180.0;

    return Center(
      child: ScaleTransition(
        scale: _pulse,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: background.withValues(alpha: 0.06),
                  border: Border.all(
                    color: background.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
              ),

              // Inner background circle
              Container(
                width: size * 0.72,
                height: size * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: background.withValues(alpha: 0.08),
                ),
              ),

              // Rotating arc
              RotationTransition(
                turns: _rotateCtrl,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: _ArcPainter(
                    color: background,
                    strokeWidth: 3.5,
                    sweepFraction: 0.28,
                  ),
                ),
              ),

              // ── Icon placeholder ─────────────────────────────────────────
              // Swap Container below with:
              // Image.asset('assets/images/receipt_scan.png', width: 72, height: 72)
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: background.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE 2 — AI extraction ring
// Two arcs chasing each other with shimmer — feels like computation/thinking
// ─────────────────────────────────────────────────────────────────────────────

class _AiExtractionRing extends StatefulWidget {
  const _AiExtractionRing({super.key});

  @override
  State<_AiExtractionRing> createState() => _AiExtractionRingState();
}

class _AiExtractionRingState extends State<_AiExtractionRing>
    with TickerProviderStateMixin {
  late final AnimationController _rotateCtrl;
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _shimmer = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.colorScheme.primary;
    final backgroundLight = theme.colorScheme.primary.withValues(alpha: 0.1);
    final size = 180.0;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: background.withValues(alpha: 0.04),
              ),
            ),

            // Inner circle
            Container(
              width: size * 0.72,
              height: size * 0.72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: background.withValues(alpha: 0.06),
                border: Border.all(
                  color: background.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),

            // Double rotating arc with shimmer
            RotationTransition(
              turns: _rotateCtrl,
              child: AnimatedBuilder(
                animation: _shimmer,
                builder: (_, _) => CustomPaint(
                  size: Size(size, size),
                  painter: _DoubleArcPainter(
                    colorA: background,
                    colorB: backgroundLight.withValues(alpha: _shimmer.value),
                    strokeWidth: 3.5,
                  ),
                ),
              ),
            ),

            // ── Icon placeholder ─────────────────────────────────────────
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: background.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: background,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom painters
// ─────────────────────────────────────────────────────────────────────────────

class _ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double sweepFraction;

  const _ArcPainter({
    required this.color,
    required this.strokeWidth,
    required this.sweepFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    // Track
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = color.withValues(alpha: 0.12)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Arc
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * sweepFraction,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => false;
}

class _DoubleArcPainter extends CustomPainter {
  final Color colorA;
  final Color colorB;
  final double strokeWidth;

  const _DoubleArcPainter({
    required this.colorA,
    required this.colorB,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Track
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      paint..color = colorA.withValues(alpha: 0.1),
    );
    // Arc A — 40%
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * 0.40,
      false,
      paint..color = colorA,
    );
    // Arc B — 25%, offset 180°
    canvas.drawArc(
      rect,
      math.pi / 2,
      math.pi * 2 * 0.25,
      false,
      paint..color = colorB,
    );
  }

  @override
  bool shouldRepaint(_DoubleArcPainter old) => old.colorB != colorB;
}

// ─────────────────────────────────────────────────────────────────────────────
// Idle picker source option tile
// ─────────────────────────────────────────────────────────────────────────────

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
