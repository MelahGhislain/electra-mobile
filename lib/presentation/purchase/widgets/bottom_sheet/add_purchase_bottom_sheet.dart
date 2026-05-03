// import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
// import 'package:electra/common/widgets/buttons/main_button.dart';
// import 'package:electra/common/widgets/text_fields/catetory_selector.dart';
// import 'package:electra/common/widgets/text_fields/chip_selector.dart';
// import 'package:electra/common/widgets/text_fields/date_field.dart';
// import 'package:electra/common/widgets/text_fields/text_field.dart';
// import 'package:electra/core/utils/category_meta.dart';
// import 'package:electra/presentation/purchase/widgets/spending_detail/category_picker.dart';
// import 'package:flutter/material.dart';

// class AddPurchaseBottomSheet {
//   static Future<void> show(BuildContext context) {
//     return AppBottomSheet.show(
//       context,
//       title: 'Add Purchase',
//       icon: Icons.receipt_long_outlined,
//       maxHeightPct: 0.90,
//       child: const _AddPurchaseBody(),
//     );
//   }
// }

// class _AddPurchaseBody extends StatefulWidget {
//   const _AddPurchaseBody();

//   @override
//   State<_AddPurchaseBody> createState() => _AddPurchaseBodyState();
// }

// class _AddPurchaseBodyState extends State<_AddPurchaseBody> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleCtrl = TextEditingController();
//   final _currencyCtrl = TextEditingController();
//   final _amountCtrl = TextEditingController();
//   DateTime _selectedDate = DateTime.now();
//   CategoryMeta _selectedCategory = CategoryMeta.fromKey('other');
//   String _paymentMethod = 'card';

//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     _currencyCtrl.dispose();
//     _amountCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) setState(() => _selectedDate = picked);
//   }

//   Future<void> _pickCategory() async {
//     final result = await showCategoryPicker(
//       context,
//       selectedKey: _selectedCategory.label.toLowerCase(),
//     );
//     if (result != null) setState(() => _selectedCategory = result);
//   }

//   void _save() {
//     if (!_formKey.currentState!.validate()) return;
//     // TODO: dispatch to PurchaseCubit
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.fromLTRB(
//         20,
//         4,
//         20,
//         MediaQuery.of(context).viewInsets.bottom + 20,
//       ),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title
//             AppTextField(
//               controller: _titleCtrl,
//               label: 'Title',
//               hint: 'e.g. Santa lucia',
//               textCapitalization: TextCapitalization.words,
//               validator: (v) => (v == null || v.trim().isEmpty)
//                   ? 'Please enter a name'
//                   : null,
//             ),

//             const SizedBox(height: 16),

//             // Date
//             DateField(label: 'Date', value: _selectedDate, onTap: _pickDate),
//             const SizedBox(height: 16),

//             // Category
//             CategorySelectField(
//               selected: _selectedCategory,
//               onTap: _pickCategory,
//             ),

//             const SizedBox(height: 16),

//             // Payment method
//             ChipSelector<String>(
//               label: 'Payment Method',
//               selected: _paymentMethod,
//               options: ['Card', 'Cash', 'Other']
//                   .map((opt) => ChipSelectorOption(value: opt, label: opt))
//                   .toList(),
//               onSelected: (opt) => setState(() => _paymentMethod = opt!),
//             ),

//             const SizedBox(height: 16),

//             // Amount + optional currency
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: AppTextField(
//                     controller: _amountCtrl,
//                     label: 'Amount',
//                     hint: '0.00',
//                     keyboardType: const TextInputType.numberWithOptions(
//                       decimal: true,
//                     ),
//                     textCapitalization: TextCapitalization.words,
//                     validator: (v) =>
//                         (v == null || v.trim().isEmpty) ? 'Enter amount' : null,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: AppTextField(
//                     controller: _currencyCtrl,
//                     label: 'Currency',
//                     hint: 'e.g USD',
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 28),

//             MainButton(
//               text: 'Save Purchase',
//               onPressed: _save,
//               width: double.infinity,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/text_fields/catetory_selector.dart';
import 'package:electra/common/widgets/text_fields/chip_selector.dart';
import 'package:electra/common/widgets/text_fields/date_field.dart';
import 'package:electra/common/widgets/text_fields/text_field.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/category_picker.dart';
import 'package:flutter/material.dart';

class AddPurchaseBottomSheet {
  /// Call with no [purchase] to add, pass a [purchase] to edit.
  static Future<void> show(BuildContext context, {Purchase? purchase}) {
    return AppBottomSheet.show(
      context,
      title: purchase == null ? 'Add Purchase' : 'Edit Purchase',
      icon: Icons.receipt_long_outlined,
      maxHeightPct: 0.90,
      child: _AddPurchaseBody(purchase: purchase),
    );
  }
}

class _AddPurchaseBody extends StatefulWidget {
  final Purchase? purchase;

  const _AddPurchaseBody({this.purchase});

  @override
  State<_AddPurchaseBody> createState() => _AddPurchaseBodyState();
}

class _AddPurchaseBodyState extends State<_AddPurchaseBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _currencyCtrl;
  late final TextEditingController _amountCtrl;
  late DateTime _selectedDate;
  late CategoryMeta _selectedCategory;
  late String _paymentMethod;

  bool get _isEditing => widget.purchase != null;

  @override
  void initState() {
    super.initState();
    final p = widget.purchase;

    _titleCtrl = TextEditingController(text: p?.merchant?.name ?? '');
    _amountCtrl = TextEditingController(
      text: p != null ? p.totals.amount.toString() : '',
    );
    _currencyCtrl = TextEditingController(text: p?.totals.currency ?? '');
    _selectedDate = p?.purchaseDate ?? DateTime.now();
    _selectedCategory = p?.categorySummary.isNotEmpty == true
        ? CategoryMeta.fromKey(p!.categorySummary.first.name.toLowerCase())
        : CategoryMeta.fromKey('other');
    _paymentMethod = p != null
        ? p.payment.method.name[0].toUpperCase() +
              p.payment.method.name.substring(1)
        : 'Card';
  }

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
    if (_isEditing) {
      // TODO: dispatch update to PurchaseCubit
    } else {
      // TODO: dispatch create to PurchaseCubit
    }
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

            DateField(label: 'Date', value: _selectedDate, onTap: _pickDate),

            const SizedBox(height: 16),

            CategorySelectField(
              selected: _selectedCategory,
              onTap: _pickCategory,
            ),

            const SizedBox(height: 16),

            ChipSelector<String>(
              label: 'Payment Method',
              selected: _paymentMethod,
              options: ['Card', 'Cash', 'Other']
                  .map((opt) => ChipSelectorOption(value: opt, label: opt))
                  .toList(),
              onSelected: (opt) => setState(() => _paymentMethod = opt!),
            ),

            const SizedBox(height: 16),

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
              text: _isEditing ? 'Save Changes' : 'Save Purchase',
              onPressed: _save,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
