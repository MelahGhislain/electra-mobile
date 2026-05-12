import 'package:electra/core/configs/fonts.dart';
import 'package:electra/domain/entities/purchase/purchase.dart';
import 'package:electra/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpendingDetailReceiptSection extends StatelessWidget {
  final Receipt? receipt;
  final VoidCallback? onView;

  const SpendingDetailReceiptSection({super.key, this.receipt, this.onView});

  bool get _hasReceipt => receipt != null && receipt!.imageUrl != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: _hasReceipt
          ? _ReceiptPresent(receipt: receipt!, onView: onView)
          : _ReceiptAbsent(),
    );
  }
}

class _ReceiptPresent extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback? onView;

  const _ReceiptPresent({required this.receipt, this.onView});

  String _formatUploadDate(BuildContext context, DateTime? d) {
    final l = AppLocalizations.of(context);

    if (d == null) return l.uploadedProcessed('');

    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMd(locale).format(d);

    return l.uploadedProcessed(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Icon(
              Icons.receipt_outlined,
              size: 22,
              color: theme.iconTheme.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.name ?? l.receipt,
                  style: const TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatUploadDate(context, receipt.uploadedAt),
                  style: const TextStyle(fontSize: AppFontSize.xs),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onView,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: AppFontSize.sm,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 5),
                  Text(
                    l.view,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptAbsent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: theme.dividerColor),
            ),
            child: const Icon(Icons.receipt_long_outlined, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l.noReceiptAdded,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
