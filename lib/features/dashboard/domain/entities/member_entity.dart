import 'package:equatable/equatable.dart';
import 'package:fair_share/features/new_flat/domain/entities/user_role.dart';

class MemberEntity extends Equatable {
  final String id;
  final String displayName;
  final UserRole role;

  const MemberEntity({
    required this.id,
    required this.displayName,
    required this.role,
  });

  @override
  List<Object?> get props => [id, displayName, role];
}
