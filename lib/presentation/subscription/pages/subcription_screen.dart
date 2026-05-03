import 'package:electra/common/widgets/buttons/main_icon_button.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/presentation/subscription/widgets/billing_toggle.dart';
import 'package:electra/presentation/subscription/widgets/free_plan_comparison.dart';
import 'package:electra/presentation/subscription/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isAnnual = true;
  bool _isLoading = false;

  Future<void> _handleSubscribe() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();
    // TODO: trigger in-app purchase flow (Google Play / App Store)
    // e.g. context.read<SubscriptionCubit>().purchase(isAnnual: _isAnnual)
    await Future.delayed(const Duration(seconds: 2)); // placeholder
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          actionsPadding: EdgeInsets.only(right: 20),
          leading: Text(''),
          actions: [
            MainIconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Theme.of(context).textTheme.titleLarge!.color,
                size: 20,
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Hero headline ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      'Spend Smarter.\nGrow Faster.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSize.xxxl,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: -1.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Unlock AI-powered insights, unlimited tracking,\nand tools that actually change your habits.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Billing toggle ────────────────────────────────
                    BillingToggle(
                      isAnnual: _isAnnual,
                      onChanged: (val) => setState(() => _isAnnual = val),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Premium plan card ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PlanCard(
                  isAnnual: _isAnnual,
                  onSubscribe: _handleSubscribe,
                  isLoading: _isLoading,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Free plan comparison ──────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FreePlanComparison(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Trust signals ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TrustRow(),
              ),
            ),

            // ── Legal footer ──────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 10, 24, 40),
                child: _LegalFooter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Trust row ─────────────────────────────────────────────────────────────────

class _TrustRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TrustItem(icon: Icons.shield_outlined, label: '7-day free\ntrial'),
        _Divider(),
        _TrustItem(icon: Icons.cancel_outlined, label: 'Cancel\nanytime'),
        _Divider(),
        _TrustItem(icon: Icons.lock_outline_rounded, label: 'Secure\npayment'),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF22C55E)),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSize.xs,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    // isDark?  AppColors.darkSurfaceAlt : AppColors.lightBorder,
    return Container(width: 1, height: 36, color: Theme.of(context).dividerColor);
  }
}

// ── Legal footer ──────────────────────────────────────────────────────────────

class _LegalFooter extends StatelessWidget {
  const _LegalFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        const Text(
          'Subscriptions auto-renew unless cancelled at least 24 hours before the end of the current period. '
          'Manage or cancel your subscription at any time in your device\'s account settings. '
          'Prices may vary by region.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSize.xs,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterLink(label: 'Privacy Policy', onTap: () {}),
            const Text(
              ' · ',
              style: TextStyle(color: Color(0xFF4B5563), fontSize: 11),
            ),
            _FooterLink(label: 'Terms of Service', onTap: () {}),
            const Text(
              ' · ',
              style: TextStyle(color: Color(0xFF4B5563), fontSize: 11),
            ),
            _FooterLink(label: 'Restore Purchase', onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: AppFontSize.xs,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFF6B7280),
        ),
      ),
    );
  }
}
