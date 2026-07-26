import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Central utility class for DateTime conversions and Month ID formatting using `intl`.
class DateUtilsConverter {
  const DateUtilsConverter._();

  static final DateFormat _monthFormatter = DateFormat('MMM yyyy');
  static final DateFormat _monthIdFormatter = DateFormat('yyyy-MM');

  /// Converts a JSON value (Firestore Timestamp, ISO String, or dynamic) to a DateTime.
  static DateTime dateFromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.tryParse(json) ?? DateTime.now();
    }
    return DateTime.now();
  }

  /// Converts a DateTime object to a Firestore Timestamp for JSON serialization.
  static dynamic dateToJson(DateTime date) => Timestamp.fromDate(date);

  /// Computes a DateTime object offset by [monthsAgo] from today.
  static DateTime getDateTimeFromOffset(int monthsAgo) {
    final now = DateTime.now();
    return DateTime(now.year, now.month - monthsAgo, 1);
  }

  /// Generates a Firestore document month ID ("YYYY-MM") using DateFormat.
  static String toMonthId(DateTime date) => _monthIdFormatter.format(date);

  /// Formats a "YYYY-MM" monthId string into a user-facing label like "Jul 2026" using DateFormat.
  static String formatMonthLabel(String monthId) {
    final date = _monthIdFormatter.tryParse(monthId);
    if (date == null) return monthId;
    return _monthFormatter.format(date);
  }
}
