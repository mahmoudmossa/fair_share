import 'package:equatable/equatable.dart';

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
  final String type;
  final bool isRead;
  @override
  List<Object?> get props => [id, title, body, type, isRead];
}
