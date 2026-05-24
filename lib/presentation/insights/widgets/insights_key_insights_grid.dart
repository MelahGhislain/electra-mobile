import 'package:minata/core/configs/fonts.dart';
import 'package:minata/domain/entities/insights/insights.dart';
import 'package:flutter/material.dart';

class InsightsKeyInsightsGrid extends StatelessWidget {
  final List<KeyInsight> insights;

  const InsightsKeyInsightsGrid({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];

    for (int i = 0; i < insights.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: _KeyInsightCard(insight: insights[i])),

            const SizedBox(width: 12),

            if (i + 1 < insights.length)
              Expanded(child: _KeyInsightCard(insight: insights[i + 1]))
            else
              const Spacer(),
          ],
        ),
      );

      if (i < insights.length - 1) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(children: rows);
  }
}

class _KeyInsightCard extends StatelessWidget {
  final KeyInsight insight;
  const _KeyInsightCard({required this.insight});

  _CardStyle get _style {
    switch (insight.type) {
      case KeyInsightType.savings:
        return const _CardStyle(
          icon: Icons.trending_down_rounded,
          iconBg: Color(0xFFDCFCE7),
          iconColor: Color(0xFF16A34A),
        );
      case KeyInsightType.categoryChange:
        return const _CardStyle(
          icon: Icons.trending_up_rounded,
          iconBg: Color(0xFFFFEDD5),
          iconColor: Color(0xFFEA580C),
        );
      case KeyInsightType.dailyAverage:
        return const _CardStyle(
          icon: Icons.track_changes_rounded,
          iconBg: Color(0xFFEDE9FE),
          iconColor: Color(0xFF7C3AED),
        );
      case KeyInsightType.highestDay:
        return const _CardStyle(
          icon: Icons.account_balance_wallet_outlined,
          iconBg: Color(0xFFE0F2FE),
          iconColor: Color(0xFF0284C7),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = _style;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: s.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(s.icon, color: s.iconColor, size: AppFontSize.lg),
          ),
          const SizedBox(width: 10),

          // Text — matches screenshot: small label on top, big value below
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Small label at top (e.g. "You spent", "Shopping increased")
                Text(
                  insight.leadingText,
                  style: TextStyle(fontSize: AppFontSize.xs),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Prominent value (e.g. "$928 less", "18%")
                Text(
                  insight.value,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  insight.tailingText,
                  style: TextStyle(fontSize: AppFontSize.xs),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardStyle {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  const _CardStyle({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}
