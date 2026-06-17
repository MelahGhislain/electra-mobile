import 'package:qleo/common/blocs/currency/currency_formatter_scope.dart';
import 'package:qleo/common/widgets/buttons/main_button.dart';
import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'feature_row.dart';

class PlanCard extends StatelessWidget {
  final bool isAnnual;
  final VoidCallback onSubscribe;
  final bool isLoading;
  final String priceString;
  final double monthlyPrice;
  final double annualPrice;

  const PlanCard({
    super.key,
    required this.isAnnual,
    required this.onSubscribe,
    this.isLoading = false,
    required this.priceString,
    required this.monthlyPrice,
    required this.annualPrice,
  });

  String get _price => priceString;
  String get _period => isAnnual ? '/month' : '/month';
  String get _billedAs => isAnnual
      ? 'Billed \$59.88/year — cancel anytime'
      : 'Billed monthly — cancel anytime';

  static const _premiumFeatures = [
    'Everything in Free',
    'Never hit a tracking limit again',
    'Scan a receipt in under 3 seconds',
    'Log expenses while driving, hands-free',
    'Know your worst spending habits in 1 tap',
    'Get warned before you overspend',
    'Priority support',
  ];

  int get _savingPercent {
    if (monthlyPrice <= 0) return 0;
    return (((monthlyPrice - annualPrice) / monthlyPrice) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fmt = CurrencyFormatterScope.of(context);

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
                    'Qleo Premium',
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
                  // Replace the price Row with this:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Strikethrough original price — anchoring
                          if (isAnnual)
                            Text(
                              '${fmt.format(monthlyPrice)}/month',
                              style: TextStyle(
                                fontSize: AppFontSize.xs,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                                decorationColor:
                                    theme.textTheme.bodySmall?.color,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          if (isAnnual) const SizedBox(height: 2),

                          // Actual price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _price,
                                style: const TextStyle(
                                  fontSize: AppFontSize.xxxl,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.5,
                                  height: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 6,
                                  left: 4,
                                ),
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
                          child: Text(
                            'SAVE $_savingPercent%',
                            style: const TextStyle(
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
                      checkColor: !isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Fine print
                  const Center(
                    child: Text(
                      'Joined by 10,000+ users tracking smarter',
                      style: TextStyle(
                        fontSize: AppFontSize.xs,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

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
