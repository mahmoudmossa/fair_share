import 'package:equatable/equatable.dart';

class MonthSummaryEntity extends Equatable {
  final String monthId; // "YYYY-MM"
  final String monthLabel; // "Jul 2026"
  final double total;
  final double myShare;
  final DateTime lockedAt;

  const MonthSummaryEntity({
    required this.monthId,
    required this.monthLabel,
    required this.total,
    required this.myShare,
    required this.lockedAt,
  });

  @override
  List<Object?> get props => [monthId, monthLabel, total, myShare, lockedAt];
}
