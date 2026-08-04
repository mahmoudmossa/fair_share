import 'package:equatable/equatable.dart';

class YearlyCostSummaryEntity extends Equatable {
  final int year;
  final double totalAmount;
  final Map<String, double> categoryBreakdown;

  const YearlyCostSummaryEntity({
    required this.year,
    required this.totalAmount,
    required this.categoryBreakdown,
  });

  @override
  List<Object?> get props => [year, totalAmount, categoryBreakdown];
}
