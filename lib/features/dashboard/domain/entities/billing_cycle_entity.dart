class BillingCycleEntity {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingCycleEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          monthName == other.monthName &&
          totalCosts == other.totalCosts &&
          settledPercentage == other.settledPercentage;

  @override
  int get hashCode =>
      id.hashCode ^
      monthName.hashCode ^
      totalCosts.hashCode ^
      settledPercentage.hashCode;
}
