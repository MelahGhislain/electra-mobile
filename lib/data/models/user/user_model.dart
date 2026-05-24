import 'package:minata/data/models/subscription/subscription_model.dart';
import 'package:minata/data/models/user/user_settings_model.dart';
import 'package:minata/domain/entities/user/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.provider,
    super.providerId,
    super.picture,
    super.settings,
    super.subscription,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      provider: json['provider']?.toString() ?? 'email',
      providerId: json['providerId']?.toString(),
      picture: json['picture']?.toString(),
      settings: json['settings'] != null
          ? UserSettingsModel.fromJson(json['settings'] as Map<String, dynamic>)
          : null,
      subscription: json['subscription'] != null
          ? SubscriptionModel.fromJson(
              json['subscription'] as Map<String, dynamic>,
            ).toEntity()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'provider': provider,
    'providerId': providerId,
    'picture': picture,
    'settings': settings is UserSettingsModel
        ? (settings as UserSettingsModel).toJson()
        : null,
    'subscription': subscription is SubscriptionModel
        ? (subscription as SubscriptionModel).toJson()
        : null,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
