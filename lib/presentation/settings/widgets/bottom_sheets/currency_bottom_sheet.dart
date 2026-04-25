import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/text_fields/radio_option_list.dart';
import 'package:flutter/material.dart';

enum AppCurrency { usd, eur, gbp, jpy, cad, aud, chf, cny, inr, brl }

extension AppCurrencyExtension on AppCurrency {
  String get label {
    return switch (this) {
      AppCurrency.usd => 'US Dollar',
      AppCurrency.eur => 'Euro',
      AppCurrency.gbp => 'British Pound',
      AppCurrency.jpy => 'Japanese Yen',
      AppCurrency.cad => 'Canadian Dollar',
      AppCurrency.aud => 'Australian Dollar',
      AppCurrency.chf => 'Swiss Franc',
      AppCurrency.cny => 'Chinese Yuan',
      AppCurrency.inr => 'Indian Rupee',
      AppCurrency.brl => 'Brazilian Real',
    };
  }

  String get code {
    return switch (this) {
      AppCurrency.usd => 'USD',
      AppCurrency.eur => 'EUR',
      AppCurrency.gbp => 'GBP',
      AppCurrency.jpy => 'JPY',
      AppCurrency.cad => 'CAD',
      AppCurrency.aud => 'AUD',
      AppCurrency.chf => 'CHF',
      AppCurrency.cny => 'CNY',
      AppCurrency.inr => 'INR',
      AppCurrency.brl => 'BRL',
    };
  }

  String get symbol {
    return switch (this) {
      AppCurrency.usd => '\$',
      AppCurrency.eur => '€',
      AppCurrency.gbp => '£',
      AppCurrency.jpy => '¥',
      AppCurrency.cad => 'C\$',
      AppCurrency.aud => 'A\$',
      AppCurrency.chf => 'CHF',
      AppCurrency.cny => '¥',
      AppCurrency.inr => '₹',
      AppCurrency.brl => 'R\$',
    };
  }
}

class CurrencyBottomSheet {
  static Future<AppCurrency?> show(BuildContext context, AppCurrency current) {
    return AppBottomSheet.show<AppCurrency>(
      context,
      title: 'Currency',
      icon: Icons.folder_outlined,
      child: RadioOptionList<AppCurrency>(
        selectedValue: current,
        onSelected: (_) {},
        options: AppCurrency.values
            .map(
              (c) => RadioOption(
                value: c,
                label: c.label,
                subtitle: '${c.code} · ${c.symbol}',
              ),
            )
            .toList(),
      ),
    );
  }
}
