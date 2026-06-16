import 'package:currency_formatter/currency_formatter.dart' as cf;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minata/presentation/settings/blocs/user_cubit.dart';
import 'package:minata/presentation/settings/blocs/user_state.dart';

class CurrencyFormatterScope extends InheritedWidget {
  final String currencyCode;
  final cf.CurrencyFormat _format;

  CurrencyFormatterScope._({
    required this.currencyCode,
    required super.child,
  }) : _format =  cf.CurrencyFormat.fromCode(currencyCode) ??
         cf.CurrencyFormat.fromCode('usd')!;

  /// Format amount respecting symbol position, decimal separator, etc.
  /// USD → $1,234.50  |  XAF → 1.234 FCFA  |  EUR → 1.234,50 €
  String format(double amount) {
    return cf.CurrencyFormatter.format(amount, _format);
  }

  /// Just the symbol
  String get symbol => _format.symbol;

  static CurrencyFormatterScope of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CurrencyFormatterScope>();
    assert(
      result != null,
      'No CurrencyFormatterScope found. Did you add it in app.dart builder?',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(CurrencyFormatterScope oldWidget) {
    return oldWidget.currencyCode != currencyCode;
  }
}

/// Reads currency from UserCubit and provides CurrencyFormatterScope
/// to everything below. Rebuilds only when currency code changes.
class CurrencyProvider extends StatelessWidget {
  final Widget child;
  const CurrencyProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (prev, curr) => _code(context, prev) != _code(context, curr),
      builder: (context, _) {
        final code = context.read<UserCubit>().currentUserSettings?.currency ?? 'USD';
        return CurrencyFormatterScope._(
          currencyCode: code,
          child: child,
        );
      },
    );
  }

  String _code(BuildContext context, UserState state) {
    return context.read<UserCubit>().currentUserSettings?.currency ?? 'USD';
  }
}
