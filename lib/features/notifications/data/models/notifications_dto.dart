import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notifications_entity.dart';
part 'notifications_dto.g.dart';

@JsonSerializable()
class NotificationsDto extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String type;
  final bool isRead;

  const NotificationsDto({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });

  NotificationsEntity toEntity() {
    return NotificationsEntity(
      id: id,
      title: title,
      body: body,
      type: type,
      isRead: isRead,
    );
  }

  factory NotificationsDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsDtoToJson(this);

  factory NotificationsDto.fromEntity(NotificationsEntity entity) {
    return NotificationsDto(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      timestamp: DateTime.now(),
      type: entity.type,
      isRead: entity.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, body, timestamp, type, isRead];
}
