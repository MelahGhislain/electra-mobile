import 'package:electra/common/widgets/buttons/main_icon_button.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/presentation/subscription/bloc/subscription_cubit.dart';
import 'package:electra/presentation/subscription/bloc/subscription_state.dart';
import 'package:electra/presentation/subscription/widgets/billing_toggle.dart';
import 'package:electra/presentation/subscription/widgets/free_plan_comparison.dart';
import 'package:electra/presentation/subscription/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isAnnual = true;

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionActivated) {
            HapticFeedback.heavyImpact();
            _showSuccessDialog(context);
          }
          if (state is SubscriptionFailure &&
              !state.message.contains('cancelled')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SubscriptionLoading;
          final isPurchasing = state is SubscriptionPurchasing;

          // Resolve product from loaded state
          ProductDetails? product;
          if (state is SubscriptionLoaded) {
            product = _isAnnual ? state.annualProduct : state.monthlyProduct;
          } else if (state is SubscriptionPurchasing) {
            final loaded = SubscriptionLoaded(
              subscription: state.subscription,
              products: state.products,
            );
            product = _isAnnual ? loaded.annualProduct : loaded.monthlyProduct;
          }

          // Price from store or sensible fallback
          final priceString =
              product?.price ?? (_isAnnual ? '\$4.99' : '\$9.99');

          return Scaffold(
            appBar: AppBar(
              actionsPadding: const EdgeInsets.only(right: 20),
              leading: const Text(''),
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
                // ── Hero headline ───────────────────────────────────
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
                        BillingToggle(
                          isAnnual: _isAnnual,
                          onChanged: (val) => setState(() => _isAnnual = val),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // ── Premium plan card ───────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PlanCard(
                      isAnnual: _isAnnual,
                      priceString: priceString,
                      isLoading: isLoading || isPurchasing,
                      onSubscribe: () {
                        if (product == null) return;
                        HapticFeedback.mediumImpact();
                        context.read<SubscriptionCubit>().subscribe(product);
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ── Free plan comparison ────────────────────────────
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: FreePlanComparison(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ── Trust signals ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _TrustRow(),
                  ),
                ),

                // ── Legal footer ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
                    child: _LegalFooter(
                      onRestore: () =>
                          context.read<SubscriptionCubit>().restore(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF22C55E),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Premium! 🎉',
              style: TextStyle(
                fontSize: AppFontSize.lg,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your subscription is now active. Enjoy unlimited access to all premium features.',
              style: TextStyle(fontSize: AppFontSize.sm, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss dialog
                Navigator.of(context).pop(); // go back to app
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Start exploring'),
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
    return Container(
      width: 1,
      height: 36,
      color: Theme.of(context).dividerColor,
    );
  }
}

// ── Legal footer ──────────────────────────────────────────────────────────────

class _LegalFooter extends StatelessWidget {
  final VoidCallback onRestore;
  const _LegalFooter({required this.onRestore});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const Text(
          'Subscriptions auto-renew unless cancelled at least 24 hours before the end of the current period. '
          'Manage or cancel your subscription at any time in your device\'s account settings. '
          'Prices may vary by region.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: AppFontSize.xs, height: 1.6),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterLink(label: 'Privacy Policy', onTap: () {}),
            const Text(' · ', style: TextStyle(fontSize: AppFontSize.xs)),
            _FooterLink(label: 'Terms of Service', onTap: () {}),
            const Text(' · ', style: TextStyle(fontSize: AppFontSize.xs)),
            _FooterLink(label: 'Restore Purchase', onTap: onRestore),
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
        style: TextStyle(
          fontSize: AppFontSize.xs,
          decoration: TextDecoration.underline,
          decorationColor: Theme.of(context).dividerColor,
        ),
      ),
    );
  }
}
