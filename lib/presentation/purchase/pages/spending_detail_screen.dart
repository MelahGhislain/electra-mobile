import 'package:electra/common/widgets/buttons/main_icon_button.dart';
import 'package:electra/common/widgets/dialogs/app_confirm_dialog.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase_detail/purchase_detail_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase_detail/purchase_detail_state.dart';
import 'package:electra/presentation/purchase/widgets/bottom_sheet/add_purchase_bottom_sheet.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_error_state.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_hero_card.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_items_section.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_receipt_section.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpendingDetailScreen extends StatelessWidget {
  final String purchaseId;

  const SpendingDetailScreen({super.key, required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    return _SpendingDetailView(purchaseId: purchaseId);
  }
}

class _SpendingDetailView extends StatelessWidget {
  final String purchaseId;

  const _SpendingDetailView({required this.purchaseId});

  /// Extracts the purchase from any state that carries one.
  Purchase? _purchaseFrom(PurchaseDetailState state) {
    if (state is PurchaseDetailLoaded) return state.purchase;
    if (state is PurchaseDetailItemMutating) return state.purchase;
    if (state is PurchaseDetailItemMutationFailure) return state.purchase;
    if (state is PurchaseDetailItemCreated) return state.purchase;
    return null;
  }

  bool _isMutating(PurchaseDetailState state) =>
      state is PurchaseDetailItemMutating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<PurchaseDetailCubit, PurchaseDetailState>(
      // Show a SnackBar when a mutation fails, then keep the screen alive.
      listenWhen: (_, current) => current is PurchaseDetailItemMutationFailure,
      listener: (context, state) {
        if (state is PurchaseDetailItemMutationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final purchase = _purchaseFrom(state);
        final mutating = _isMutating(state);

        return Stack(
          children: [
            // ── Main scaffold ──────────────────────────────────────────
            Scaffold(
              appBar: _buildAppBar(context, state),
              body: _buildBody(context, state, purchase),
            ),

            // ── Mutation loading overlay ───────────────────────────────
            if (mutating) const _MutationLoadingOverlay(),
          ],
        );
      },
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PurchaseDetailState state,
  ) {
    final theme = Theme.of(context);
    final hasPurchase = _purchaseFrom(state) != null;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: MainIconButton(
        margin: EdgeInsets.all(8),
        size: 16,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: theme.iconTheme.color,
          size: 20,
        ),
        onTap: () => Navigator.of(context).pop(),
      ),

      title: const Text(
        'Spending details',
        style: TextStyle(
          fontSize: AppFontSize.xxxl,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        if (hasPurchase)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: MainIconButton(
              icon: Icon(
                Icons.more_horiz_rounded,
                color: theme.iconTheme.color,
                size: 18,
              ),
              onTap: () {
                final purchase = _purchaseFrom(state);
                if (purchase != null) {
                  _showOptionsMenu(context, purchase);
                }
              },
            ),
          ),
      ],
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(
    BuildContext context,
    PurchaseDetailState state,
    Purchase? purchase,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Initial full-screen load
    if (state is PurchaseDetailLoading || state is PurchaseDetailInitial) {
      return Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.lightBackground : AppColors.darkBackground,
          strokeWidth: 2,
        ),
      );
    }

    // Full-screen error (only when there is no purchase to show)
    if (state is PurchaseDetailFailure) {
      return SpendingDetailErrorState(
        message: state.message,
        onRetry: () =>
            context.read<PurchaseDetailCubit>().loadPurchase(purchaseId),
      );
    }

    // If we have a purchase (loaded, mutating, mutation failure, or created)
    // always render the content — the overlay handles the loading UI.
    if (purchase != null) {
      return _SpendingDetailContent(purchase: purchase);
    }

    return const SizedBox.shrink();
  }

  // ── Options menu ───────────────────────────────────────────────────────────

  void _showOptionsMenu(BuildContext context, Purchase purchase) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            _OptionTile(
              icon: Icons.edit_rounded,
              label: 'Edit purchase',
              onTap: () {
                Navigator.pop(context);
                AddPurchaseBottomSheet.show(context, purchase: purchase);
              },
            ),

            _OptionTile(
              icon: Icons.share_rounded,
              label: 'Share',
              onTap: () => Navigator.pop(context),
            ),

            _OptionTile(
              icon: Icons.download_rounded,
              label: 'Export',
              onTap: () => Navigator.pop(context),
            ),

            const Divider(height: 1),

            _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete purchase',
              color: theme.colorScheme.error,
              onTap: () {
                Navigator.pop(context); // close the options sheet first
                AppConfirmDialog.show(
                  context,
                  title: 'Delete purchase?',
                  description: 'This action cannot be undone.',
                  confirmText: 'Delete',
                  isDestructive: true,
                  onConfirm: () {
                    context.read<PurchaseCubit>().deletePurchase(purchase.id);
                    Navigator.of(context).pop(); // pop the detail screen
                  },
                );
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Mutation overlay ──────────────────────────────────────────────────────────
// Sits on top of the Scaffold during create/update/delete operations.
// Semi-transparent so the user can still see the screen beneath.

class _MutationLoadingOverlay extends StatelessWidget {
  const _MutationLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      // Block touches while mutating so the user can't trigger another action.
      child: Container(
        color: Colors.black.withValues(alpha: 0.35),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 45,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: AppColors.darkBackground,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Saving changes…',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Option tile ───────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: color ?? theme.iconTheme.color, size: 20),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}

// ── Scrollable content ────────────────────────────────────────────────────────

class _SpendingDetailContent extends StatelessWidget {
  final Purchase purchase;

  const _SpendingDetailContent({required this.purchase});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpendingDetailHeroCard(purchase: purchase),
          // Items section reads from the cubit directly (see fix below)
          const SpendingDetailItemsSection(),

          const SpendingDetailSectionHeader(title: 'Receipt'),

          SpendingDetailReceiptSection(
            receipt: purchase.receipt,
            onView: () {
              final url = purchase.receipt?.imageUrl;
              if (url != null) {
                // TODO: open receipt viewer
              }
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
