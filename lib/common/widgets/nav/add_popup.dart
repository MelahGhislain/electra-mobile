import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/l10n/app_localizations.dart';
import 'package:electra/presentation/settings/blocs/user_cubit.dart';
import 'package:electra/presentation/settings/blocs/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    final l = AppLocalizations.of(context);
    final notchColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkBorder
        : Colors.white;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final cubit = context.read<UserCubit>();

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
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.12),
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
                      title: l.manualEntry,
                      subtitle: l.enterDetailsManually,
                      onTap: onManualEntry,
                    ),
                    const Divider(height: 0.5, indent: 16, endIndent: 16),
                    _PopupRow(
                      iconBg: const Color(0xFFEDE9FE),
                      icon: Icons.mic_outlined,
                      iconColor: const Color(0xFF7C3AED),
                      title: l.voiceInput,
                      subtitle: l.addBySpeaking,
                      isPremium: !cubit.hasPremium,
                      isLocked: !cubit.hasPremium,
                      onTap: onVoiceInput,
                    ),
                    const Divider(height: 0.5, indent: 16, endIndent: 16),
                    _PopupRow(
                      iconBg: const Color(0xFFDBEAFE),
                      icon: Icons.camera_alt_outlined,
                      iconColor: const Color(0xFF2563EB),
                      title: l.scanReceipt,
                      subtitle: l.snapPhotoOfReceipt,
                      isPremium: !cubit.hasPremium,
                      isLocked: !cubit.hasPremium,
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
      },
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
    final l = AppLocalizations.of(context);

    return InkWell(
      onTap: !isLocked
          ? onTap
          : () => context.pushNamed(RouteNames.subscription),
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
                        width: 130,
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: AppFontSize.md),
                          maxLines: 1,
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
                          child: Text(
                            l.premium,
                            style: const TextStyle(fontSize: AppFontSize.sm),
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
