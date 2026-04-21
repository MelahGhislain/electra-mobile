import 'package:electra/presentation/purchase/widgets/action_button.dart';
import 'package:flutter/material.dart';

/// Row with home button on the left and chat button on the right,
/// with the session timer centred between them.
class BottomNavRow extends StatefulWidget {
  final Widget centerWidget;
  final VoidCallback? onHome;
  final VoidCallback? onChat;

  const BottomNavRow({
    super.key,
    required this.centerWidget,
    this.onHome,
    this.onChat,
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
        ActionButton(icon: Icons.home, onTap: widget.onHome),
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
