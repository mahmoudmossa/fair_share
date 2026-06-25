import '../../domain/entities/debt_entity.dart';

class DebtModel extends DebtEntity {
  const DebtModel({
    required super.id,
    required super.fromId,
    required super.fromName,
    required super.toId,
    required super.toName,
    required super.amount,
    required super.isSettled,
  });

  factory DebtModel.fromMap(Map<String, dynamic> map, String id) {
    return DebtModel(
      id: id,
      fromId: map['fromId'] as String? ?? '',
      fromName: map['fromName'] as String? ?? '',
      toId: map['toId'] as String? ?? '',
      toName: map['toName'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      isSettled: map['isSettled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromId': fromId,
      'fromName': fromName,
      'toId': toId,
      'toName': toName,
      'amount': amount,
      'isSettled': isSettled,
    };
  }
}
