
import 'package:electra/domain/entities/user/user_settings.dart';

class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    required super.currency,
    required super.locale,
    required super.pushNotification,
    required super.accountMode,
    super.monthlyBudget,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      currency: json['currency'],
      locale: json['locale'] ?? 'en-US',
      pushNotification: json['pushNotification'] ?? false,
      accountMode: json['accountMode'],
      monthlyBudget: json['monthlyBudget'] != null
          ? (json['monthlyBudget'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "currency": currency,
      "locale": locale,
      "pushNotification": pushNotification,
      "accountMode": accountMode,
      "monthlyBudget": monthlyBudget,
    };
  }
}