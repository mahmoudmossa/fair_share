import 'package:equatable/equatable.dart';
import 'notification_type.dart';

class NotificationsEntity extends Equatable {
  const NotificationsEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
  });
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  @override
  List<Object?> get props => [id, title, body, type, isRead];
}
