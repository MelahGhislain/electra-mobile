import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'feature_row.dart';

class PlanCard extends StatelessWidget {
  final bool isAnnual;
  final VoidCallback onSubscribe;
  final bool isLoading;

  const PlanCard({
    super.key,
    required this.isAnnual,
    required this.onSubscribe,
    this.isLoading = false,
  });

  String get _price => isAnnual ? '\$4.99' : '\$9.99';
  String get _period => isAnnual ? '/month' : '/month';
  String get _billedAs => isAnnual
      ? 'Billed \$59.88/year — cancel anytime'
      : 'Billed monthly — cancel anytime';

  static const _premiumFeatures = [
    'Everything in Free',
    'Unlimited purchases & items',
    'AI receipt scanning',
    'Voice input for expenses',
    'Smart spending insights & trends',
    'Budget alerts & forecasting',
    'Priority support',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB199), Color(0xFFD4BCFF), Color(0xFF93C5FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(27),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Card header label ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(27)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('👑', style: TextStyle(fontSize: AppFontSize.md)),
                  SizedBox(width: 6),
                  Text(
                    'Electra Premium',
                    style: TextStyle(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            // ── Main card body ────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.dividerColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _price,
                            style: const TextStyle(
                              fontSize: AppFontSize.xxxxl,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.5,
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6, left: 4),
                            child: Text(
                              _period,
                              style: const TextStyle(
                                fontSize: AppFontSize.md,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Save badge
                      if (isAnnual)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'SAVE 40%',
                            style: TextStyle(
                              fontSize: AppFontSize.xs,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _billedAs,
                    style: const TextStyle(
                      fontSize: AppFontSize.xs,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Divider
                  Divider(),

                  const SizedBox(height: 14),

                  // Features label
                  const Text(
                    "WHAT YOU'LL GET",
                    style: TextStyle(
                      fontSize: AppFontSize.xs,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Features list
                  ..._premiumFeatures.map(
                    (f) => FeatureRow(
                      text: f,
                      checkColor: !isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // CTA Button
                  // SubscribeButton(onPressed: onSubscribe, isLoading: isLoading),
                  MainButton(
                    text: 'Start Premium — Risk Free',
                    onPressed: onSubscribe,
                    isLoading: isLoading,
                    width: double.infinity,
                    size: ButtonSize.small,
                  ),

                  const SizedBox(height: 16),

                  // Fine print
                  const Center(
                    child: Text(
                      '7-day free trial · No charge until trial ends',
                      style: TextStyle(
                        fontSize: AppFontSize.xs,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
