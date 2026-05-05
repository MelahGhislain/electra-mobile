import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/text_fields/catetory_selector.dart';
import 'package:electra/common/widgets/text_fields/chip_selector.dart';
import 'package:electra/common/widgets/text_fields/date_field.dart';
import 'package:electra/common/widgets/text_fields/text_field.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_state.dart';
import 'package:electra/presentation/purchase/widgets/spending_detail/category_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPurchaseBottomSheet {
  static Future<void> show(BuildContext context, {Purchase? purchase}) {
    return AppBottomSheet.show(
      context,
      title: purchase == null ? 'Add Purchase' : 'Edit Purchase',
      icon: Icons.receipt_long_outlined,
      maxHeightPct: 0.90,
      child: BlocProvider.value(
        value: context.read<PurchaseCubit>(),
        child: _AddPurchaseBody(purchase: purchase),
      ),
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
        : 'Other';
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

  Map<String, dynamic> _buildBody() {
    return {
      'merchant': {
        'name': _titleCtrl.text.trim(),
        'normalizedName': _titleCtrl.text.trim().toLowerCase(),
      },
      'payment': {'method': _paymentMethod.toLowerCase()},
      'totals': {
        'amount': double.tryParse(_amountCtrl.text.trim()) ?? 0,
        'currency': _currencyCtrl.text.trim().isEmpty
            ? 'USD'
            : _currencyCtrl.text.trim().toUpperCase(),
        'itemCount': 0,
      },
      'purchaseDate': _selectedDate.toUtc().toIso8601String(),
      'dataSource': 'manual',
      'items': [],
      'categorySummary': [
        {
          'name': _selectedCategory.label,
          'total': double.tryParse(_amountCtrl.text.trim()) ?? 0,
          'count': 1,
        },
      ],
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final body = _buildBody();
    final cubit = context.read<PurchaseCubit>();

    if (_isEditing) {
      await cubit.updatePurchase(widget.purchase!.id, body);
    } else {
      await cubit.createPurchase(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<PurchaseCubit, PurchaseState>(
      listenWhen: (prev, curr) =>
          curr is PurchaseCreated ||
          curr is PurchaseLoaded && prev is PurchaseMutating ||
          curr is PurchaseMutationFailure,
      listener: (context, state) {
        if (state is PurchaseCreated ||
            state is PurchaseLoaded &&
                context.read<PurchaseCubit>().state is! PurchaseMutating) {
          Navigator.of(context).pop();
        }
        if (state is PurchaseMutationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
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
        final isSaving = state is PurchaseMutating;

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

                DateField(
                  label: 'Date',
                  value: _selectedDate,
                  onTap: _pickDate,
                ),

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
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter amount'
                            : null,
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
                  onPressed: isSaving ? () {} : _save,
                  isLoading: isSaving,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
