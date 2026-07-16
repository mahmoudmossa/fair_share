import 'package:equatable/equatable.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';

class FlatCostDto extends Equatable {
  final String title;
  final double amount;
  final RecurrenceType recurrenceType;
  final FlatMemberEntity memberName;

  const FlatCostDto({
    required this.title,
    required this.amount,
    required this.recurrenceType,
    required this.memberName,
  });
  @override
  List<Object?> get props => [title, amount, recurrenceType, memberName];
}
