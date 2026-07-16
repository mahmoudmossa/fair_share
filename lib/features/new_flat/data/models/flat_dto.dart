import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flat_dto.g.dart';

@JsonSerializable()
class FlatDto extends Equatable {
  final String id;
  final String name;
  const FlatDto({required this.id, required this.name});
  @override
  List<Object?> get props => [id, name];

  factory FlatDto.fromJson(Map<String, dynamic> json) =>
      _$FlatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FlatDtoToJson(this);
}
