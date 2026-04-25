import 'package:electra/presentation/purchase/widgets/expense_recorder/action_button.dart';
import 'package:flutter/material.dart';

/// Row with home button on the left and chat button on the right,
/// with the session timer centred between them.
class BottomNavRow extends StatefulWidget {
  final Widget centerWidget;
  final VoidCallback? onHome;
  final VoidCallback? onChat;
  final bool? hasPurchase;

  const BottomNavRow({
    super.key,
    required this.centerWidget,
    this.onHome,
    this.onChat,
    this.hasPurchase = false,
  });

  @override
  State<BottomNavRow> createState() => _BottomNavRowState();
}

class _BottomNavRowState extends State<BottomNavRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActionButton(
          icon: widget.hasPurchase == true ? Icons.home : Icons.settings,
          onTap: widget.onHome,
        ),
        widget.centerWidget,
        ActionButton(
          icon: Icons.center_focus_weak,
          label: 'Snap',
          onTap: widget.onChat,
        ),
      ],
    );
  }
}
