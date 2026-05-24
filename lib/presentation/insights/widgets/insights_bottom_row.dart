import 'package:minata/domain/entities/insights/insights.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsBottomRow extends StatelessWidget {
  final List<PaymentMethodBreakdown> paymentMethods;
  final List<MerchantBreakdown> merchants;
  final SavingsOpportunity? savingsOpportunity;

  const InsightsBottomRow({
    super.key,
    required this.paymentMethods,
    required this.merchants,
    this.savingsOpportunity,
  });

  @override
  Widget build(BuildContext context) {
    final hasPayment = paymentMethods.isNotEmpty;
    final hasMerchants = merchants.isNotEmpty;
    final hasSavings = savingsOpportunity != null;

    if (!hasPayment && !hasMerchants && !hasSavings) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Payment methods ───────────────────────
        if (hasPayment) _PaymentMethodsCard(methods: paymentMethods),

        if (hasPayment && hasMerchants) const SizedBox(height: 10),
        // ── Merchant breakdown ───────────────────────
        if (hasMerchants) _MerchantBreakdownCard(merchants: merchants),

        // ── Savings opportunity ───────────────────────
        if (hasSavings) ...[
          const SizedBox(height: 10),
          _SavingsCard(opportunity: savingsOpportunity!),
        ],
      ],
    );
  }
}

// ── Payment methods ───────────────────────────────────────────────────────────

class _PaymentMethodsCard extends StatelessWidget {
  final List<PaymentMethodBreakdown> methods;
  const _PaymentMethodsCard({required this.methods});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final displayed = methods.take(3).toList();
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l.paymentMethods,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...displayed.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          m.method,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${fmt.format(m.amount)}  ${m.percent.toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (m.percent / 100).clamp(0.0, 1.0),
                      backgroundColor: theme.dividerColor,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF7C3AED),
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    final theme = Theme.of(context);
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final displayed = merchants.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Merchant breakdown',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
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
          ...displayed.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      m.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    fmt.format(m.amount),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Savings card ──────────────────────────────────────────────────────────────

class _SavingsCard extends StatelessWidget {
  final SavingsOpportunity opportunity;
  const _SavingsCard({required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.savings_outlined,
                  color: Color(0xFF7C3AED),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Savings opportunity',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C3AED),
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            opportunity.message,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF374151),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF7C3AED)),
                foregroundColor: const Color(0xFF7C3AED),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              child: const Text('Set budget'),
            ),
          ),
        ],
      ),
    );
  }
}
