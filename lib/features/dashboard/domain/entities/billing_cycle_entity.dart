class BillingCycleEntity {
  final String id;
  final String monthName;
  final String status; // 'draft' | 'published'
  final double totalCosts;
  final double settledPercentage;

  const BillingCycleEntity({
    required this.id,
    required this.monthName,
    required this.status,
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
          status == other.status &&
          totalCosts == other.totalCosts &&
          settledPercentage == other.settledPercentage;

  @override
  int get hashCode =>
      id.hashCode ^
      monthName.hashCode ^
      status.hashCode ^
      totalCosts.hashCode ^
      settledPercentage.hashCode;
}
