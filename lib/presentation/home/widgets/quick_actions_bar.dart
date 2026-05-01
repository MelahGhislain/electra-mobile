import 'package:electra/common/blocs/receipt/receipt_cubit.dart';
import 'package:electra/core/enums/image_source_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickActionsBar extends StatelessWidget {
  final VoidCallback onAddExpense;
  final VoidCallback onRepeat;
  final VoidCallback onSetBudget;

  const QuickActionsBar({
    super.key,
    required this.onAddExpense,
    required this.onRepeat,
    required this.onSetBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          _ActionCard(
            label: 'Add Expense',
            icon: Icons.add_rounded,
            iconColor: Colors.white,
            circleBg: const Color(0xFF22C55E),
            onTap: onAddExpense,
          ),
          const SizedBox(width: 10),
          _ScanCard(),
          const SizedBox(width: 10),
          _ActionCard(
            label: 'Repeat',
            icon: Icons.repeat_rounded,
            iconColor: Colors.white,
            circleBg: const Color(0xFF8B5CF6),
            onTap: onRepeat,
          ),
          const SizedBox(width: 10),
          _ActionCard(
            label: 'Set Budget',
            icon: Icons.gps_fixed_rounded,
            iconColor: Colors.white,
            circleBg: const Color(0xFFF97316),
            onTap: onSetBudget,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color circleBg;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.circleBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: circleBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            context.read<ReceiptCubit>().pickImage(ImageSourceType.camera),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Scan\nReceipt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
