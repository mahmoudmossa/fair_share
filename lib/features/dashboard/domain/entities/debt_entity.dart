import 'package:equatable/equatable.dart';

class DebtEntity extends Equatable {
  final String id;
  final String fromId;
  final String fromName;
  final String toId;
  final String toName;
  final double amount;
  final bool isSettled;

  const DebtEntity({
    required this.id,
    required this.fromId,
    required this.fromName,
    required this.toId,
    required this.toName,
    required this.amount,
    required this.isSettled,
  });

  @override
  List<Object?> get props => [
        id,
        fromId,
        fromName,
        toId,
        toName,
        amount,
        isSettled,
      ];
}
