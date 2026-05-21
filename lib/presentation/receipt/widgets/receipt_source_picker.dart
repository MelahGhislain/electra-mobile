import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/enums/image_source_enum.dart';
import 'package:electra/presentation/receipt/bloc/receipt_cubit.dart';
import 'package:electra/presentation/receipt/bloc/receipt_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptSourcePicker {
  static Future<void> show(BuildContext context) {
    // Capture cubit BEFORE sheet opens — same pattern as ExportDataBottomSheet
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

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Text(
                isScanning
                    ? 'Our AI is reading and extracting your purchase details.'
                    : 'Choose how you would like to add your receipt.',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: AppFontSize.sm,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: isScanning
                  ? const _ScanningIndicator()
                  : Row(
                      children: [
                        Expanded(
                          child: _SourceOption(
                            icon: Icons.camera_alt_outlined,
                            label: 'Camera',
                            enabled: !state.isLoading,
                            onTap: () => context
                                .read<ReceiptCubit>()
                                .pickImageAndScan(ImageSourceType.camera),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _SourceOption(
                            icon: Icons.photo_library_outlined,
                            label: 'Gallery',
                            enabled: !state.isLoading,
                            onTap: () => context
                                .read<ReceiptCubit>()
                                .pickImageAndScan(ImageSourceType.gallery),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ── Scanning state ─────────────────────────────────────────────────────────

class _ScanningIndicator extends StatelessWidget {
  const _ScanningIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        Text(
          'Reading your receipt…',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Source option tile ─────────────────────────────────────────────────────

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
