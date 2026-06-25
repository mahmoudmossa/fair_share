import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String action;
  final DateTime timestamp;

  const ActivityEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        action,
        timestamp,
      ];
}
