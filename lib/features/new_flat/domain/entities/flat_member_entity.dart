import 'package:equatable/equatable.dart';

class FlatMemberEntity extends Equatable {
  final String id;
  final String name;
  final String? userId;
  final String? invitationCode;
  final String? photoBase64;

  const FlatMemberEntity({
    required this.id,
    required this.name,
    this.userId,
    this.invitationCode,
    this.photoBase64,
  });

  @override
  List<Object?> get props => [id, name, userId, invitationCode, photoBase64];
}
