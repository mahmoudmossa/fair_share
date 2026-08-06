import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth.dart';

part 'auth_model.g.dart';

@CopyWith()
@JsonSerializable()
class AuthModel {
  final String? data;

  const AuthModel({
    this.data,
  });

  factory AuthModel.fromEntity(Auth entity) {
    return AuthModel(
      data: entity.data,
    );
  }

  Auth toEntity() {
    return Auth(
      data: data,
    );
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}

