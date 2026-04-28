import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:flutter/material.dart';

class InsightsKeyInsightsGrid extends StatelessWidget {
  final List<KeyInsight> insights;

  const InsightsKeyInsightsGrid({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: insights.length,
      itemBuilder: (context, index) =>
          _KeyInsightCard(insight: insights[index]),
    );
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
    final s = _style;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerLight),
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
            child: Icon(s.icon, color: s.iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  insight.label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  insight.value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
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
