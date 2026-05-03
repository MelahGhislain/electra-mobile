import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/dialogs/app_confirm_dialog.dart';
import 'package:electra/common/widgets/text_fields/catetory_selector.dart';
import 'package:electra/common/widgets/text_fields/text_field.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/purchase/purchase_item.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/category_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC API
// ─────────────────────────────────────────────────────────────────────────────

class ItemFormResult {
  final String name;
  final int quantity;
  final double unitPrice;
  final String categoryNormalizedName;

  const ItemFormResult({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.categoryNormalizedName,
  });
}

Future<ItemFormResult?> showItemFormSheet(
  BuildContext context, {
  PurchaseItem? item,
}) {
  return AppBottomSheet.show<ItemFormResult>(
    context,
    maxHeightPct: 0.90,
    title: item == null ? 'Add item' : 'Edit item',
    icon: item == null ? Icons.add_circle_outline_rounded : Icons.edit_rounded,
    child: _ItemFormSheetBody(item: item),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// FORM BODY
// ─────────────────────────────────────────────────────────────────────────────

class _ItemFormSheetBody extends StatefulWidget {
  final PurchaseItem? item;
  const _ItemFormSheetBody({this.item});

  @override
  State<_ItemFormSheetBody> createState() => _ItemFormSheetBodyState();
}

class _ItemFormSheetBodyState extends State<_ItemFormSheetBody> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _unitPriceCtrl;
  late final TextEditingController _qtyCtrl;

  late CategoryMeta _selectedCategory;

  bool get _isEdit => widget.item != null;

  double get _total {
    final price = double.tryParse(_unitPriceCtrl.text) ?? 0;
    final qty = int.tryParse(_qtyCtrl.text) ?? 0;
    return price * qty;
  }

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _nameCtrl = TextEditingController(text: i?.name ?? '');
    _unitPriceCtrl = TextEditingController(
      text: i != null ? i.unitPrice.toStringAsFixed(2) : '',
    );
    _qtyCtrl = TextEditingController(
      text: i != null ? i.quantity.toString() : '1',
    );
    _selectedCategory = CategoryMeta.fromKey(
      i?.category.normalizedName ?? 'other',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _unitPriceCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    final result = await showCategoryPicker(
      context,
      selectedKey: _selectedCategory.label.toLowerCase(),
    );
    if (result != null) setState(() => _selectedCategory = result);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      ItemFormResult(
        name: _nameCtrl.text.trim(),
        quantity: int.parse(_qtyCtrl.text.trim()),
        unitPrice: double.parse(_unitPriceCtrl.text.trim()),
        categoryNormalizedName: _selectedCategory.label.toLowerCase(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Name ──────────────────────────────────────────────
              AppTextField(
                controller: _nameCtrl,
                label: 'Item name',
                hint: 'e.g. Beef, Milk, Shampoo',
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),

              const SizedBox(height: 16),

              // ── 2. Category ──────────────────────────────────────────
              CategorySelectField(
                label: 'Category',
                selected: _selectedCategory,
                onTap: _pickCategory,
              ),

              const SizedBox(height: 16),

              // ── 3. Unit price | Quantity | Total ─────────────────────
              _PricingRow(
                unitPriceCtrl: _unitPriceCtrl,
                qtyCtrl: _qtyCtrl,
                total: _total,
                onChanged: () => setState(() {}),
              ),

              const SizedBox(height: 24),

              // ── Save button ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBackground,
                    foregroundColor: AppColors.darkText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    _isEdit ? 'Save changes' : 'Add item',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRICING ROW  — unit price | qty | total
// ─────────────────────────────────────────────────────────────────────────────

class _PricingRow extends StatelessWidget {
  final TextEditingController unitPriceCtrl;
  final TextEditingController qtyCtrl;
  final double total;
  final VoidCallback onChanged;

  const _PricingRow({
    required this.unitPriceCtrl,
    required this.qtyCtrl,
    required this.total,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Unit price
        Expanded(
          flex: 3,
          child: AppTextField(
            controller: unitPriceCtrl,
            hint: '0.00',
            label: 'Unit price',
            prefixText: '\$ ',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            onChanged: (_) => onChanged(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final n = double.tryParse(v);
              if (n == null || n <= 0) return 'Invalid';
              return null;
            },
          ),
        ),

        const SizedBox(width: 10),

        // Quantity
        Expanded(
          flex: 2,
          child: AppTextField(
            controller: qtyCtrl,
            hint: '1',
            label: 'Qty',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => onChanged(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (int.tryParse(v) == null || int.parse(v) < 1) {
                return 'Min 1';
              }
              return null;
            },
          ),
        ),

        const SizedBox(width: 10),

        // Total (read-only)
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightText,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  // color: AppColors.lightSurface,
                  // borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: AppColors.dividerLight),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightText,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DELETE CONFIRMATION DIALOG
// ─────────────────────────────────────────────────────────────────────────────

Future<bool?> showDeleteItemConfirmation(
  BuildContext context, {
  required PurchaseItem item,
}) {
  return AppConfirmDialog.show(
    context,
    title: 'Delete item?',
    description:
        '"${item.name}" will be permanently removed from this purchase.',
    confirmText: 'Delete',
    isDestructive: true,
    onConfirm: () => Navigator.pop(context, true),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SMALL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.lightText,
      ),
    );
  }
}
