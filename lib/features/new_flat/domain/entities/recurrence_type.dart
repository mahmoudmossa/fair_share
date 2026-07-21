// lib/features/dashboard/domain/entities/recurrence_type.dart

import 'package:json_annotation/json_annotation.dart';

enum RecurrenceType {
  @JsonValue('monthly')
  monthly,
  @JsonValue('specific_months')
  specificMonths,
  @JsonValue('one_time')
  oneTime,
}
