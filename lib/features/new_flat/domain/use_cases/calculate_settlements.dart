// import 'dart:math';
// import 'package:uuid/uuid.dart';
// import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
// import 'package:fair_share/features/new_flat/domain/entities/flat_cost.dart';

// class SettlementCalculator {
//   static const Uuid _uuid = Uuid();

//   static List<FlatDebtEntity> calculateDebts({
//     required List<FlatMemberEntity> members,
//     required List<FlatCostEntity> costs,
//   }) {
//     if (members.isEmpty) return [];

//     // 1. Calculate total costs and share per person
//     final double totalCosts = costs.fold(0.0, (sum, cost) => sum + cost.amount);
//     final double sharePerPerson = totalCosts / members.length;

//     // 2. Calculate individual balances (paid - share)
//     final Map<String, double> balances = {};
//     for (final member in members) {
//       final double totalPaidByMember = costs
//           .where((cost) => cost.memberName.name == member.name)
//           .fold(0.0, (sum, cost) => sum + cost.amount);
//       balances[member.name] = totalPaidByMember - sharePerPerson;
//     }

//     // 3. Classify members into debtors (owe money) and creditors (receive money)
//     final List<_MemberBalance> debtors = [];
//     final List<_MemberBalance> creditors = [];

//     balances.forEach((name, balance) {
//       if (balance < -0.01) {
//         debtors.add(_MemberBalance(name: name, balance: balance));
//       } else if (balance > 0.01) {
//         creditors.add(_MemberBalance(name: name, balance: balance));
//       }
//     });

//     // Sort: debtors from most negative to least; creditors from most positive to least
//     debtors.sort((a, b) => a.balance.compareTo(b.balance));
//     creditors.sort((a, b) => b.balance.compareTo(a.balance));

//     final List<FlatDebtEntity> debts = [];

//     // 4. Match debtors and creditors (Greedy algorithm)
//     int debtorIdx = 0;
//     int creditorIdx = 0;

//     while (debtorIdx < debtors.length && creditorIdx < creditors.length) {
//       final debtor = debtors[debtorIdx];
//       final creditor = creditors[creditorIdx];

//       final double debtAmount = debtor.balance.abs();
//       final double creditAmount = creditor.balance;

//       final double transferAmount = min(debtAmount, creditAmount);

//       // Create transaction
//       debts.add(
//         FlatDebtEntity(
//           id: _uuid.v4(),
//           fromId: debtor.name, // offline members use name as ID
//           fromName: debtor.name,
//           toId: creditor.name,
//           toName: creditor.name,
//           amount: double.parse(transferAmount.toStringAsFixed(2)),
//           isSettled: false,
//         ),
//       );

//       // Update balances
//       debtor.balance += transferAmount;
//       creditor.balance -= transferAmount;

//       if (debtor.balance.abs() < 0.01) {
//         debtorIdx++;
//       }
//       if (creditor.balance.abs() < 0.01) {
//         creditorIdx++;
//       }
//     }

//     return debts;
//   }
// }

// class _MemberBalance {
//   final String name;
//   double balance;

//   _MemberBalance({required this.name, required this.balance});
// }
