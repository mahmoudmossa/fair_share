import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/billing_cycle_entity.dart';

part 'billing_cycle_model.g.dart';

@CopyWith()
@JsonSerializable()
class BillingCycleModel {
  final String id;
  final String? monthName;
  final double totalCosts;
  final double? settledPercentage;

  const BillingCycleModel({
    required this.id,
    this.monthName,
    this.totalCosts = 0.0,
    this.settledPercentage,
  });


  factory BillingCycleModel.fromEntity(BillingCycleEntity entity) {
    return BillingCycleModel(
      id: entity.id,
      monthName: entity.monthName,
      totalCosts: entity.totalCosts,
      settledPercentage: entity.settledPercentage,
    );
  }

  BillingCycleEntity toEntity() {
    return BillingCycleEntity(
      id: id,
      monthName: monthName,
      totalCosts: totalCosts,
      settledPercentage: settledPercentage,
    );
  }

  factory BillingCycleModel.fromJson(Map<String, dynamic> json) =>
      _$BillingCycleModelFromJson(json);

  Map<String, dynamic> toJson() => _$BillingCycleModelToJson(this);

  factory BillingCycleModel.fromMap(Map<String, dynamic> map, String id) {
    return BillingCycleModel.fromJson({'id': id, ...map});
  }

  Map<String, dynamic> toMap() => toJson();
}
