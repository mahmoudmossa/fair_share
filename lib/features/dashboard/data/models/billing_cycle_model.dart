import '../../domain/entities/billing_cycle_entity.dart';

class BillingCycleModel extends BillingCycleEntity {
  const BillingCycleModel({
    required super.id,
    required super.monthName,
    required super.status,
    required super.totalCosts,
    required super.settledPercentage,
  });

  factory BillingCycleModel.fromMap(Map<String, dynamic> map, String id) {
    return BillingCycleModel(
      id: id,
      monthName: map['monthName'] as String? ?? '',
      status: map['status'] as String? ?? 'draft',
      totalCosts: (map['totalCosts'] as num?)?.toDouble() ?? 0.0,
      settledPercentage: (map['settledPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthName': monthName,
      'status': status,
      'totalCosts': totalCosts,
      'settledPercentage': settledPercentage,
    };
  }
}
