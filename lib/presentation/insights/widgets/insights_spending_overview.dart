import 'package:minata/core/configs/fonts.dart';
import 'package:minata/core/utils/category_meta.dart';
import 'package:minata/domain/entities/insights/insights.dart';
import 'package:minata/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ── View type ─────────────────────────────────────────────────────────────────

enum SpendingOverviewView { categories, merchants, paymentMethods }

extension SpendingOverviewViewExt on SpendingOverviewView {
  String label(AppLocalizations l) {
    switch (this) {
      case SpendingOverviewView.categories:
        return l.categories;
      case SpendingOverviewView.merchants:
        return l.merchants;
      case SpendingOverviewView.paymentMethods:
        return l.paymentMethods;
    }
  }
}

// ── Main widget ───────────────────────────────────────────────────────────────

class InsightsSpendingOverview extends StatefulWidget {
  final List<CategoryBreakdown> categories;
  final List<MerchantBreakdown> merchants;
  final List<PaymentMethodBreakdown> paymentMethods;
  final double total;
  final String currency;
  final SpendingOverviewView view;

  const InsightsSpendingOverview({
    super.key,
    required this.categories,
    required this.merchants,
    required this.paymentMethods,
    required this.total,
    required this.currency,
    this.view = SpendingOverviewView.categories,
  });

  @override
  State<InsightsSpendingOverview> createState() =>
      _InsightsSpendingOverviewState();
}

class _InsightsSpendingOverviewState extends State<InsightsSpendingOverview> {
  late SpendingOverviewView _view;

  @override
  void initState() {
    super.initState();
    _view = widget.view;
  }

  @override
  void didUpdateWidget(InsightsSpendingOverview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view != widget.view) {
      _view = widget.view;
    }
  }

  Color _colorForCategory(CategoryBreakdown cat) =>
      CategoryMeta.fromKey(cat.normalizedName).color;

  // Stable palette for merchants / payment methods (no CategoryMeta mapping)
  static const _palette = [
    Color(0xFF00C896),
    Color(0xFFFF5B5B),
    Color(0xFF6C8EFF),
    Color(0xFFFFB547),
    Color(0xFFB47FFF),
    Color(0xFF38D9D9),
  ];

  Color _paletteColor(int index) => _palette[index % _palette.length];

  // ── Build donut sections ─────────────────────────────────────────────────

  List<PieChartSectionData> _buildSections(ThemeData theme) {
    switch (_view) {
      case SpendingOverviewView.categories:
        return List.generate(widget.categories.length, (i) {
          final cat = widget.categories[i];
          return PieChartSectionData(
            value: cat.percent,
            color: _colorForCategory(cat),
            radius: 32,
            title: cat.percent >= 10
                ? '${cat.percent.toStringAsFixed(0)}%'
                : '',
            titleStyle: TextStyle(
              fontSize: AppFontSize.xs,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          );
        });

      case SpendingOverviewView.merchants:
        final items = widget.merchants;
        final sum = items.fold<double>(0, (s, m) => s + m.amount);
        return List.generate(items.length, (i) {
          final pct = sum > 0 ? (items[i].amount / sum * 100) : 0.0;
          return PieChartSectionData(
            value: pct,
            color: _paletteColor(i),
            radius: 32,
            title: pct >= 10 ? '${pct.toStringAsFixed(0)}%' : '',
            titleStyle: TextStyle(
              fontSize: AppFontSize.xs,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          );
        });

      case SpendingOverviewView.paymentMethods:
        return List.generate(widget.paymentMethods.length, (i) {
          final pm = widget.paymentMethods[i];
          return PieChartSectionData(
            value: pm.percent,
            color: _paletteColor(i),
            radius: 32,
            title: pm.percent >= 10 ? '${pm.percent.toStringAsFixed(0)}%' : '',
            titleStyle: TextStyle(
              fontSize: AppFontSize.xs,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          );
        });
    }
  }

  // ── Build legend rows (top 3) ────────────────────────────────────────────

  Widget _buildLegend(ThemeData theme, NumberFormat fmt) {
    switch (_view) {
      case SpendingOverviewView.categories:
        final displayed = widget.categories.take(3).toList();
        if (displayed.isEmpty) return _emptyLegend(theme);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(displayed.length, (i) {
            final cat = displayed[i];
            return _LegendRow(
              color: _colorForCategory(cat),
              label: cat.name,
              amount: fmt.format(cat.amount),
              percent: '${cat.percent.toStringAsFixed(0)}%',
            );
          }),
        );

      case SpendingOverviewView.merchants:
        final items = widget.merchants.take(3).toList();
        if (items.isEmpty) return _emptyLegend(theme);
        final sum = widget.merchants.fold<double>(0, (s, m) => s + m.amount);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(items.length, (i) {
            final m = items[i];
            final pct = sum > 0 ? (m.amount / sum * 100) : 0.0;
            return _LegendRow(
              color: _paletteColor(i),
              label: m.name,
              amount: fmt.format(m.amount),
              percent: '${pct.toStringAsFixed(0)}%',
            );
          }),
        );

      case SpendingOverviewView.paymentMethods:
        final items = widget.paymentMethods.take(3).toList();
        if (items.isEmpty) return _emptyLegend(theme);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(items.length, (i) {
            final pm = items[i];
            return _LegendRow(
              color: _paletteColor(i),
              label: pm.method,
              amount: fmt.format(pm.amount),
              percent: '${pm.percent.toStringAsFixed(0)}%',
            );
          }),
        );
    }
  }

  Widget _emptyLegend(ThemeData theme) => Center(
    child: Text(
      'No data this period',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall,
    ),
  );

  bool get _isEmpty {
    switch (_view) {
      case SpendingOverviewView.categories:
        return widget.categories.isEmpty;
      case SpendingOverviewView.merchants:
        return widget.merchants.isEmpty;
      case SpendingOverviewView.paymentMethods:
        return widget.paymentMethods.isEmpty;
    }
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SpendingOverviewSheet(
        view: _view,
        categories: widget.categories,
        merchants: widget.merchants,
        paymentMethods: widget.paymentMethods,
        currency: widget.currency,
        colorForCategory: _colorForCategory,
        paletteColor: _paletteColor,
      ),
    );
  }

  String _viewAllLabel(AppLocalizations l) {
    switch (_view) {
      case SpendingOverviewView.categories:
        return l.viewAllCategories;
      case SpendingOverviewView.merchants:
        return 'View all merchants';
      case SpendingOverviewView.paymentMethods:
        return 'View all payment methods';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final symbol = widget.currency == 'USD' ? r'$' : widget.currency;
    final fmt = NumberFormat.currency(symbol: symbol, decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Donut ──────────────────────────────────────────────
              SizedBox(
                width: 152,
                height: 152,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _isEmpty
                        ? PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: 1,
                                  color: theme.dividerColor,
                                  radius: 32,
                                  title: '',
                                ),
                              ],
                              centerSpaceRadius: 44,
                              sectionsSpace: 0,
                            ),
                          )
                        : PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 44,
                              sections: _buildSections(theme),
                            ),
                          ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.total,
                          style: TextStyle(fontSize: AppFontSize.xs),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _compactAmount(widget.total, symbol),
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ── Legend ─────────────────────────────────────────────
              Expanded(child: _buildLegend(theme, fmt)),
            ],
          ),

          // ── View all link ──────────────────────────────────────────
          const SizedBox(height: 8),
          Divider(height: 1, color: theme.dividerColor),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _openBottomSheet(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _viewAllLabel(l),
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.primary,
                  size: AppFontSize.md,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _compactAmount(double value, String symbol) {
    if (value >= 1000) {
      final whole = value.truncate();
      final thousands = whole ~/ 1000;
      final remainder = (whole % 1000).toString().padLeft(3, '0');
      return '$symbol$thousands,$remainder';
    }
    return '$symbol${value.toStringAsFixed(0)}';
  }
}

// ── Legend row ────────────────────────────────────────────────────────────────

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;
  final String percent;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: AppFontSize.xs,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                percent,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: AppFontSize.xs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bottom sheet ──────────────────────────────────────────────────────────────

class _SpendingOverviewSheet extends StatelessWidget {
  final SpendingOverviewView view;
  final List<CategoryBreakdown> categories;
  final List<MerchantBreakdown> merchants;
  final List<PaymentMethodBreakdown> paymentMethods;
  final String currency;
  final Color Function(CategoryBreakdown) colorForCategory;
  final Color Function(int) paletteColor;

  const _SpendingOverviewSheet({
    required this.view,
    required this.categories,
    required this.merchants,
    required this.paymentMethods,
    required this.currency,
    required this.colorForCategory,
    required this.paletteColor,
  });

  String _sheetTitle(AppLocalizations l) {
    switch (view) {
      case SpendingOverviewView.categories:
        return '${l.all} ${l.categories}';
      case SpendingOverviewView.merchants:
        return '${l.all} ${l.merchants}';
      case SpendingOverviewView.paymentMethods:
        return '${l.all} ${l.paymentMethods}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final symbol = currency == 'USD' ? r'$' : currency;
    final fmt = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    final l = AppLocalizations.of(context);

    List<Widget> rows;

    switch (view) {
      case SpendingOverviewView.categories:
        rows = List.generate(categories.length, (i) {
          final cat = categories[i];
          return _SheetRow(
            color: colorForCategory(cat),
            icon: CategoryMeta.fromKey(cat.normalizedName).icon,
            label: cat.name,
            sublabel: '${cat.count} transaction${cat.count == 1 ? '' : 's'}',
            amount: fmt.format(cat.amount),
            percent: cat.percent,
          );
        });
        break;

      case SpendingOverviewView.merchants:
        final sum = merchants.fold<double>(0, (s, m) => s + m.amount);
        rows = List.generate(merchants.length, (i) {
          final m = merchants[i];
          final pct = sum > 0 ? (m.amount / sum * 100) : 0.0;
          return _SheetRow(
            color: paletteColor(i),
            label: m.name,
            sublabel: '${m.count} transaction${m.count == 1 ? '' : 's'}',
            amount: fmt.format(m.amount),
            percent: pct,
          );
        });
        break;

      case SpendingOverviewView.paymentMethods:
        rows = List.generate(paymentMethods.length, (i) {
          final pm = paymentMethods[i];
          return _SheetRow(
            color: paletteColor(i),
            label: pm.method,
            sublabel: '${pm.count} transaction${pm.count == 1 ? '' : 's'}',
            amount: fmt.format(pm.amount),
            percent: pm.percent,
          );
        });
        break;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _sheetTitle(l),
                      style: TextStyle(
                        fontSize: AppFontSize.lg,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: AppFontSize.md,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Divider(height: 1, color: theme.dividerColor),

              // List
              Expanded(
                child: rows.isEmpty
                    ? Center(
                        child: Text(
                          'No data this period',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        itemCount: rows.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: theme.dividerColor.withValues(alpha: 0.5),
                        ),
                        itemBuilder: (_, i) => rows[i],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SheetRow extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final String label;
  final String sublabel;
  final String amount;
  final double percent;

  const _SheetRow({
    required this.color,
    this.icon,
    required this.label,
    required this.sublabel,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              // Color dot / icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: icon != null
                    ? Icon(icon, color: color, size: 18)
                    : Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
              ),

              const SizedBox(width: 12),

              // Label + sublabel
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      sublabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: AppFontSize.xs,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount + percent
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${percent.toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: AppFontSize.xs,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 4,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
