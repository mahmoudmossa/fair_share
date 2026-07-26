import 'package:equatable/equatable.dart';

/// Params class for monthExpensesProvider.
class MonthExpensesParams extends Equatable {
  const MonthExpensesParams({required this.flatId, required this.monthId});

  final String flatId;
  final String monthId; // "YYYY-MM"

  @override
  List<Object?> get props => [flatId, monthId];
}
