import 'dart:async';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

/// Thin wrapper around currency_picker's showCurrencyPicker.
/// Returns the selected currency code string (e.g. 'USD', 'EUR')
/// or null if the user dismissed without selecting.
class CurrencyBottomSheet {
  static Future<Currency?> show(
    BuildContext context, {
    String? currentCode,
  }) async {
    final completer = Completer<Currency?>();
    final theme = Theme.of(context);

    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      showSearchField: true,
      // Highlight the user's current currency at the top
      favorite: currentCode != null ? [currentCode] : [],
      theme: CurrencyPickerThemeData(
        flagSize: 22,
        bottomSheetHeight: MediaQuery.sizeOf(context).height * 0.75,
        inputDecoration: InputDecoration(
          hintText: 'Search currency...',
          hintStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: theme.iconTheme.color),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.dividerColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      onSelect: (Currency currency) {
        completer.complete(currency);
      },
    );

    return completer.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () => null,
    );
  }
}