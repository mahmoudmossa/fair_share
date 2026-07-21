import 'package:equatable/equatable.dart';
import 'flat_member_entity.dart';
import 'flat_cost.dart';

class FlatEntity extends Equatable {
  final String id;
  final String name;
  final String invitationCode;
  final String createdBy;
  final String createdByName;
  final List<FlatMemberEntity> members;
  final List<FlatCostEntity> costs;

  const FlatEntity({
    required this.id,
    required this.name,
    required this.invitationCode,
    required this.createdBy,
    required this.createdByName,
    required this.members,
    required this.costs,
  });

  factory FlatEntity.empty() {
    return const FlatEntity(
      id: '',
      name: '',
      invitationCode: '',
      createdBy: '',
      createdByName: '',
      members: [],
      costs: [],
    );
  }

  FlatEntity copyWith({
    String? id,
    String? name,
    String? invitationCode,
    String? createdBy,
    String? createdByName,
    List<FlatMemberEntity>? members,
    List<FlatCostEntity>? costs,
  }) {
    return FlatEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      invitationCode: invitationCode ?? this.invitationCode,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      members: members ?? this.members,
      costs: costs ?? this.costs,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        invitationCode,
        createdBy,
        createdByName,
        members,
        costs,
      ];
}
