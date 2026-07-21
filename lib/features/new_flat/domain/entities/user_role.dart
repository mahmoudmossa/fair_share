import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('user')
  user,
}
