import 'package:equatable/equatable.dart';

class UserSettings extends Equatable {
  final String currency;
  final String locale;
  final bool pushNotification;
  final String accountMode;
  final double? monthlyBudget;

  const UserSettings({
    required this.currency,
    required this.locale,
    required this.pushNotification,
    required this.accountMode,
    this.monthlyBudget,
  });

  @override
  List<Object?> get props => [
        currency,
        locale,
        pushNotification,
        accountMode,
        monthlyBudget,
      ];
}