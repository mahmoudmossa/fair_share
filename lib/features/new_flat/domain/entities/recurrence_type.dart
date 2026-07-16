// lib/features/dashboard/domain/entities/recurrence_type.dart

enum RecurrenceType {
  monthly,
  specificMonths,
  oneTime;

  static RecurrenceType fromString(String? value) {
    switch (value) {
      case 'monthly':
        return RecurrenceType.monthly;
      case 'specific_months':
        return RecurrenceType.specificMonths;
      case 'one_time':
      default:
        return RecurrenceType.oneTime;
    }
  }

  String toJson() {
    switch (this) {
      case RecurrenceType.monthly:
        return 'monthly';
      case RecurrenceType.specificMonths:
        return 'specific_months';
      case RecurrenceType.oneTime:
        return 'one_time';
    }
  }
}
