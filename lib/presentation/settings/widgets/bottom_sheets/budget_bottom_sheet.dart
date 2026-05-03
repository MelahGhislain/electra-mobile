import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/text_fields/chip_selector.dart';
import 'package:electra/common/widgets/text_fields/text_field.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/user/bloc/user_cubit.dart';
import 'package:electra/presentation/user/bloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetBottomSheet {
  static Future<bool> show(
    BuildContext context, {
    required String userId,
    double? currentBudget,
  }) async {
    final result = await AppBottomSheet.show<bool>(
      context,
      title: 'Monthly Budget',
      icon: Icons.wallet_rounded,
      maxHeightPct: 0.85,
      child: BlocProvider.value(
        value: context.read<UserCubit>(),
        child: _BudgetSheetBody(userId: userId, currentBudget: currentBudget),
      ),
    );
    return result ?? false;
  }
}

class _BudgetSheetBody extends StatefulWidget {
  final String userId;
  final double? currentBudget;

  const _BudgetSheetBody({required this.userId, this.currentBudget});

  @override
  State<_BudgetSheetBody> createState() => _BudgetSheetBodyState();
}

class _BudgetSheetBodyState extends State<_BudgetSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _budgetCtrl;

  static const _quickAmounts = [500, 1000, 1500, 2000, 3000, 5000];

  @override
  void initState() {
    super.initState();
    _budgetCtrl = TextEditingController(
      text: widget.currentBudget != null && widget.currentBudget! > 0
          ? widget.currentBudget!.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_budgetCtrl.text.trim()) ?? 0;
    await context.read<UserCubit>().updateUserSetting(widget.userId, {
      'monthlyBudget': amount,
    });
    if (context.mounted) Navigator.of(context).pop(true);
  }

  Future<void> _removeBudget(BuildContext context) async {
    await context.read<UserCubit>().updateUserSetting(widget.userId, {
      'monthlyBudget': null,
    });
    if (context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserFailure) {
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
      child: SingleChildScrollView(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subtitle
              const Text(
                'Set a monthly spending limit to stay on track.',
                style: TextStyle(fontSize: AppFontSize.sm),
              ),
              const SizedBox(height: 24),

              AppTextField(
                label: 'Budget Amount',
                hint: 'Enter budget amount',
                controller: _budgetCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                prefixText: '\$  ',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter a budget amount';
                  }
                  final parsed = double.tryParse(v.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid amount greater than 0';
                  }
                  if (parsed > 1000000) {
                    return 'Budget seems too high — please check';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Quick-select chips
              ChipSelector<String>(
                label: 'Quick select',
                selected: _budgetCtrl.text.trim(),
                options: ['500', '1000', '1500', '2000', '2500', '3000', '5000']
                    .map(
                      (amount) =>
                          ChipSelectorOption(value: amount, label: '\$$amount'),
                    )
                    .toList(),
                onSelected: (amount) =>
                    setState(() => _budgetCtrl.text = amount.toString()),
              ),

              const SizedBox(height: 32),

              // Save button
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  final isSaving = state is UserSaving;
                  return Column(
                    children: [
                      MainButton(
                        text: 'Save Budget',
                        width: double.infinity,
                        isLoading: isSaving,
                        onPressed: isSaving ? () {} : () => _save(context),
                      ),

                      // Remove — only shown when budget already set
                      if (widget.currentBudget != null &&
                          widget.currentBudget! > 0) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            onPressed: isSaving
                                ? null
                                : () => _removeBudget(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Remove Budget',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
