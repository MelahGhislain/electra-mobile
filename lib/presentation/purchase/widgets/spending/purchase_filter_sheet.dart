import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/text_fields/chip_selector.dart';
import 'package:electra/common/widgets/text_fields/date_range_field.dart';
import 'package:electra/presentation/purchase/pages/purchase_filter.dart';
import 'package:flutter/material.dart';

class PurchaseFilterSheet {
  static Future<PurchaseFilter?> show(
    BuildContext context, {
    required PurchaseFilter current,
    required List<String> categories,
    required List<String> merchants,
  }) {
    return AppBottomSheet.show<PurchaseFilter>(
      context,
      title: 'Filter & Sort',
      icon: Icons.tune_rounded,
      maxHeightPct: 0.82,
      child: _PurchaseFilterContent(
        current: current,
        availableCategories: categories,
        availableMerchants: merchants,
      ),
    );
  }
}

class _PurchaseFilterContent extends StatefulWidget {
  final PurchaseFilter current;
  final List<String> availableCategories;
  final List<String> availableMerchants;

  const _PurchaseFilterContent({
    required this.current,
    required this.availableCategories,
    required this.availableMerchants,
  });

  @override
  State<_PurchaseFilterContent> createState() => _PurchaseFilterContentState();
}

class _PurchaseFilterContentState extends State<_PurchaseFilterContent> {
  late PurchaseFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.current;
  }

  void _apply() => Navigator.of(context).pop(_filter);
  void _reset() => setState(() => _filter = const PurchaseFilter());

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _filter.dateFrom != null && _filter.dateTo != null
          ? DateTimeRange(start: _filter.dateFrom!, end: _filter.dateTo!)
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
        _filter = _filter.copyWith(dateFrom: range.start, dateTo: range.end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_filter.hasActiveFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _reset,
                child: const Text(
                  'Reset all',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            children: [
              ChipSelector<PurchaseSortOption>(
                label: 'Sort By',
                selected: _filter.sort,
                options: PurchaseSortOption.values
                    .map(
                      (opt) => ChipSelectorOption(value: opt, label: opt.label),
                    )
                    .toList(),
                onSelected: (opt) =>
                    setState(() => _filter = _filter.copyWith(sort: opt)),
              ),

              const SizedBox(height: 24),

              ChipSelector<String>(
                label: 'Category',
                selected: _filter.category,
                emptyMessage: widget.availableCategories.isEmpty
                    ? 'No categories available'
                    : null,
                options: widget.availableCategories
                    .map((cat) => ChipSelectorOption(value: cat, label: cat))
                    .toList(),
                onSelected: (cat) =>
                    setState(() => _filter = _filter.copyWith(category: cat)),
              ),

              const SizedBox(height: 24),

              ChipSelector<String>(
                label: 'Merchant',
                selected: _filter.merchant,
                emptyMessage: widget.availableMerchants.isEmpty
                    ? 'No merchants available'
                    : null,
                options: widget.availableMerchants
                    .map((m) => ChipSelectorOption(value: m, label: m))
                    .toList(),
                onSelected: (m) =>
                    setState(() => _filter = _filter.copyWith(merchant: m)),
              ),

              const SizedBox(height: 24),

              DateRangeField(
                label: 'Date Range',
                dateFrom: _filter.dateFrom,
                dateTo: _filter.dateTo,
                onTap: _pickDateRange,
                onClear: () =>
                    setState(() => _filter = _filter.copyWith(clearDate: true)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: MainButton(
            text: 'Apply Filters',
            onPressed: _apply,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
