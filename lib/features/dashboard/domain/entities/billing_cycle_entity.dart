import 'package:equatable/equatable.dart';

class BillingCycleEntity extends Equatable {
  final String id;
  final String monthName;
  final double totalCosts;
  final double settledPercentage;

  const BillingCycleEntity({
    required this.id,
    required this.monthName,
    required this.totalCosts,
    required this.settledPercentage,
  });

  @override
  List<Object?> get props => [
        id,
        monthName,
        totalCosts,
        settledPercentage,
      ];
}
