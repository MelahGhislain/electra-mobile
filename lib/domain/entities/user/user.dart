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
