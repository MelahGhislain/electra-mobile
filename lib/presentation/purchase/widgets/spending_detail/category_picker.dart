import 'package:electra/common/widgets/text_fields/search_bar.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/utils/category_meta.dart';
import 'package:flutter/material.dart';

/// Shows a searchable category picker bottom sheet.
/// Returns the selected [CategoryMeta] or null if dismissed.
Future<CategoryMeta?> showCategoryPicker(
  BuildContext context, {
  String? selectedKey,
}) {
  return showModalBottomSheet<CategoryMeta>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CategoryPickerSheet(selectedKey: selectedKey),
  );
}

class _CategoryPickerSheet extends StatefulWidget {
  final String? selectedKey;
  const _CategoryPickerSheet({this.selectedKey});

  @override
  State<_CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<_CategoryPickerSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _allKeys = [
    'food',
    'transport',
    'housing',
    'bills',
    'subscriptions',
    'shopping',
    'health',
    'entertainment',
    'travel',
    'education',
    'personal',
    'gifts',
    'donations',
    'other',
  ];

  List<CategoryMeta> get _filtered {
    final all = _allKeys.map(CategoryMeta.fromKey).toList();
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all.where((m) => m.label.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──────────────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ── Header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.grid_view_rounded,
                  color: theme.iconTheme.color,
                  size: AppFontSize.xl,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Select category',
                  style: TextStyle(
                    fontSize: AppFontSize.lg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // ── Search field ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppSearchBar(
              hintText: 'Search categories...',
              initialValue: _searchCtrl.text,
              onChanged: (v) => setState(() => _query = v),
              onClear: () => setState(() => _query = ''),
            ),
          ),

          const SizedBox(height: 12),

          // ── List ─────────────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 40,
                          color: AppColors.lightTextSecondary.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No categories found for "$_query"',
                          style: const TextStyle(fontSize: AppFontSize.sm),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 8),
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 20, endIndent: 20),
                    itemBuilder: (_, i) {
                      final meta = filtered[i];
                      final isSelected =
                          meta.label.toLowerCase() ==
                          widget.selectedKey?.toLowerCase();
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: meta.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(meta.icon, color: meta.color, size: 18),
                        ),
                        title: Text(
                          meta.label,
                          style: TextStyle(
                            fontSize: isSelected
                                ? AppFontSize.md
                                : AppFontSize.sm,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: theme.iconTheme.color,
                                size: AppFontSize.xxl,
                              )
                            : null,
                        onTap: () => Navigator.pop(context, meta),
                      );
                    },
                  ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
