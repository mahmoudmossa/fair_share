import 'package:equatable/equatable.dart';

class Occupant extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? userId;
  final String? invitationCode;
  final String? flatId;

  const Occupant({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.userId,
    this.invitationCode,
    this.flatId,
  });

  Occupant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? userId,
    String? invitationCode,
    String? flatId,
  }) {
    return Occupant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userId: userId ?? this.userId,
      invitationCode: invitationCode ?? this.invitationCode,
      flatId: flatId ?? this.flatId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        userId,
        invitationCode,
        flatId,
      ];
}

