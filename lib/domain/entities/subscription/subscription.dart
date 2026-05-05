import 'package:equatable/equatable.dart';

enum SubscriptionPlan { free, premium }

enum SubscriptionStatus { active, expired, cancelled, pending }

enum SubscriptionProvider { apple, google, none }

class Subscription extends Equatable {
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final SubscriptionStatus status;
  final SubscriptionProvider provider;
  final String? providerId;
  final String? productId;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final DateTime? cancelledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Subscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.status,
    required this.provider,
    this.providerId,
    this.productId,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPremium =>
      plan == SubscriptionPlan.premium && status == SubscriptionStatus.active;

  bool get isExpired => status == SubscriptionStatus.expired;

  bool get isCancelled => status == SubscriptionStatus.cancelled;

  @override
  List<Object?> get props => [
    id,
    userId,
    plan,
    status,
    provider,
    providerId,
    productId,
    currentPeriodStart,
    currentPeriodEnd,
    cancelledAt,
  ];
}
