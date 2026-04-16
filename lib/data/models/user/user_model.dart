import 'package:electra/domain/entities/user/user.dart';

import 'user_settings_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.provider,
    super.providerId,
    super.settings,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      provider: json['provider'],
      providerId: json['providerId'],
      settings: json['settings'] != null
          ? UserSettingsModel.fromJson(json['settings'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "provider": provider,
      "providerId": providerId,
      "settings": settings is UserSettingsModel
          ? (settings as UserSettingsModel).toJson()
          : null,
    };
  }
}
