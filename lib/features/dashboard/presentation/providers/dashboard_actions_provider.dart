import 'package:fair_share/features/notifications/domain/entities/notification_type.dart';
import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/presentation/providers/notify_members_notifier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';
import 'package:uuid/uuid.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import '../../domain/entities/expense_entity.dart';
import 'add_new_expense_use_case_provider.dart';
import '../../domain/use_cases/settle_use_case.dart';

part 'dashboard_actions_provider.g.dart';

@riverpod
class DashboardActions extends _$DashboardActions {
  @override
  ActionState<void> build() {
    return const ActionInitial();
  }

  Future<void> addExpense({
    required String flatId,
    required ExpenseEntity expense,
    List<String>? recipientUserIds,
  }) async {
    state = const ActionLoading();
    final auth = ref.read(authStateProvider).value;
    if (auth == null) {
      state = ActionError(Exception('User not authenticated'));
      return;
    }

    final useCase = ref.read(addNewExpenseUseCaseProvider);
    final result = await useCase(flatId: flatId, expense: expense);

    state = result.fold(
      (error) => ActionError(error),
      (_) {
        // Trigger push notification & in-app notification to other flat members
        if (recipientUserIds != null && recipientUserIds.isNotEmpty) {
          final notification = NotificationsEntity(
            id: const Uuid().v4(),
            title: 'dashboard_notification_expense_added_title',
            body: 'dashboard_notification_expense_added_body|${expense.payerName}|${expense.title}|${expense.amount.toStringAsFixed(2)}',
            type: NotificationType.expenseAdded,
            isRead: false,
          );
          ref.read(notifyMembersProvider.notifier).notify(recipientUserIds, notification);
        }
        return const ActionSuccess(null);
      },
    );
  }

  Future<void> settleDebt({
    required String flatId,
    required String debtId,
    String? recipientUserId,
    String? debtorName,
    double? amount,
  }) async {
    state = const ActionLoading();
    final auth = ref.read(authStateProvider).value;
    if (auth == null) {
      state = ActionError(Exception('User not authenticated'));
      return;
    }

    final useCase = ref.read(settleUseCaseProvider);
    final result = await useCase(
      flatId: flatId,
      debtId: debtId,
      userId: auth.id,
      userName: auth.email.split('@').first,
    );

    state = result.fold(
      (error) => ActionError(error),
      (_) {
        if (recipientUserId != null && recipientUserId.isNotEmpty) {
          final notification = NotificationsEntity(
            id: const Uuid().v4(),
            title: 'dashboard_notification_settled_title',
            body: 'dashboard_notification_settled_body|${debtorName ?? "A member"}',
            type: NotificationType.settle,
            isRead: false,
          );
          ref.read(notifyMembersProvider.notifier).notify([recipientUserId], notification);
        }
        return const ActionSuccess(null);
      },
    );
  }
}
