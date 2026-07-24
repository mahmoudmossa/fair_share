import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/features/new_flat/data/models/flat_member_dto.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_cost.dart';
import 'package:fair_share/features/new_flat/domain/use_cases/calculate_settlements.dart';
import '../../domain/entities/dashboard_state.dart';
import '../models/flat_model.dart';
import '../models/billing_cycle_model.dart';
import '../models/expense_model.dart';
import '../models/debt_model.dart';
import '../models/activity_model.dart';
import 'dashboard_remote_data_source.dart';

part 'dashboard_remote_data_source_impl.g.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore _firestore;

  DashboardRemoteDataSourceImpl(this._firestore);

  String _getMonthId(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  String _getMonthNameFormatted(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  @override
  Stream<DashboardState?> watchDashboardState(String flatId) {
    final controller = StreamController<DashboardState?>();

    FlatModel? latestFlat;
    BillingCycleModel? latestCycle;
    List<ExpenseModel> latestExpenses = [];
    List<DebtModel> latestDebts = [];
    List<ActivityModel> latestActivities = [];
    List<FlatMemberEntity> latestMembers = [];

    void emitLatest() {
      if (latestFlat != null && !controller.isClosed) {
        // Calculate debts dynamically on the fly
        final List<FlatCostEntity> flatCosts = latestExpenses.map((e) => FlatCostEntity(
          title: e.title,
          amount: e.amount,
          recurrenceType: e.recurrence,
          payerId: e.payerId,
          payerName: e.payerName,
        )).toList();

        final calculatedDebts = SettlementCalculator.calculateDebts(
          members: latestMembers,
          costs: flatCosts,
        );

        // Match the settled status of each debt by matching the pair-wise ID (fromId_toId)
        // with the list of settled debts from the DB
        final settledDebtIds = latestDebts
            .where((d) => d.isSettled)
            .map((d) => d.id)
            .toSet();

        final updatedDebts = calculatedDebts.map((d) {
          final isSettled = settledDebtIds.contains(d.id);
          return DebtModel(
            id: d.id,
            fromId: d.fromId,
            fromName: d.fromName,
            toId: d.toId,
            toName: d.toName,
            amount: d.amount,
            isSettled: isSettled,
          );
        }).toList();

        // Resolve active billing cycle dynamically if it's missing or out of sync
        final now = DateTime.now();
        final currentMonthId = _getMonthId(now);
        
        final totalCosts = latestExpenses.fold(0.0, (total, exp) => total + exp.amount);
        final settledCount = updatedDebts.where((d) => d.isSettled).length;
        final totalCount = updatedDebts.length;
        double percentage = 85.0;
        if (totalCount > 0) {
          percentage = 85.0 + (15.0 * (settledCount / totalCount));
        }

        final activeCycle = latestCycle ?? BillingCycleModel(
          id: currentMonthId,
          monthName: _getMonthNameFormatted(now),
          status: 'draft',
          totalCosts: totalCosts,
          settledPercentage: percentage,
        );

        controller.add(
          DashboardState(
            flat: latestFlat!,
            activeCycle: activeCycle,
            expenses: latestExpenses.map((e) => e.toEntity()).toList(),
            debts: updatedDebts,
            activities: latestActivities,
          ),
        );
      }
    }

    final flatSub = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .snapshots()
        .listen(
          (snap) {
            if (snap.exists && snap.data() != null) {
              latestFlat = FlatModel.fromMap(snap.data()!, snap.id);
              emitLatest();
            } else {
              latestFlat = null;
              if (!controller.isClosed) controller.add(null);
            }
          },
          onError: (err) {
            if (!controller.isClosed) controller.addError(err);
          },
        );

    final now = DateTime.now();
    final currentMonthId = _getMonthId(now);

    final cycleSub = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.billingCycles)
        .doc(currentMonthId)
        .snapshots()
        .listen((snap) {
          if (snap.exists && snap.data() != null) {
            latestCycle = BillingCycleModel.fromMap(snap.data()!, snap.id);
          } else {
            latestCycle = null;
          }
          emitLatest();
        }, onError: (err) {});

    final expensesSub = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .snapshots()
        .listen((snap) {
          latestExpenses = snap.docs
              .map((d) => ExpenseModel.fromMap(d.data(), d.id))
              .toList();
          // Sort expenses by date descending
          latestExpenses.sort((a, b) => b.date.compareTo(a.date));
          emitLatest();
        }, onError: (err) {});

    final debtsSub = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.debts)
        .snapshots()
        .listen((snap) {
          latestDebts = snap.docs
              .map((d) => DebtModel.fromMap(d.data(), d.id))
              .toList();
          emitLatest();
        }, onError: (err) {});

    final activitiesSub = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.activities)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots()
        .listen((snap) {
          latestActivities = snap.docs
              .map((d) => ActivityModel.fromMap(d.data(), d.id))
              .toList();
          emitLatest();
        }, onError: (err) {});

    final membersSub = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.members)
        .snapshots()
        .listen((snap) {
          latestMembers = snap.docs
              .map((d) => FlatMemberDto.fromJson(d.data()).toEntity())
              .toList();
          emitLatest();
        }, onError: (err) {});

    controller.onCancel = () {
      flatSub.cancel();
      cycleSub.cancel();
      expensesSub.cancel();
      debtsSub.cancel();
      activitiesSub.cancel();
      membersSub.cancel();
    };

    return controller.stream;
  }

  @override
  Future<void> addExpense(
    String flatId,
    String title,
    double amount,
    String payerId,
    String payerName,
    String category,
  ) async {
    // Add expense doc
    final expRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .doc();
    await expRef.set(
      ExpenseModel(
        id: expRef.id,
        title: title,
        payerName: payerName,
        amount: amount,
        payerId: payerId,
        date: DateTime.now(),
        isDisputed: false,
      ).toMap(),
    );

    // Log Activity
    final actRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.activities)
        .doc();
    await actRef.set(
      ActivityModel(
        id: actRef.id,
        userId: payerId,
        userName: payerName,
        action: 'added expense "$title" of ${amount.toStringAsFixed(2)}€.',
        timestamp: DateTime.now(),
      ).toMap(),
    );

    // Update Billing Cycle Total Cost
    final now = DateTime.now();
    final currentMonthId = _getMonthId(now);
    final cycleRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.billingCycles)
        .doc(currentMonthId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(cycleRef);
      if (snapshot.exists && snapshot.data() != null) {
        final currentTotal =
            (snapshot.data()![FirestoreConstants.totalCosts] as num?)
                ?.toDouble() ??
            0.0;
        transaction.update(cycleRef, {
          FirestoreConstants.totalCosts: currentTotal + amount,
        });
      } else {
        transaction.set(cycleRef, {
          'monthName': _getMonthNameFormatted(now),
          'status': 'draft',
          'totalCosts': amount,
          'settledPercentage': 85.0,
        });
      }
    });
  }

  @override
  Future<void> settleDebt(
    String flatId,
    String debtId,
    String userId,
    String userName,
  ) async {
    final debtRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.debts)
        .doc(debtId);

    await debtRef.set({
      FirestoreConstants.isSettled: true,
    }, SetOptions(merge: true));

    // Log Activity
    final actRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.activities)
        .doc();
    await actRef.set(
      ActivityModel(
        id: actRef.id,
        userId: userId,
        userName: userName,
        action: 'settled a debt.',
        timestamp: DateTime.now(),
      ).toMap(),
    );

    // Recalculate Settled Percentage of Billing Cycle
    final debtsSnap = await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.debts)
        .get();

    final allDebts = debtsSnap.docs
        .map((d) => DebtModel.fromMap(d.data(), d.id))
        .toList();
    final settledCount = allDebts.where((d) => d.isSettled).length;
    final totalCount = allDebts.length;

    // Default starts at 85% settled. If 1/2 is settled, let's show 92.5%, if 2/2 is settled show 100%
    double percentage = 85.0;
    if (totalCount > 0) {
      percentage = 85.0 + (15.0 * (settledCount / totalCount));
    }

    final now = DateTime.now();
    final currentMonthId = _getMonthId(now);
    final cycleRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.billingCycles)
        .doc(currentMonthId);
    await cycleRef.set({
      FirestoreConstants.settledPercentage: percentage,
    }, SetOptions(merge: true));
  }

  @override
  Future<String?> getUserFlatId(String userId) async {
    final snap = await _firestore
        .collection(FirestoreConstants.users)
        .doc(userId)
        .get();
    if (snap.exists && snap.data() != null) {
      return snap.data()![FirestoreConstants.flatId] as String?;
    }
    return null;
  }
}

@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(Ref ref) {
  return DashboardRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}
