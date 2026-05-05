import 'package:electra/domain/entities/subscription/subscription.dart';

class SubscriptionModel {
  final String id;
  final String userId;
  final String plan;
  final String status;
  final String provider;
  final String? providerId;
  final String? productId;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final DateTime? cancelledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionModel({
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

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      plan: json['plan']?.toString() ?? 'FREE',
      status: json['status']?.toString() ?? 'ACTIVE',
      provider: json['provider']?.toString() ?? 'NONE',
      providerId: json['providerId']?.toString(),
      productId: json['productId']?.toString(),
      currentPeriodStart: DateTime.parse(json['currentPeriodStart'] as String),
      currentPeriodEnd: DateTime.parse(json['currentPeriodEnd'] as String),
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Subscription toEntity() {
    return Subscription(
      id: id,
      userId: userId,
      plan: _parsePlan(plan),
      status: _parseStatus(status),
      provider: _parseProvider(provider),
      providerId: providerId,
      productId: productId,
      currentPeriodStart: currentPeriodStart,
      currentPeriodEnd: currentPeriodEnd,
      cancelledAt: cancelledAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static SubscriptionPlan _parsePlan(String v) {
    switch (v.toUpperCase()) {
      case 'PREMIUM':
        return SubscriptionPlan.premium;
      default:
        return SubscriptionPlan.free;
    }
  }

  static SubscriptionStatus _parseStatus(String v) {
    switch (v.toUpperCase()) {
      case 'EXPIRED':
        return SubscriptionStatus.expired;
      case 'CANCELLED':
        return SubscriptionStatus.cancelled;
      case 'PENDING':
        return SubscriptionStatus.pending;
      default:
        return SubscriptionStatus.active;
    }
  }

  static SubscriptionProvider _parseProvider(String v) {
    switch (v.toUpperCase()) {
      case 'APPLE':
        return SubscriptionProvider.apple;
      case 'GOOGLE':
        return SubscriptionProvider.google;
      default:
        return SubscriptionProvider.none;
    }
  }
}
