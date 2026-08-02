import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/core/utils/monthly_history_helper.dart';
import 'package:fair_share/features/new_flat/data/models/flat_member_dto.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_cost.dart';
import 'package:fair_share/features/new_flat/domain/use_cases/calculate_settlements.dart';
import '../../domain/entities/dashboard_state.dart';
import '../../domain/entities/debt_entity.dart';
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

        // Match settled status of each pair (fromId_toId) with stored debts in Firestore
        final Map<String, bool> settledMap = {
          for (final d in latestDebts) '${d.fromId}_${d.toId}': d.isSettled,
        };

        final List<DebtModel> displayDebts = calculatedDebts.map((d) {
          final pairKey = '${d.fromId}_${d.toId}';
          final isSettled = settledMap[pairKey] ?? false;
          return DebtModel.fromEntity(d).copyWith(isSettled: isSettled);
        }).toList();

        // Resolve active billing cycle dynamically if it's missing or out of sync
        final now = DateTime.now();
        final currentMonthId = _getMonthId(now);
        
        final totalCosts = latestExpenses.fold(0.0, (total, exp) => total + exp.amount);
        final settledCount = displayDebts.where((d) => d.isSettled).length;
        final totalCount = displayDebts.length;
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
            debts: displayDebts.map((d) => d.toEntity()).toList(),
            activities: latestActivities,
            members: latestMembers,
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
    ExpenseModel expense,
  ) async {
    // Add expense doc
    final expRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .doc(expense.id.isEmpty ? null : expense.id);
    final modelToSave = expense.copyWith(id: expRef.id);
    await expRef.set(modelToSave.toJson());

    // Log Activity
    final actRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.activities)
        .doc();
    await actRef.set(
      ActivityModel(
        id: actRef.id,
        userId: expense.payerId,
        userName: expense.payerName,
        action:
            'added expense "${expense.title}" of ${expense.amount.toStringAsFixed(2)}€.',
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
          FirestoreConstants.totalCosts: currentTotal + expense.amount,
        });
      } else {
        transaction.set(cycleRef, {
          'monthName': _getMonthNameFormatted(now),
          'status': 'draft',
          'totalCosts': expense.amount,
          'settledPercentage': 85.0,
        });
      }
    });

    // Recalculate member debt matrix amounts and reset isSettled to false
    await _recalculateAndSaveDebts(flatId);

    // Recalculate billing cycle settled percentage
    await _recalculateBillingCycleSettlement(flatId);

    // Keep the monthly history summary in sync
    await upsertMonthlyHistory(_firestore, flatId);
  }

  /// Private helper to recalculate debts after costs/expenses change,
  /// reset `isSettled` to `false` for all debt matrix items, and update Firestore.
  Future<void> _recalculateAndSaveDebts(String flatId) async {
    final membersSnap = await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.members)
        .get();

    final members = membersSnap.docs.map<FlatMemberEntity>((d) {
      return FlatMemberDto.fromJson(d.data()).toEntity();
    }).toList();

    final expensesSnap = await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .get();

    final costs = expensesSnap.docs.map<FlatCostEntity>((d) {
      final model = ExpenseModel.fromMap(d.data(), d.id);
      return FlatCostEntity(
        title: model.title,
        amount: model.amount,
        recurrenceType: model.recurrence,
        payerId: model.payerId,
        payerName: model.payerName,
      );
    }).toList();

    final calculatedDebts = SettlementCalculator.calculateDebts(
      members: members,
      costs: costs,
    );

    // Delete existing debt documents in wgs/{flatId}/debts
    final debtsRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.debts);

    final existingDebtsSnap = await debtsRef.get();
    final batch = _firestore.batch();
    for (final doc in existingDebtsSnap.docs) {
      batch.delete(doc.reference);
    }

    // Save newly calculated debts (all reset to isSettled = false)
    for (final debt in calculatedDebts) {
      final model = DebtModel.fromEntity(debt).copyWith(isSettled: false);
      final docRef = debtsRef.doc(model.id);
      batch.set(docRef, model.toJson());
    }
    await batch.commit();
  }

  /// Private helper to update the billing cycle settled percentage.
  Future<void> _recalculateBillingCycleSettlement(String flatId) async {
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

    await _recalculateBillingCycleSettlement(flatId);
  }

  @override
  Future<void> setFlatDebts(String flatId, List<DebtEntity> debts) async {
    final batch = _firestore.batch();
    final debtsRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.debts);

    for (final debt in debts) {
      final docRef = debtsRef.doc(debt.id);
      final model = DebtModel(
        id: debt.id,
        fromId: debt.fromId,
        fromName: debt.fromName,
        toId: debt.toId,
        toName: debt.toName,
        amount: debt.amount,
        isSettled: debt.isSettled,
      );
      batch.set(docRef, model.toMap(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  @override
  Stream<List<DebtEntity>> watchFlatDebts(String flatId) {
    return _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.debts)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((d) => DebtModel.fromMap(d.data(), d.id).toEntity())
          .toList();
    });
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
