import 'package:minata/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:minata/common/widgets/buttons/main_button.dart';
import 'package:minata/common/widgets/text_fields/catetory_selector.dart';
import 'package:minata/common/widgets/text_fields/chip_selector.dart';
import 'package:minata/common/widgets/text_fields/date_field.dart';
import 'package:minata/common/widgets/text_fields/text_field.dart';
import 'package:minata/core/utils/category_meta.dart';
import 'package:minata/domain/entities/purchase/purchase.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:minata/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:minata/presentation/purchase/blocs/purchase/purchase_state.dart';
import 'package:minata/presentation/purchase/widgets/spending_detail/category_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPurchaseBottomSheet {
  static Future<void> show(BuildContext context, {Purchase? purchase}) {
    final l = AppLocalizations.of(context);
    return AppBottomSheet.show(
      context,
      title: purchase == null ? l.addPurchase : l.editPurchase,
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
        ? _getPaymentMethod(p.payment.method)
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

  String _getPaymentMethod(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.other:
        return 'other';
    }
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

  List<ChipSelectorOption<String>> methods(AppLocalizations l) {
    return [
      ChipSelectorOption(value: 'card', label: l.card),
      ChipSelectorOption(value: 'cash', label: l.cash),
      ChipSelectorOption(value: 'other', label: l.other),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

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
        print(_paymentMethod);

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
                  label: l.title,
                  hint: 'e.g. Santa lucia',
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l.pleaseEnterName
                      : null,
                ),

                const SizedBox(height: 16),

                DateField(
                  label: l.date,
                  value: _selectedDate,
                  onTap: _pickDate,
                ),

                const SizedBox(height: 16),

                // CategorySelectField(
                //   selected: _selectedCategory,
                //   onTap: _pickCategory,
                // ),

                const SizedBox(height: 16),

                ChipSelector<String>(
                  label: l.paymentMethod,
                  selected: _paymentMethod,
                  options: methods(l),
                  onSelected: (opt) => setState(() => _paymentMethod = opt!),
                ),

                // const SizedBox(height: 16),

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       flex: 2,
                //       child: AppTextField(
                //         controller: _amountCtrl,
                //         label: l.amount,
                //         hint: '0.00',
                //         keyboardType: const TextInputType.numberWithOptions(
                //           decimal: true,
                //         ),
                //         validator: (v) => (v == null || v.trim().isEmpty)
                //             ? l.enterAmount
                //             : null,
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     Expanded(
                //       child: AppTextField(
                //         controller: _currencyCtrl,
                //         label: l.currency,
                //         hint: 'e.g USD',
                //       ),
                //     ),
                //   ],
                // ),

                const SizedBox(height: 28),

                MainButton(
                  text: _isEditing ? l.saveChanges : l.savePurchase,
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
