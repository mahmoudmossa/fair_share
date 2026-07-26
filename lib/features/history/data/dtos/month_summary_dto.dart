import 'package:json_annotation/json_annotation.dart';
import 'package:fair_share/core/utils/date_utils_converter.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';

part 'month_summary_dto.g.dart';

@JsonSerializable()
class MonthSummaryDto {
  final String monthId;
  final double total;
  final double myShare;

  @JsonKey(
    fromJson: DateUtilsConverter.dateFromJson,
    toJson: DateUtilsConverter.dateToJson,
  )
  final DateTime lockedAt;

  const MonthSummaryDto({
    required this.monthId,
    required this.total,
    required this.myShare,
    required this.lockedAt,
  });

  MonthSummaryEntity toEntity() {
    return MonthSummaryEntity(
      monthId: monthId,
      monthLabel: DateUtilsConverter.formatMonthLabel(monthId),
      total: total,
      myShare: myShare,
      lockedAt: lockedAt,
    );
  }

  factory MonthSummaryDto.fromEntity(MonthSummaryEntity entity) {
    return MonthSummaryDto(
      monthId: entity.monthId,
      total: entity.total,
      myShare: entity.myShare,
      lockedAt: entity.lockedAt,
    );
  }

  factory MonthSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$MonthSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MonthSummaryDtoToJson(this);

  factory MonthSummaryDto.fromMap(Map<String, dynamic> map, String id) {
    return MonthSummaryDto.fromJson({'monthId': id, ...map});
  }

  Map<String, dynamic> toMap() => toJson();
}
