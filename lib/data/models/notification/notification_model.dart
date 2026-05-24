import 'package:minata/domain/entities/notification/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.body,
    required super.data,
    required super.isRead,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      type: _parseType(json['type']?.toString()),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : {},
      isRead: json['isRead'] as bool? ?? false,
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
    'userId': userId,
    'type': type.name,
    'title': title,
    'body': body,
    'data': data,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    userId: userId,
    type: type,
    title: title,
    body: body,
    data: data,
    isRead: isRead,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static NotificationType _parseType(String? raw) {
    return NotificationType.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => NotificationType.system,
    );
  }
}
