import 'package:equatable/equatable.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';

class FlatCostEntity extends Equatable {
  final String title;
  final double amount;
  final RecurrenceType recurrenceType;
  final String payerId;

  const FlatCostEntity({
    required this.title,
    required this.amount,
    required this.recurrenceType,
    required this.payerId,
  });

  @override
  List<Object?> get props => [title, amount, recurrenceType, payerId];
}
