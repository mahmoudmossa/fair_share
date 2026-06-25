import 'package:equatable/equatable.dart';

class MemberEntity extends Equatable {
  final String id;
  final String displayName;
  final String role;

  const MemberEntity({
    required this.id,
    required this.displayName,
    required this.role,
  });

  @override
  List<Object?> get props => [id, displayName, role];
}
