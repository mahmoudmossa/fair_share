import 'package:json_annotation/json_annotation.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_entity.dart';

part 'flat_dto.g.dart';

@JsonSerializable()
class FlatDto {
  final String id;
  final String name;
  final String invitationCode;
  final String createdBy;
  final String createdByName;

  const FlatDto({
    required this.id,
    required this.name,
    required this.invitationCode,
    required this.createdBy,
    required this.createdByName,
  });

  factory FlatDto.fromEntity(FlatEntity entity) {
    return FlatDto(
      id: entity.id,
      name: entity.name,
      invitationCode: entity.invitationCode,
      createdBy: entity.createdBy,
      createdByName: entity.createdByName,
    );
  }

  FlatEntity toEntity() {
    return FlatEntity(
      id: id,
      name: name,
      invitationCode: invitationCode,
      createdBy: createdBy,
      createdByName: createdByName,
      members: const [],
      costs: const [],
    );
  }

  factory FlatDto.fromJson(Map<String, dynamic> json) =>
      _$FlatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FlatDtoToJson(this);
}
