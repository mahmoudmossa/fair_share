import 'package:json_annotation/json_annotation.dart';

enum NotificationType {
  @JsonValue('settle')
  settle,
  @JsonValue('calculationDayChanged')
  calculationDayChanged,
  @JsonValue('costsCalculated')
  costsCalculated,
  @JsonValue('expenseAdded')
  expenseAdded,
  @JsonValue('unknown')
  unknown,
}
