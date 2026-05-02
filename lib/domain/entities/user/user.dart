import 'package:electra/domain/entities/user/user_settings.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String provider;
  final String? providerId;
  final UserSettings? settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
    this.providerId,
    this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? provider,
    String? providerId,
    UserSettings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    provider: provider ?? this.provider,
    providerId: providerId ?? this.providerId,
    settings: settings ?? this.settings,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  User toEntity() => User(
    id: id,
    email: email,
    name: name,
    provider: provider,
    providerId: providerId,
    settings: settings?.toEntity(),
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
    settings,
    createdAt,
    updatedAt,
  ];
}
