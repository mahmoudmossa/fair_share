import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_cost.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';

part 'flat_cost_dto.g.dart';

@JsonSerializable()
class FlatCostDto {
  final String title;
  final double amount;
  final String payerId;
  final RecurrenceType recurrence;
  final DateTime date;
  final bool isDisputed;

  const FlatCostDto({
    required this.title,
    required this.amount,
    required this.payerId,
    required this.recurrence,
    required this.date,
    this.isDisputed = false,
  });

  factory FlatCostDto.fromEntity(FlatCostEntity entity) {
    return FlatCostDto(
      title: entity.title,
      amount: entity.amount,
      payerId: entity.payerId,
      recurrence: entity.recurrenceType,
      date: DateTime.now(),
    );
  }

  FlatCostEntity toEntity() {
    return FlatCostEntity(
      title: title,
      amount: amount,
      recurrenceType: recurrence,
      payerId: payerId,
    );
  }

  factory FlatCostDto.fromJson(Map<String, dynamic> json) =>
      _$FlatCostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FlatCostDtoToJson(this);
}
