import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/debt_entity.dart';

part 'debt_model.g.dart';

@CopyWith()
@JsonSerializable()
class DebtModel {
  final String id;
  final String fromId;
  final String fromName;
  final String toId;
  final String toName;
  final double amount;
  final bool isSettled;

  const DebtModel({
    required this.id,
    required this.fromId,
    required this.fromName,
    required this.toId,
    required this.toName,
    required this.amount,
    required this.isSettled,
  });

  factory DebtModel.fromEntity(DebtEntity entity) {
    return DebtModel(
      id: entity.id,
      fromId: entity.fromId,
      fromName: entity.fromName,
      toId: entity.toId,
      toName: entity.toName,
      amount: entity.amount,
      isSettled: entity.isSettled,
    );
  }

  DebtEntity toEntity() {
    return DebtEntity(
      id: id,
      fromId: fromId,
      fromName: fromName,
      toId: toId,
      toName: toName,
      amount: amount,
      isSettled: isSettled,
    );
  }

  factory DebtModel.fromJson(Map<String, dynamic> json) =>
      _$DebtModelFromJson(json);

  Map<String, dynamic> toJson() => _$DebtModelToJson(this);

  factory DebtModel.fromMap(Map<String, dynamic> map, String id) {
    return DebtModel.fromJson({'id': id, ...map});
  }

  Map<String, dynamic> toMap() => toJson();
}
