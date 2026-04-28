import 'package:electra/common/helpers/average.dart';
import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/domain/entities/purchase/purchase_item.dart';
import 'package:electra/presentation/purchase/blocs/purchase_detail/purchase_detail_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase_detail/purchase_detail_state.dart';
import 'package:electra/presentation/purchase/widgets/spending/category_meta.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/item_form_sheet.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/spending_detail_item_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _ItemView { list, group }

enum _ItemSort { nameAZ, nameZA, priceLow, priceHigh }

extension _ItemSortLabel on _ItemSort {
  String get label {
    switch (this) {
      case _ItemSort.nameAZ:
        return 'Name (A–Z)';
      case _ItemSort.nameZA:
        return 'Name (Z–A)';
      case _ItemSort.priceLow:
        return 'Price ↑';
      case _ItemSort.priceHigh:
        return 'Price ↓';
    }
  }
}

/// No longer receives [purchase] as a prop.
/// Instead it subscribes to [PurchaseDetailCubit] so any mutation
/// (create / update / delete) automatically re-renders the list.
class SpendingDetailItemsSection extends StatefulWidget {
  const SpendingDetailItemsSection({super.key});

  @override
  State<SpendingDetailItemsSection> createState() =>
      _SpendingDetailItemsSectionState();
}

class _SpendingDetailItemsSectionState
    extends State<SpendingDetailItemsSection> {
  _ItemView _view = _ItemView.list;
  _ItemSort _sort = _ItemSort.nameAZ;

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Extracts the current purchase from any state that carries one.
  Purchase? _purchaseFrom(PurchaseDetailState state) {
    if (state is PurchaseDetailLoaded) return state.purchase;
    if (state is PurchaseDetailItemMutating) return state.purchase;
    if (state is PurchaseDetailItemMutationFailure) return state.purchase;
    if (state is PurchaseDetailItemCreated) return state.purchase;
    return null;
  }

  List<PurchaseItem> _sorted(List<PurchaseItem> items) {
    final copy = List<PurchaseItem>.from(items);
    switch (_sort) {
      case _ItemSort.nameAZ:
        copy.sort((a, b) => a.name.compareTo(b.name));
      case _ItemSort.nameZA:
        copy.sort((a, b) => b.name.compareTo(a.name));
      case _ItemSort.priceLow:
        copy.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
      case _ItemSort.priceHigh:
        copy.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
    }
    return copy;
  }

  // ── Sort picker ────────────────────────────────────────────────────────────

  Future<void> _showSortPicker() async {
    final result = await AppBottomSheet.show<_ItemSort>(
      context,
      title: 'Sort items',
      icon: Icons.sort_rounded,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _ItemSort.values.map((opt) {
          final selected = opt == _sort;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              opt.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.lightText,
              ),
            ),
            trailing: selected
                ? const Icon(Icons.check_rounded,
                    color: AppColors.primary, size: 18)
                : null,
            onTap: () => Navigator.pop(context, opt),
          );
        }).toList(),
      ),
    );
    if (result != null) setState(() => _sort = result);
  }

  // ── Add item ───────────────────────────────────────────────────────────────

  Future<void> _mutateItem(BuildContext context, PurchaseItem? item) async {
    final result = await showItemFormSheet(context, item: item);
    if (result == null || !context.mounted) return;

    final itemData = {
      'name': result.name,
      'quantity': result.quantity,
      'unitPrice': result.unitPrice,
      'totalPrice': result.unitPrice * result.quantity,
      'category': {
        'name': result.name,
        'normalizedName': result.name.toLowerCase(),
      },
    };

    if (item != null) {
      context.read<PurchaseDetailCubit>().updateItem(item.id, itemData);
    } else {
      context.read<PurchaseDetailCubit>().createItem(itemData);
    }
  }

  Future<void> _deleteItem(String id) async {
    await context.read<PurchaseDetailCubit>().deleteItem(id);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // BlocBuilder here — every state change (including mutations) rebuilds this
    // widget with the latest purchase so the list stays in sync.
    return BlocBuilder<PurchaseDetailCubit, PurchaseDetailState>(
      builder: (context, state) {
        final purchase = _purchaseFrom(state);

        // If there's no purchase yet (e.g. still initial loading) render nothing.
        if (purchase == null) return const SizedBox.shrink();

        final activeItems = _sorted(purchase.activeItems);
        final isMutating = state is PurchaseDetailItemMutating;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Items (${activeItems.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // Disable add button while a mutation is in flight
                  GestureDetector(
                    onTap: isMutating ? null : () => _mutateItem(context, null),
                    child: AnimatedOpacity(
                      opacity: isMutating ? 0.5 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_circle_outline_rounded,
                                size: 18, color: AppColors.darkText),
                            SizedBox(width: 4),
                            Text(
                              'Add item',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Sort control ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  const Spacer(),
                  if (_view == _ItemView.list)
                    GestureDetector(
                      onTap: isMutating ? null : _showSortPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                          border:
                              Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.sort_rounded,
                                size: 22, color: AppColors.lightText),
                            const SizedBox(width: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sort',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.lightTextSecondary)),
                                Text(_sort.label,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.lightText)),
                              ],
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                size: 18, color: AppColors.lightText),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Item list / group view ────────────────────────────────────
            if (_view == _ItemView.list) ...[
              if (activeItems.isEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEEF0F3)),
                  ),
                  child: const Center(
                    child: Text(
                      'No items recorded',
                      style: TextStyle(
                          color: AppColors.lightTextSecondary, fontSize: 14),
                    ),
                  ),
                )
              else
                ...activeItems.map(
                  (item) {
                    // Show a localised spinner on the specific item being mutated.
                    final isThisItemMutating = isMutating &&
                        state.itemId == item.id;

                    return SpendingDetailItemRow(
                      key: ValueKey(item.id),
                      item: item,
                      purchaseTotal: purchase.totals.amount,
                      average: average(
                        purchase.totals.amount,
                        purchase.totals.itemCount,
                      ),
                      isMutating: isThisItemMutating,
                      onEdit: isMutating
                          ? null
                          : (item) async {
                              Navigator.pop(context);
                              await _mutateItem(context, item);
                            },
                      onDelete: isMutating
                          ? null
                          : (id) => _deleteItem(id),
                    );
                  },
                ),
            ] else ...[
              _GroupView(purchase: purchase),
            ],

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// GROUP VIEW
// ─────────────────────────────────────────

class _GroupView extends StatelessWidget {
  final Purchase purchase;
  const _GroupView({required this.purchase});

  @override
  Widget build(BuildContext context) {
    final total = purchase.totals.amount;

    final Map<String, List<PurchaseItem>> grouped = {};
    for (final item in purchase.activeItems) {
      grouped.putIfAbsent(item.category.normalizedName, () => []).add(item);
    }

    if (grouped.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text('No category data available',
              style: TextStyle(color: AppColors.lightTextSecondary)),
        ),
      );
    }

    return Column(
      children: grouped.entries.map((entry) {
        final meta = CategoryMeta.fromKey(entry.key);
        final categoryItems = entry.value;
        final catTotal =
            categoryItems.fold<double>(0, (s, i) => s + i.totalPrice);
        final pct = total > 0 ? (catTotal / total) * 100 : 0.0;

        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEF0F3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 16, 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: meta.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(meta.icon, size: 18, color: meta.color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${categoryItems.length} item${categoryItems.length == 1 ? '' : 's'}',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${catTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightText),
                        ),
                        Text(
                          '${pct.toStringAsFixed(1)}%',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: meta.color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    minHeight: 4,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        meta.color.withValues(alpha: 0.6)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...categoryItems.map((item) => Column(
                    children: [
                      const Divider(
                          height: 1, color: Color(0xFFF1F5F9), indent: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(item.name,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightText)),
                            ),
                            Text('${item.quantity}×',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400)),
                            const SizedBox(width: 8),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 4),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────
// VIEW TAB
// ─────────────────────────────────────────

class _ViewTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ViewTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 14,
                color: selected ? AppColors.primary : Colors.grey.shade400),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.lightText : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
