import 'package:electra/common/widgets/buttons/main_icon_button.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/presentation/purchase/blocs/purchase_detail/purchase_detail_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase_detail/purchase_detail_state.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_action_bar.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_error_state.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_hero_card.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_insight_row.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_item_row.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_notes_section.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_receipt_section.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpendingDetailScreen extends StatelessWidget {
  final String purchaseId;

  const SpendingDetailScreen({super.key, required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    return const _SpendingDetailView();
  }
}

class _SpendingDetailView extends StatelessWidget {
  const _SpendingDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseDetailCubit, PurchaseDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
          bottomNavigationBar: state is PurchaseDetailLoaded
              ? SpendingDetailActionBar(
                  onEdit: () {
                    // TODO: navigate to edit screen
                  },
                  onDelete: () => _confirmDelete(context, state.purchase),
                )
              : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PurchaseDetailState state,
  ) {
    return AppBar(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: 
      
      GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.dividerLight),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: AppColors.lightText,
          ),
        ),
      ),
      title: const Text(
        'Spending details',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.lightText,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        if (state is PurchaseDetailLoaded)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: MainIconButton(
                  icon: Icon(Icons.more_horiz_rounded, color: AppColors.lightText, size: 18,), 
                  onTap: () => _showOptionsMenu(context),
              )
          )
      ],
    );
  }

  Widget _buildBody(BuildContext context, PurchaseDetailState state) {
    if (state is PurchaseDetailLoading || state is PurchaseDetailInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.darkBackground),
      );
    }

    if (state is PurchaseDetailFailure) {
      return SpendingDetailErrorState(
        message: state.message,
        onRetry: () => context.read<PurchaseDetailCubit>().loadPurchase(
          (context.findAncestorWidgetOfExactType<SpendingDetailScreen>())
                  ?.purchaseId ??
              '',
        ),
      );
    }

    if (state is PurchaseDetailLoaded) {
      return _SpendingDetailContent(purchase: state.purchase);
    }

    return const SizedBox.shrink();
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
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
            const Divider(height: 1, color: AppColors.dividerLight),
            _OptionTile(
              icon: Icons.flag_rounded,
              label: 'Report issue',
              color: const Color(0xFFEF4444),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Purchase purchase) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete purchase?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.lightText,
          ),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: AppColors.lightTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.lightTextSecondary),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // TODO: call delete use case
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

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
    final c = color ?? AppColors.lightText;
    return ListTile(
      leading: Icon(icon, color: c, size: 20),
      title: Text(
        label,
        style: TextStyle(color: c, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}

// ── Scrollable content ────────────────────────────────────────────────────

class _SpendingDetailContent extends StatelessWidget {
  final Purchase purchase;

  const _SpendingDetailContent({required this.purchase});

  @override
  Widget build(BuildContext context) {
    final activeItems = purchase.items.where((i) => !i.isDeleted).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero card ──────────────────────────────────────────────────
          SpendingDetailHeroCard(purchase: purchase),

          // ── AI Insight ─────────────────────────────────────────────────
          if (purchase.ai.isProcessed && purchase.ai.confidenceScore != null)
            SpendingDetailInsightRow(
              message:
                  'This is ${((1 - (purchase.ai.confidenceScore ?? 0)) * 100).toStringAsFixed(0)}% less than your average spend.',
            )
          else
            const SpendingDetailInsightRow(
              message: 'AI processing is complete for this purchase.',
            ),

          // ── Items ──────────────────────────────────────────────────────
          SpendingDetailSectionHeader(
            title: 'Items',
            trailing:
                '${activeItems.length} item${activeItems.length == 1 ? '' : 's'}',
          ),

          // Items list wrapped in a single card container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.dividerLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: activeItems.asMap().entries.map((entry) {
                  return _ItemRow(
                    item: entry.value,
                    isLast: entry.key == activeItems.length - 1,
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Notes ──────────────────────────────────────────────────────
          const SpendingDetailSectionHeader(title: 'Notes'),
          SpendingDetailNotesSection(
            notes: purchase.voice?.transcript,
            onEdit: () {
              // TODO: open notes editor
            },
          ),

          // ── Receipt ────────────────────────────────────────────────────
          const SpendingDetailSectionHeader(title: 'Receipt'),
          SpendingDetailReceiptSection(
            receipt: purchase.receipt,
            onView: () {
              // TODO: open receipt viewer
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final dynamic item;
  final bool isLast;

  const _ItemRow({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpendingDetailItemRow(item: item, isLast: isLast),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 74,
            endIndent: 0,
            color: Color(0xFFF1F5F9),
          ),
      ],
    );
  }
}
