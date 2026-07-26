import 'package:json_annotation/json_annotation.dart';
import 'package:fair_share/features/new_flat/domain/entities/user_role.dart';
import '../../domain/entities/member_entity.dart';

part 'member_model.g.dart';

@JsonSerializable()
class MemberModel {
  final String id;
  final String displayName;

  @JsonKey(unknownEnumValue: UserRole.user)
  final UserRole role;

  const MemberModel({
    required this.id,
    required this.displayName,
    required this.role,
  });

  factory MemberModel.fromEntity(MemberEntity entity) {
    return MemberModel(
      id: entity.id,
      displayName: entity.displayName,
      role: entity.role,
    );
  }

  MemberEntity toEntity() {
    return MemberEntity(
      id: id,
      displayName: displayName,
      role: role,
    );
  }

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

  factory MemberModel.fromMap(Map<String, dynamic> map, String id) {
    return MemberModel.fromJson({'id': id, ...map});
  }

  Map<String, dynamic> toMap() => toJson();
}
