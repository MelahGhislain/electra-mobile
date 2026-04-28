import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/insights/insights.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsBottomRow extends StatelessWidget {
  final List<PaymentMethodBreakdown> paymentMethods;
  final List<MerchantBreakdown> merchants;

  const InsightsBottomRow({
    super.key,
    required this.paymentMethods,
    required this.merchants,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (paymentMethods.isNotEmpty)
            Expanded(child: _PaymentMethodsCard(methods: paymentMethods)),
          if (paymentMethods.isNotEmpty && merchants.isNotEmpty)
            const SizedBox(width: 12),
          if (merchants.isNotEmpty)
            Expanded(child: _MerchantBreakdownCard(merchants: merchants)),
        ],
      ),
    );
  }
}

// ── Payment methods ────────────────────────────────────────────────────────────

class _PaymentMethodsCard extends StatelessWidget {
  final List<PaymentMethodBreakdown> methods;

  const _PaymentMethodsCard({required this.methods});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final displayed = methods.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment methods',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightText,
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7C3AED),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rows
          ...List.generate(displayed.length, (i) {
            final m = displayed[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        m.method,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightText,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${fmt.format(m.amount)}  ${m.percent.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.lightTextSecondary,
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: m.percent / 100,
                      backgroundColor: AppColors.dividerLight,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF7C3AED),
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Merchant breakdown ────────────────────────────────────────────────────────

class _MerchantBreakdownCard extends StatelessWidget {
  final List<MerchantBreakdown> merchants;

  const _MerchantBreakdownCard({required this.merchants});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final displayed = merchants.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Merchant breakdown',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightText,
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7C3AED),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rows
          ...List.generate(displayed.length, (i) {
            final m = displayed[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  // Initial avatar
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.dividerLight),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      m.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    fmt.format(m.amount),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
