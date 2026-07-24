import 'package:equatable/equatable.dart';
import '../../../new_flat/domain/entities/recurrence_type.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String payerId;
  final String payerName;
  final DateTime date;
  final bool isDisputed;
  final String? disputeReason;
  final RecurrenceType recurrence;
  final List<int>? specificMonths;

  const ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.payerId,
    required this.payerName,
    required this.date,
    required this.isDisputed,
    this.disputeReason,
    this.recurrence = RecurrenceType.oneTime,
    this.specificMonths,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    amount,
    payerId,
    payerName,
    date,
    isDisputed,
    disputeReason,
    recurrence,
    specificMonths,
  ];
}
