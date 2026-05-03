// Inside layout_scaffold.dart or extracted to its own file

import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddPopup extends StatelessWidget {
  final Animation<double> animation;
  final bool isVisible;
  final VoidCallback? onManualEntry;
  final VoidCallback? onVoiceInput;
  final VoidCallback? onScanReceipt;

  const AddPopup({
    required this.animation,
    required this.isVisible,
    this.onManualEntry,
    this.onVoiceInput,
    this.onScanReceipt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notchColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkBorder
        : Colors.white;

    return ScaleTransition(
      scale: animation,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Theme.of(context).dividerColor),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PopupRow(
                  iconBg: const Color(0xFFE8FDF0),
                  icon: Icons.edit_outlined,
                  iconColor: const Color(0xFF22C55E),
                  title: 'Manual Entry',
                  subtitle: 'Enter details manually',
                  onTap: onManualEntry,
                ),
                const Divider(height: 0.5, indent: 16, endIndent: 16),
                _PopupRow(
                  iconBg: const Color(0xFFEDE9FE),
                  icon: Icons.mic_outlined,
                  iconColor: const Color(0xFF7C3AED),
                  title: 'Voice Input',
                  subtitle: 'Add by speaking',
                  isPremium: true,
                  isLocked: true,
                  onTap: onVoiceInput,
                ),
                const Divider(height: 0.5, indent: 16, endIndent: 16),
                _PopupRow(
                  iconBg: const Color(0xFFDBEAFE),
                  icon: Icons.camera_alt_outlined,
                  iconColor: const Color(0xFF2563EB),
                  title: 'Scan Receipt',
                  subtitle: 'Snap a photo of your receipt',
                  isPremium: true,
                  isLocked: true,
                  onTap: onScanReceipt,
                ),
              ],
            ),
          ),
          // Notch pointing down toward the FAB
          CustomPaint(
            size: const Size(20, 10),
            painter: _NotchPainter(color: notchColor),
          ),
        ],
      ),
    );
  }
}

class _NotchPainter extends CustomPainter {
  final Color color;

  const _NotchPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_NotchPainter old) => old.color != color;
}

class _PopupRow extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isPremium;
  final bool isLocked;
  final VoidCallback? onTap;

  const _PopupRow({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isPremium = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: AppFontSize.md),
                        ),
                      ),
                      if (isPremium) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Premium',
                            style: TextStyle(fontSize: AppFontSize.sm),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(subtitle, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            if (isLocked)
              Icon(
                Icons.lock_outline,
                size: 16,
                color: Theme.of(context).iconTheme.color,
              )
            else
              Icon(
                Icons.chevron_right,
                size: 16,
                color: Theme.of(context).iconTheme.color,
              ),
          ],
        ),
      ),
    );
  }
}
