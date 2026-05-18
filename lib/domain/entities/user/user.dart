import 'package:electra/domain/entities/subscription/subscription.dart';
import 'package:electra/domain/entities/user/user_settings.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String provider;
  final String? providerId;
  final String? picture;
  final UserSettings? settings;
  final Subscription? subscription;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
    this.providerId,
    this.picture,
    this.settings,
    this.subscription,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? provider,
    String? providerId,
    String? picture,
    UserSettings? settings,
    Subscription? subscription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    provider: provider ?? this.provider,
    providerId: providerId ?? this.providerId,
    picture: picture ?? this.picture,
    settings: settings ?? this.settings,
    subscription: subscription ?? this.subscription,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  User toEntity() => User(
    id: id,
    email: email,
    name: name,
    provider: provider,
    providerId: providerId,
    picture: picture,
    settings: settings?.toEntity(),
    subscription: subscription?.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    provider,
    providerId,
    picture,
    settings,
    subscription,
    createdAt,
    updatedAt,
  ];
}
