import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/config/env_config.dart';
import 'package:fair_share/features/notifications/data/models/notifications_dto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/features/new_flat/data/models/flat_member_dto.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_cost.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';
import 'package:fair_share/features/new_flat/domain/use_cases/calculate_settlements.dart';
import '../../domain/entities/debt_entity.dart';


import '../models/flat_model.dart';
import '../models/billing_cycle_model.dart';
import '../models/expense_model.dart';
import '../models/debt_model.dart';
import '../models/activity_model.dart';
import 'dashboard_remote_data_source.dart';

import 'package:fair_share/features/notifications/domain/entities/notification_type.dart';

part 'dashboard_remote_data_source_impl.g.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore _firestore;

  DashboardRemoteDataSourceImpl(this._firestore);

  String _getMonthId(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  String _getMonthNameFormatted(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  @override
  Stream<FlatModel?> watchFlat(String flatId) {
    return _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .snapshots()
        .map((snap) {
      if (snap.exists && snap.data() != null) {
        return FlatModel.fromMap(snap.data()!, snap.id);
      }
      return null;
    });
  }

  @override
  Stream<List<FlatMemberEntity>> watchFlatMembers(String flatId) {
    return _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.members)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((d) => FlatMemberDto.fromJson(d.data()).toEntity())
          .toList();
    });
  }


  @override
  Stream<BillingCycleModel?> watchActiveBillingCycle(String flatId) {
    final currentMonthId = _getMonthId(DateTime.now());
    return _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.billingCycles)
        .doc(currentMonthId)
        .snapshots()
        .map((snap) {
      if (snap.exists && snap.data() != null) {
        return BillingCycleModel.fromMap(snap.data()!, snap.id);
      }
      return null;
    });
  }

  @override
  Stream<List<ExpenseModel>> watchExpenses(String flatId) {
    return _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .snapshots()
        .map((snap) {
      final expenses = snap.docs
          .map((d) => ExpenseModel.fromMap(d.data(), d.id))
          .toList();
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    });
  }

  @override
  Stream<List<ActivityModel>> watchActivities(String flatId) {
    return _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.activities)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((d) => ActivityModel.fromMap(d.data(), d.id))
          .toList();
    });
  }


  @override
  Future<void> deleteExpense(String flatId, String expenseId) async {
    final expRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .doc(expenseId);

    final docSnap = await expRef.get();
    if (!docSnap.exists) return;

    final data = docSnap.data();
    final amount = (data?['amount'] as num?)?.toDouble() ?? 0.0;
    final title = data?['title'] as String? ?? 'Expense';
    final payerId = data?['payerId'] as String? ?? '';
    final payerName = data?['payerName'] as String? ?? 'Member';

    await expRef.delete();

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
        action: 'deleted expense "$title" of ${amount.toStringAsFixed(2)}€.',
        timestamp: DateTime.now(),
      ).toMap(),
    );

    // Recalculate member debt matrix amounts and reset isSettled to false
    await _recalculateAndSaveDebts(flatId);

    // Recalculate billing cycle settled percentage & update total costs
    await _recalculateBillingCycleSettlement(flatId);
  }

  @override
  Future<void> addExpense(String flatId, ExpenseModel expense) async {
    // Add expense doc
    final expRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .doc(expense.id.isEmpty ? null : expense.id);
    final modelToSave = expense.copyWith(id: expRef.id);
    await expRef.set(modelToSave.toJson());

    final bool isEditMode = expense.id.isNotEmpty;
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
        action: isEditMode
            ? 'edited expense "${expense.title}" to ${expense.amount.toStringAsFixed(2)}€.'
            : 'added expense "${expense.title}" of ${expense.amount.toStringAsFixed(2)}€.',
        timestamp: DateTime.now(),
      ).toMap(),
    );

    // Recalculate member debt matrix amounts and reset isSettled to false
    await _recalculateAndSaveDebts(flatId);

    // Recalculate billing cycle settled percentage & total costs
    await _recalculateBillingCycleSettlement(flatId);

    // Send notification
    await _notifyMembers(
      flatId: flatId,
      title: 'dashboard_notification_expense_added_title',
      body:
          'dashboard_notification_expense_added_body|${expense.payerName}|${expense.title}|${expense.amount.toStringAsFixed(2)}',
      type: NotificationType.expenseAdded,
    );
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

    final expensesSnap = await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .get();

    double monthTotalCosts = 0.0;
    for (final doc in expensesSnap.docs) {
      final model = ExpenseModel.fromMap(doc.data(), doc.id);
      if (model.date.year == now.year && model.date.month == now.month) {
        monthTotalCosts += model.amount;
      }
    }

    final cycleRef = _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.billingCycles)
        .doc(currentMonthId);
    await cycleRef.set({
      FirestoreConstants.settledPercentage: percentage,
      FirestoreConstants.totalCosts: monthTotalCosts,
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

    // Send notification to the receiver (debt toName/toId)
    if (userId != debtId) {
      // Find the debt details first to get the receiver
      final debtSnap = await debtRef.get();
      if (debtSnap.exists && debtSnap.data() != null) {
        final toId = debtSnap.data()!['toId'] as String?;
        if (toId != null) {
          final notifRef = _firestore
              .collection(FirestoreConstants.users)
              .doc(toId)
              .collection(FirestoreConstants.notifications)
              .doc();
          await notifRef.set({
            'id': notifRef.id,
            'title': 'dashboard_notification_settled_title',
            'body': 'dashboard_notification_settled_body|$userName',
            'type': NotificationType.settle.name,
            'timestamp': FieldValue.serverTimestamp(),
            'isRead': false,
          });
        }
      }
    }
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

  @override
  Future<void> updateBillingCalculationDay(String flatId, int day) async {
    await _firestore.collection(FirestoreConstants.wgs).doc(flatId).update({
      FirestoreConstants.billingCalculationDay: day,
    });

    await _notifyMembers(
      flatId: flatId,
      title: 'dashboard_notification_billing_day_title',
      body: 'dashboard_notification_billing_day_body|$day',
      type: NotificationType.calculationDayChanged,
    );
  }

  @override
  Future<void> calculateMonthlyExpensesAndNotify(String flatId) async {
    final now = DateTime.now();
    final currentMonthId = _getMonthId(now);
    final nextMonthDate = DateTime(now.year, now.month + 1, 1);
    final nextMonthId = _getMonthId(nextMonthDate);

    // 1. Fetch flat expenses
    final expensesSnap = await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .get();

    final allExpenses = expensesSnap.docs
        .map((d) => ExpenseModel.fromMap(d.data(), d.id))
        .toList();

    // 2. Fetch members
    final membersSnap = await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.members)
        .get();

    final members = membersSnap.docs
        .map((d) => FlatMemberDto.fromJson(d.data()).toEntity())
        .toList();

    // 3. Filter monthly recurring expenses (catalog templates)
    final monthlyExpenses = allExpenses
        .where((e) => e.recurrence == RecurrenceType.monthly)
        .toList();

    final flatCosts = monthlyExpenses
        .map(
          (e) => FlatCostEntity(
            title: e.title,
            amount: e.amount,
            recurrenceType: e.recurrence,
            payerId: e.payerId,
            payerName: e.payerName,
          ),
        )
        .toList();

    final calculatedDebts = SettlementCalculator.calculateDebts(
      members: members,
      costs: flatCosts,
    );

    final totalCosts = monthlyExpenses.fold(0.0, (acc, e) => acc + e.amount);

    // Save calculated debts into debts collection
    await setFlatDebts(flatId, calculatedDebts);

    // 4. Archive current month cycle summary into Firestore
    final currentTotal = allExpenses
        .where((e) => _getMonthId(e.date) == currentMonthId)
        .fold(0.0, (acc, e) => acc + e.amount);

    await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.billingCycles)
        .doc(currentMonthId)
        .set({
          'monthName': _getMonthNameFormatted(now),
          'totalCosts': currentTotal > 0 ? currentTotal : totalCosts,
          'settledPercentage': 100.0,
        }, SetOptions(merge: true));

    // 5. Add new month instances for recurring catalog expenses starting on nextMonthDate at 00:01
    final newMonthTimestamp = Timestamp.fromDate(
      DateTime(nextMonthDate.year, nextMonthDate.month, 1, 0, 1),
    );
    for (final exp in monthlyExpenses) {
      final existsInNextMonth = allExpenses.any(
        (e) => e.title == exp.title && _getMonthId(e.date) == nextMonthId,
      );
      if (!existsInNextMonth) {
        await _firestore
            .collection(FirestoreConstants.wgs)
            .doc(flatId)
            .collection(FirestoreConstants.expenses)
            .add({
              'title': exp.title,
              'amount': exp.amount,
              'payerId': exp.payerId,
              'payerName': exp.payerName,
              'recurrence': exp.recurrence.name,
              'isDisputed': false,
              FirestoreConstants.timestamp: newMonthTimestamp,
            });
      }
    }

    // 6. Create new billing cycle for next month
    await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.billingCycles)
        .doc(nextMonthId)
        .set({
          'monthName': _getMonthNameFormatted(nextMonthDate),
          'totalCosts': totalCosts,
          'settledPercentage': 0.0,
        }, SetOptions(merge: true));

    // 7. Write notification doc for members
    await _notifyMembers(
      flatId: flatId,
      title: 'dashboard_notification_costs_calculated_title',
      body:
          'dashboard_notification_costs_calculated_body|${_getMonthNameFormatted(nextMonthDate)}',
      type: NotificationType.costsCalculated,
    );
  }

  Future<void> _notifyMembers({
    required String flatId,
    required String title,
    required String body,
    required NotificationType type,
  }) async {
    final membersSnap = await _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.members)
        .get();

    final batch = _firestore.batch();
    final recipientUserIds = <String>[];

    for (final doc in membersSnap.docs) {
      final data = doc.data();
      final userId = data['userId'] as String?;
      if (userId != null && userId.isNotEmpty) {
        recipientUserIds.add(userId);
        final notifRef = _firestore
            .collection(FirestoreConstants.users)
            .doc(userId)
            .collection(FirestoreConstants.notifications)
            .doc();
        batch.set(notifRef, {
          'id': notifRef.id,
          'title': title,
          'body': body,
          'type': type.name,
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    }

    await batch.commit();

    // Trigger FCM Push via Vercel for cost notification button
    if (recipientUserIds.isNotEmpty) {
      final notificationDto = NotificationsDto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        timestamp: DateTime.now(),
        type: type,
        isRead: false,
      );
      unawaited(
        _sendPushViaVercel(
          userIds: recipientUserIds,
          notification: notificationDto,
        ),
      );
    }
  }

  Future<void> _sendPushViaVercel({
    required List<String> userIds,
    required NotificationsDto notification,
  }) async {
    final apiUrl = EnvConfig.pushApiUrl;
    final apiSecret = EnvConfig.pushApiSecret;

    if (apiUrl.isEmpty || apiSecret.isEmpty) {
      debugPrint('⚠️ Push API not configured — skipping FCM push');
      return;
    }

    try {
      final tokenFutures = userIds.map(
        (uid) => _firestore.collection(FirestoreConstants.users).doc(uid).get(),
      );
      final userDocs = await Future.wait(tokenFutures);

      final allTokens = <String>[];
      for (final doc in userDocs) {
        final tokens = List<String>.from(
          doc.data()?[FirestoreConstants.fcmTokens] ?? [],
        );
        allTokens.addAll(tokens);
      }

      if (allTokens.isEmpty) {
        debugPrint('ℹ️ No FCM tokens found for recipients');
        return;
      }

      final response = await http.post(
        Uri.parse('$apiUrl/api/send-notification'),
        headers: {
          'Content-Type': 'application/json',
          'x-fairshare-secret': apiSecret,
        },
        body: jsonEncode({
          'tokens': allTokens,
          'title': notification.title,
          'body': notification.body,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ FCM push notification sent successfully via Vercel');
      } else {
        debugPrint(
          '❌ Vercel push error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to dispatch push via Vercel: $e');
    }
  }
}

@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(Ref ref) {
  return DashboardRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}
