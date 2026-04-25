import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
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
      maxHeight: MediaQuery.of(context).size.height * 0.72,
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
              _SectionLabel('Sort By'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PurchaseSortOption.values.map((opt) {
                  return _FilterChip(
                    label: opt.label,
                    selected: _filter.sort == opt,
                    onTap: () =>
                        setState(() => _filter = _filter.copyWith(sort: opt)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              _SectionLabel('Category'),
              const SizedBox(height: 10),
              widget.availableCategories.isEmpty
                  ? _EmptyOption(label: 'No categories available')
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableCategories.map((cat) {
                        final selected = _filter.category == cat;
                        return _FilterChip(
                          label: cat,
                          selected: selected,
                          onTap: () => setState(
                            () => _filter = selected
                                ? _filter.copyWith(clearCategory: true)
                                : _filter.copyWith(category: cat),
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 24),
              _SectionLabel('Merchant'),
              const SizedBox(height: 10),
              widget.availableMerchants.isEmpty
                  ? _EmptyOption(label: 'No merchants available')
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableMerchants.map((m) {
                        final selected = _filter.merchant == m;
                        return _FilterChip(
                          label: m,
                          selected: selected,
                          onTap: () => setState(
                            () => _filter = selected
                                ? _filter.copyWith(clearMerchant: true)
                                : _filter.copyWith(merchant: m),
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 24),
              _SectionLabel('Date Range'),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickDateRange,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _filter.dateFrom != null
                        ? AppColors.darkBackground.withValues(alpha: 0.06)
                        : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _filter.dateFrom != null
                          ? AppColors.darkBackground
                          : AppColors.dividerLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        size: 18,
                        color: _filter.dateFrom != null
                            ? AppColors.lightText
                            : AppColors.darkTextSecondary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _filter.dateFrom != null
                              ? '${_fmt(_filter.dateFrom!)}  →  ${_fmt(_filter.dateTo!)}'
                              : 'Select date range',
                          style: TextStyle(
                            fontSize: 14,
                            color: _filter.dateFrom != null
                                ? AppColors.lightText
                                : AppColors.darkTextSecondary,
                            fontWeight: _filter.dateFrom != null
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (_filter.dateFrom != null)
                        GestureDetector(
                          onTap: () => setState(
                            () => _filter = _filter.copyWith(clearDate: true),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _apply,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.darkBackground,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _fmt(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.lightText,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.darkBackground
              : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.darkBackground
                : AppColors.dividerLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ),
    );
  }
}

class _EmptyOption extends StatelessWidget {
  final String label;
  const _EmptyOption({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.lightTextSecondary,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
