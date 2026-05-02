import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/text_fields/catetory_selector.dart';
import 'package:electra/common/widgets/text_fields/date_field.dart';
import 'package:electra/common/widgets/text_fields/text_field.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/category_picker.dart';
import 'package:flutter/material.dart';

class AddPurchaseBottomSheet {
  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context,
      title: 'Add Purchase',
      icon: Icons.receipt_long_outlined,
      maxHeightPct: 0.90,
      child: const _AddPurchaseBody(),
    );
  }
}

class _AddPurchaseBody extends StatefulWidget {
  const _AddPurchaseBody();

  @override
  State<_AddPurchaseBody> createState() => _AddPurchaseBodyState();
}

class _AddPurchaseBodyState extends State<_AddPurchaseBody> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _currencyCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  CategoryMeta _selectedCategory = CategoryMeta.fromKey('other');
  String _paymentMethod = 'card';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _currencyCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickCategory() async {
    final result = await showCategoryPicker(
      context,
      selectedKey: _selectedCategory.label.toLowerCase(),
    );
    if (result != null) setState(() => _selectedCategory = result);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: dispatch to PurchaseCubit
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AppTextField(
              controller: _titleCtrl,
              label: 'Title',
              hint: 'e.g. Santa lucia',
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter a name'
                  : null,
            ),

            const SizedBox(height: 16),

            // Date
            DateField(label: 'Date', value: _selectedDate, onTap: _pickDate),
            const SizedBox(height: 16),

            // Category
            CategorySelectField(
              selected: _selectedCategory,
              onTap: _pickCategory,
            ),

            const SizedBox(height: 16),

            // Payment method
            _label('Payment Method'),
            Row(
              children: [
                _payChip(Icons.access_time_filled, 'Card', 'card'),
                const SizedBox(width: 8),
                _payChip(Icons.wallet, 'Cash', 'cash'),
                const SizedBox(width: 8),
                _payChip(null, 'Other', 'other'),
              ],
            ),
            const SizedBox(height: 16),

            // Amount + optional currency
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: AppTextField(
                    controller: _amountCtrl,
                    label: 'Amount',
                    hint: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter amount' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    controller: _currencyCtrl,
                    label: 'Currency',
                    hint: 'e.g USD',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            MainButton(
              text: 'Save Purchase',
              onPressed: _save,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _payChip(IconData? icon, String label, String value) {
    final selected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF111111) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF111111) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 15,
                color: !selected ? const Color(0xFF111111) : Colors.white,
              ),
            SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.grey,
        letterSpacing: 0.4,
      ),
    ),
  );
}
