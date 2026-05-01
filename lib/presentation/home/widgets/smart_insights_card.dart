import 'package:flutter/material.dart';

class SmartInsightsCard extends StatelessWidget {
  final VoidCallback onViewAll;
  const SmartInsightsCard({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header (right padding included)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Smart Insights',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                GestureDetector(
                  onTap: onViewAll,
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF22C55E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal scroll
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _InsightTile(
                  bg: Color(0xFFF0FDF4),
                  border: Color(0xFFBBF7D0),
                  icon: Icons.trending_up_rounded,
                  iconColor: Color(0xFF22C55E),
                  text: 'You spend 40%\nmore on weekends.',
                  linkColor: Color(0xFF15803D),
                ),
                SizedBox(width: 10),
                _InsightTile(
                  bg: Color(0xFFFFFBEB),
                  border: Color(0xFFFDE68A),
                  icon: Icons.credit_card_rounded,
                  iconColor: Color(0xFFF59E0B),
                  text: 'Subscriptions cost\nyou \$52/month.',
                  linkColor: Color(0xFF92400E),
                ),
                SizedBox(width: 10),
                _InsightTile(
                  bg: Color(0xFFEFF6FF),
                  border: Color(0xFFBFDBFE),
                  icon: Icons.pie_chart_rounded,
                  iconColor: Color(0xFF3B82F6),
                  text: 'Food spending\nincreased 18%\nthis week.',
                  linkColor: Color(0xFF1D4ED8),
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final Color bg;
  final Color border;
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color linkColor;

  const _InsightTile({
    required this.bg,
    required this.border,
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.linkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'View details',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: linkColor,
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.chevron_right_rounded, size: 14, color: linkColor),
            ],
          ),
        ],
      ),
    );
  }
}
