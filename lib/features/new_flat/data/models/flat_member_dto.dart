import 'package:json_annotation/json_annotation.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';

part 'flat_member_dto.g.dart';

@JsonSerializable()
class FlatMemberDto {
  final String id;
  final String name;
  final String? userId;

  const FlatMemberDto({required this.id, required this.name, this.userId});

  factory FlatMemberDto.fromEntity(FlatMemberEntity entity) {
    return FlatMemberDto(
      id: entity.id,
      name: entity.name,
      userId: entity.userId,
    );
  }

  FlatMemberEntity toEntity() {
    return FlatMemberEntity(id: id, name: name, userId: userId);
  }

  factory FlatMemberDto.fromJson(Map<String, dynamic> json) =>
      _$FlatMemberDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FlatMemberDtoToJson(this);
}
