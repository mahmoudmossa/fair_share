import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fair_share/core/utils/date_utils_converter.dart';
import '../../domain/entities/activity_entity.dart';

part 'activity_model.g.dart';

@CopyWith()
@JsonSerializable()
class ActivityModel {
  final String id;
  final String userId;
  final String userName;
  final String action;

  @JsonKey(
    fromJson: DateUtilsConverter.dateFromJson,
    toJson: DateUtilsConverter.dateToJson,
  )
  final DateTime timestamp;

  const ActivityModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.timestamp,
  });

  factory ActivityModel.fromEntity(ActivityEntity entity) {
    return ActivityModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      action: entity.action,
      timestamp: entity.timestamp,
    );
  }

  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
      userId: userId,
      userName: userName,
      action: action,
      timestamp: timestamp,
    );
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  factory ActivityModel.fromMap(Map<String, dynamic> map, String id) {
    return ActivityModel.fromJson({'id': id, ...map});
  }

  Map<String, dynamic> toMap() => toJson();
}
