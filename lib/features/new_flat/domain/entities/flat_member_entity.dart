import 'package:equatable/equatable.dart';

class FlatMemberEntity extends Equatable {
  final String id;
  final String name;
  final String? userId;
  final String? invitationCode;

  const FlatMemberEntity({
    required this.id,
    required this.name,
    this.userId,
    this.invitationCode,
  });

  @override
  List<Object?> get props => [id, name, userId, invitationCode];
}
