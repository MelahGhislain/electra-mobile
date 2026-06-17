import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/core/utils/category_meta.dart';
import 'package:qleo/domain/entities/insights/insights.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class InsightsRecommendations extends StatelessWidget {
  final List<Recommendation> recommendations;
  final String currency;

  const InsightsRecommendations({
    super.key,
    required this.recommendations,
    required this.currency,
  });

  void _openAllRecommendations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AllRecommendationsSheet(
        recommendations: recommendations,
        currency: currency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    if (recommendations.isEmpty) return const SizedBox.shrink();

    final displayed = recommendations.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.recommendationsForYou,
                style: TextStyle(
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () => _openAllRecommendations(context),
                child: Text(
                  l.viewAll,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: List.generate(displayed.length, (i) {
                final rec = displayed[i];
                final isLast = i == displayed.length - 1;
                return Column(
                  children: [
                    _RecommendationTile(
                      recommendation: rec,
                      currency: currency,
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: theme.dividerColor.withValues(alpha: 0.5),
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Single tile ───────────────────────────────────────────────────────────────

class _RecommendationTile extends StatelessWidget {
  final Recommendation recommendation;
  final String currency;

  const _RecommendationTile({
    required this.recommendation,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = CategoryMeta.fromKey(recommendation.icon);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(meta.icon, color: meta.color, size: 20),
          ),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.title,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  recommendation.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: AppFontSize.xs,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right_rounded,
            size: AppFontSize.xl,
            color: theme.iconTheme.color,
          ),
        ],
      ),
    );
  }
}

// ── All recommendations bottom sheet ─────────────────────────────────────────

class _AllRecommendationsSheet extends StatelessWidget {
  final List<Recommendation> recommendations;
  final String currency;

  const _AllRecommendationsSheet({
    required this.recommendations,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l.recommendationsForYou,
                      style: TextStyle(
                        fontSize: AppFontSize.lg,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: AppFontSize.md,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 24, color: theme.dividerColor),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: recommendations.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                  itemBuilder: (_, i) => _RecommendationTile(
                    recommendation: recommendations[i],
                    currency: currency,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
