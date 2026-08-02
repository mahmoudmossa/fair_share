import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final String id;
  final String email;
  final String? flatId;

  const UserDto({
    required this.id,
    required this.email,
    this.flatId,
  });

  factory UserDto.fromEntity(UserEntity entity) {
    return UserDto(
      id: entity.id,
      email: entity.email,
      flatId: entity.flatId,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      flatId: flatId,
    );
  }

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
