// // test/unit/features/new_flat/domain/use_cases/calculate_settlements_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:fair_share/features/new_flat/domain/entities/flat_cost.dart';
// import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
// import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';
// import 'package:fair_share/features/new_flat/domain/use_cases/calculate_settlements.dart';

// void main() {
//   group('SettlementCalculator Unit Tests', () {
//     test('should calculate equal split debts correctly among 3 members', () {
//       // Arrange
//       const memberV = FlatMemberEntity(id: 'v_id', name: 'V');
//       const memberA = FlatMemberEntity(id: 'a_id', name: 'A');
//       const memberR = FlatMemberEntity(id: 'r_id', name: 'R');

//       final costs = [
//         const FlatCostEntity(
//           title: 'Electricity',
//           amount: 150.0,
//           recurrenceType: RecurrenceType.monthly,
//           payerId: 'v_id',
//         ),
//         const FlatCostEntity(
//           title: 'Gas',
//           amount: 200.0,
//           recurrenceType: RecurrenceType.monthly,
//           payerId: 'a_id',
//         ),
//         const FlatCostEntity(
//           title: 'Internet',
//           amount: 20.0,
//           recurrenceType: RecurrenceType.monthly,
//           payerId: 'r_id',
//         ),
//       ];

//       // Act
//       final debts = SettlementCalculator.calculateDebts(
//         members: const [memberV, memberA, memberR],
//         costs: costs,
//       );

//       // Assert
//       expect(debts.length, equals(2));
//       final rToA = debts.firstWhere((d) => d.fromId == 'r_id' && d.toId == 'a_id');
//       final rToV = debts.firstWhere((d) => d.fromId == 'r_id' && d.toId == 'v_id');

//       expect(rToA.amount, closeTo(76.66, 0.01));
//       expect(rToV.amount, closeTo(26.67, 0.01));
//     });
//   });
// }
