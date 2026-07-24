import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'flat_entity.dart';
import 'billing_cycle_entity.dart';
import 'expense_entity.dart';
import 'debt_entity.dart';
import 'activity_entity.dart';

class DashboardState {
  final FlatEntity flat;
  final BillingCycleEntity? activeCycle;
  final List<ExpenseEntity> expenses;
  final List<DebtEntity> debts;
  final List<ActivityEntity> activities;
  final List<FlatMemberEntity> members;

  const DashboardState({
    required this.flat,
    this.activeCycle,
    required this.expenses,
    required this.debts,
    required this.activities,
    required this.members,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardState &&
          runtimeType == other.runtimeType &&
          flat == other.flat &&
          activeCycle == other.activeCycle &&
          // Compare lists
          _listEquals(expenses, other.expenses) &&
          _listEquals(debts, other.debts) &&
          _listEquals(activities, other.activities) &&
          _listEquals(members, other.members);

  @override
  int get hashCode =>
      flat.hashCode ^
      activeCycle.hashCode ^
      expenses.hashCode ^
      debts.hashCode ^
      activities.hashCode ^
      members.hashCode;

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
