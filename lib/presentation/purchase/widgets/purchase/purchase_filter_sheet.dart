import 'package:electra/presentation/purchase/pages/purchase_filter.dart';
import 'package:flutter/material.dart';

class PurchaseFilterSheet extends StatefulWidget {
  final PurchaseFilter current;
  final List<String> availableCategories;
  final List<String> availableMerchants;

  const PurchaseFilterSheet({
    super.key,
    required this.current,
    required this.availableCategories,
    required this.availableMerchants,
  });

  static Future<PurchaseFilter?> show(
    BuildContext context, {
    required PurchaseFilter current,
    required List<String> categories,
    required List<String> merchants,
  }) {
    return showModalBottomSheet<PurchaseFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PurchaseFilterSheet(
        current: current,
        availableCategories: categories,
        availableMerchants: merchants,
      ),
    );
  }

  @override
  State<PurchaseFilterSheet> createState() => _PurchaseFilterSheetState();
}

class _PurchaseFilterSheetState extends State<PurchaseFilterSheet> {
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
        _filter = _filter.copyWith(
          dateFrom: range.start,
          dateTo: range.end,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Text(
                    'Filter & Sort',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const Spacer(),
                  if (_filter.hasActiveFilters)
                    GestureDetector(
                      onTap: _reset,
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  // ── Sort ──────────────────────────────────────────
                  _SectionLabel('Sort By'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PurchaseSortOption.values.map((opt) {
                      final selected = _filter.sort == opt;
                      return _FilterChip(
                        label: opt.label,
                        selected: selected,
                        onTap: () => setState(() =>
                            _filter = _filter.copyWith(sort: opt)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Category ─────────────────────────────────────
                  _SectionLabel('Category'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.availableCategories.map((cat) {
                      final selected = _filter.category == cat;
                      return _FilterChip(
                        label: cat,
                        selected: selected,
                        onTap: () => setState(() => _filter = selected
                            ? _filter.copyWith(clearCategory: true)
                            : _filter.copyWith(category: cat)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Merchant ──────────────────────────────────────
                  _SectionLabel('Merchant'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.availableMerchants.map((m) {
                      final selected = _filter.merchant == m;
                      return _FilterChip(
                        label: m,
                        selected: selected,
                        onTap: () => setState(() => _filter = selected
                            ? _filter.copyWith(clearMerchant: true)
                            : _filter.copyWith(merchant: m)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Date Range ────────────────────────────────────
                  _SectionLabel('Date Range'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickDateRange,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: _filter.dateFrom != null
                            ? const Color(0xFF1F2937).withOpacity(0.06)
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _filter.dateFrom != null
                              ? const Color(0xFF1F2937)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range_rounded,
                            size: 18,
                            color: _filter.dateFrom != null
                                ? const Color(0xFF1F2937)
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _filter.dateFrom != null
                                ? '${_fmt(_filter.dateFrom!)} → ${_fmt(_filter.dateTo!)}'
                                : 'Select date range',
                            style: TextStyle(
                              fontSize: 14,
                              color: _filter.dateFrom != null
                                  ? const Color(0xFF1F2937)
                                  : Colors.grey.shade400,
                              fontWeight: _filter.dateFrom != null
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          if (_filter.dateFrom != null)
                            GestureDetector(
                              onTap: () => setState(() =>
                                  _filter = _filter.copyWith(clearDate: true)),
                              child: Icon(Icons.close_rounded,
                                  size: 16, color: Colors.grey.shade500),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Apply button
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 0, 20, MediaQuery.of(context).padding.bottom + 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _apply,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2937),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun',
                'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[d.month - 1]} ${d.day}';
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6B7280),
        letterSpacing: 0.5,
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
          color: selected ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFF1F2937)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}
