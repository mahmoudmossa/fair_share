import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/flat_entity.dart';

part 'flat_model.g.dart';

@CopyWith()
@JsonSerializable()
class FlatModel {
  final String id;
  final String name;
  final String invitationCode;
  final String createdBy;
  final String createdByName;

  @JsonKey(defaultValue: 1)
  final int billingCalculationDay;

  const FlatModel({
    required this.id,
    required this.name,
    required this.invitationCode,
    required this.createdBy,
    required this.createdByName,
    this.billingCalculationDay = 1,
  });

  factory FlatModel.fromEntity(FlatEntity entity) {
    return FlatModel(
      id: entity.id,
      name: entity.name,
      invitationCode: entity.invitationCode,
      createdBy: entity.createdBy,
      createdByName: entity.createdByName,
      billingCalculationDay: entity.billingCalculationDay,
    );
  }

  FlatEntity toEntity() {
    return FlatEntity(
      id: id,
      name: name,
      invitationCode: invitationCode,
      createdBy: createdBy,
      createdByName: createdByName,
      billingCalculationDay: billingCalculationDay,
    );
  }

  factory FlatModel.fromJson(Map<String, dynamic> json) =>
      _$FlatModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlatModelToJson(this);

  factory FlatModel.fromMap(Map<String, dynamic> map, String id) {
    return FlatModel.fromJson({'id': id, ...map});
  }

  Map<String, dynamic> toMap() => toJson();
}
