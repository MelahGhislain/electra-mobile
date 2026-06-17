import 'package:qleo/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:qleo/common/widgets/buttons/main_button.dart';
import 'package:qleo/common/widgets/text_fields/date_range_field.dart';
import 'package:qleo/common/widgets/text_fields/radio_option_list.dart';
import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/core/configs/theme/app_colors.dart';
import 'package:qleo/domain/entities/purchase/export_purchase.dart';
import 'package:qleo/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:qleo/presentation/purchase/blocs/purchase/purchase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────

class ExportDataBottomSheet {
  static Future<void> show(
    BuildContext context, {
    String? purchaseId,
    double maxHeightPct = 0.92,
  }) {
    // Capture the cubit BEFORE the sheet opens — the sheet's BuildContext
    // is a new route and cannot access providers from the calling route.
    final purchaseCubit = context.read<PurchaseCubit>();

    return AppBottomSheet.show(
      context,
      title: purchaseId != null ? 'Export Purchase' : 'Export Data',
      icon: Icons.download_outlined,
      maxHeightPct: maxHeightPct,
      child: BlocProvider.value(
        value: purchaseCubit,
        child: _ExportDataBody(purchaseId: purchaseId),
      ),
    );
  }
}

// ─────────────────────────────────────────
// BODY
// ─────────────────────────────────────────

class _ExportDataBody extends StatefulWidget {
  final String? purchaseId;
  const _ExportDataBody({this.purchaseId});

  @override
  State<_ExportDataBody> createState() => _ExportDataBodyState();
}

class _ExportDataBodyState extends State<_ExportDataBody> {
  ExportFileEnum _fileType = ExportFileEnum.csv;

  // Date range
  DateTime? _dateFrom;
  DateTime? _dateTo;

  // Data to include toggles
  bool _includeAccount = true;
  bool _includeTransactions = false;
  bool _includeSpendingSummary = false;

  bool _isExporting = false;

  // ── Date range picker ─────────────────────────────────────────────────────

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateFrom != null && _dateTo != null
          ? DateTimeRange(start: _dateFrom!, end: _dateTo!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1F2937),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (range != null) {
      setState(() {
        _dateFrom = range.start;
        _dateTo = range.end;
      });
    }
  }

  // ── Export ─────────────────────────────────────────────────────────────────

  // Replace the _export() placeholder in _ExportDataBodyState

  Future<void> _export() async {
    setState(() => _isExporting = true);

    final export = ExportPurchase(
      format: _fileType,
      purchaseId: widget.purchaseId,
      from: _dateFrom,
      to: _dateTo,
      includeAccountInfo: _includeAccount,
      includeTransactions: _includeTransactions,
      includeSpendingSummary: _includeSpendingSummary,
    );

    await context.read<PurchaseCubit>().exportData(export);

    if (!mounted) return;
    setState(() => _isExporting = false);

    final state = context.read<PurchaseCubit>().state;
    if (state is PurchaseExportFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    } else {
      Navigator.of(context).pop(); // file opened automatically, close sheet
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Subtitle
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Text(
            'Choose your preferences for the data you want to export.',
            style: TextStyle(fontSize: AppFontSize.xs),
          ),
        ),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── File type ──────────────────────────────────────────
                _SectionLabel('File Type'),
                const SizedBox(height: 10),
                _FileTypeCard(
                  selected: _fileType,
                  onChanged: (t) => setState(() => _fileType = t),
                ),

                // ── Date range ─────────────────────────────────────────
                if (widget.purchaseId == null) ...[
                  const SizedBox(height: 20),
                  _SectionLabel('Date Range'),
                  const SizedBox(height: 10),
                  DateRangeField(
                    dateFrom: _dateFrom,
                    dateTo: _dateTo,
                    onTap: _pickDateRange,
                    onClear: () => setState(() => _dateFrom = _dateTo = null),
                    hint: 'Custom Range',
                  ),
                ],
                const SizedBox(height: 20),

                // ── Data to include ────────────────────────────────────
                _SectionLabel('Data to Include'),
                const SizedBox(height: 10),
                _DataIncludeCard(
                  includeAccount: _includeAccount,
                  includeTransactions: _includeTransactions,
                  includeSpendingSummary: _includeSpendingSummary,
                  onAccountChanged: (v) => setState(() => _includeAccount = v),
                  onTransactionsChanged: (v) =>
                      setState(() => _includeTransactions = v),
                  onSpendingSummaryChanged: (v) =>
                      setState(() => _includeSpendingSummary = v),
                ),

                const SizedBox(height: 28),

                // ── Export button + security note ──────────────────────────────
                MainButton(
                  text: 'Export Data',
                  icon: Icon(
                    Icons.logout,
                    size: 18,
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                  ),
                  onPressed: _isExporting ? () {} : _export,
                  isLoading: _isExporting,
                  size: ButtonSize.small,
                  width: double.infinity,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Your data is secure and encrypted',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: AppFontSize.xs,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// FILE TYPE CARD
// ─────────────────────────────────────────

class _FileTypeCard extends StatelessWidget {
  final ExportFileEnum selected;
  final ValueChanged<ExportFileEnum> onChanged;

  const _FileTypeCard({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: RadioOptionList<ExportFileEnum>(
        selectedValue: selected,
        onSelected: onChanged,
        options: [
          RadioOption(
            value: ExportFileEnum.csv,
            label: 'CSV',
            subtitle: 'Best for spreadsheets and data analysis',
          ),

          // Divider(
          //   height: 1,
          //   indent: 0,
          //   endIndent: 0,
          //   color: theme.dividerColor,
          // ),
          RadioOption(
            value: ExportFileEnum.pdf,
            label: 'PDF',
            subtitle: 'Best for reports and sharing',
          ),
          // RadioOption(
          //   value: ExportFileEnum.excel,
          //   label: 'EXCEL',
          //   subtitle: 'Best for spreadsheets and data analysis',
          // ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// DATA TO INCLUDE CARD
// ─────────────────────────────────────────

class _DataIncludeCard extends StatelessWidget {
  final bool includeAccount;
  final bool includeTransactions;
  final bool includeSpendingSummary;
  final ValueChanged<bool> onAccountChanged;
  final ValueChanged<bool> onTransactionsChanged;
  final ValueChanged<bool> onSpendingSummaryChanged;

  const _DataIncludeCard({
    required this.includeAccount,
    required this.includeTransactions,
    required this.includeSpendingSummary,
    required this.onAccountChanged,
    required this.onTransactionsChanged,
    required this.onSpendingSummaryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      _ToggleItem(
        icon: Icons.person_outline_rounded,
        label: 'Account Information',
        subtitle: 'Your profile and account details',
        value: includeAccount,
        onChanged: onAccountChanged,
      ),
      _ToggleItem(
        icon: Icons.attach_money_rounded,
        label: 'Transactions',
        subtitle: 'All your transactions and payments',
        value: includeTransactions,
        onChanged: onTransactionsChanged,
      ),
      _ToggleItem(
        icon: Icons.trending_up_rounded,
        label: 'Spending Summary',
        subtitle: 'Spend insights and analytics',
        value: includeSpendingSummary,
        onChanged: onSpendingSummaryChanged,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isLast = i == items.length - 1;
          return Column(
            children: [
              _DataToggleTile(item: item),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 0,
                  endIndent: 0,
                  color: theme.dividerColor,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ToggleItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
}

class _DataToggleTile extends StatelessWidget {
  final _ToggleItem item;
  const _DataToggleTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(item.icon, size: 22, color: theme.iconTheme.color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: AppFontSize.sm,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(value: item.value, onChanged: item.onChanged),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.8,
      ),
    );
  }
}
