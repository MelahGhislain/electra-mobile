import 'package:electra/common/widgets/buttons/main_icon_button.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String date;
  final bool showInsightBanner;
  final String? insightBannerText;

  const HomeHeader({
    super.key,
    required this.name,
    required this.date,
    this.showInsightBanner = false,
    this.insightBannerText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hello, $name',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('👋', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: bell + scan + avatar
              Row(
                children: [
                  MainIconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    size: 40,
                    onTap: () {},
                  ),

                  const SizedBox(width: 10),
                  // Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/100',
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ],
              ),
            ],
          ),

          // Insight banner
          if (showInsightBanner) ...[
            const SizedBox(height: 12),
            IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      insightBannerText ??
                          "You're spending less than usual. Great job!",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
