import 'dart:convert';

class NotificationModel {
  final int id;
  final String notificationType;
  final String title;
  final String message;
  final String referenceId;
  final String referenceModel;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.message,
    required this.referenceId,
    required this.referenceModel,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      notificationType: json['notification_type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      referenceId: json['reference_id'] as String,
      referenceModel: json['reference_model'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_type': notificationType,
      'title': title,
      'message': message,
      'reference_id': referenceId,
      'reference_model': referenceModel,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

List<NotificationModel> notificationFromJson(String str) =>
    List<NotificationModel>.from(
      json.decode(str).map((x) => NotificationModel.fromJson(x)),
    );
