import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_cost.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';

part 'flat_setup_provider.g.dart';

@riverpod
class FlatSetup extends _$FlatSetup {
  @override
  FlatEntity build() {
    final user = ref.watch(authStateProvider).value;
    return FlatEntity.empty().copyWith(
      id: const Uuid().v4(), // Autogenerate unique Flat ID at startup
      createdBy: user?.id ?? '',
      createdByName:
          '', // Starts empty so the user enters their name first in Step 2
    );
  }

  void updateFlatName(String name) {
    state = state.copyWith(name: name);
  }

  void updateCreatorName(String name) {
    state = state.copyWith(createdByName: name);
  }

  void addMember(String name) {
    final updatedMembers = List<FlatMemberEntity>.from(state.members)
      ..add(FlatMemberEntity(id: const Uuid().v4(), name: name));
    state = state.copyWith(members: updatedMembers);
  }

  void removeMember(String name) {
    final updatedMembers = List<FlatMemberEntity>.from(state.members)
      ..removeWhere((m) => m.name == name);
    state = state.copyWith(members: updatedMembers);
  }

  void addCost({
    required String title,
    required double amount,
    required RecurrenceType recurrenceType,
    required String payerId,
    required String payerName,
  }) {
    final updatedCosts = List<FlatCostEntity>.from(state.costs)
      ..add(
        FlatCostEntity(
          title: title,
          payerName: payerName,
          amount: amount,
          recurrenceType: recurrenceType,
          payerId: payerId,
        ),
      );
    state = state.copyWith(costs: updatedCosts);
  }

  void updateCost(
    int index, {
    String? title,
    double? amount,
    RecurrenceType? recurrenceType,
    String? payerId,
    String? payerName,
  }) {
    if (index < 0 || index >= state.costs.length) return;

    final updatedCosts = List<FlatCostEntity>.from(state.costs);
    final current = updatedCosts[index];
    updatedCosts[index] = FlatCostEntity(
      payerName: payerName ?? current.payerName,
      title: title ?? current.title,
      amount: amount ?? current.amount,
      recurrenceType: recurrenceType ?? current.recurrenceType,
      payerId: payerId ?? current.payerId,
    );
    state = state.copyWith(costs: updatedCosts);
  }

  void removeCost(int index) {
    final updatedCosts = List<FlatCostEntity>.from(state.costs)
      ..removeAt(index);
    state = state.copyWith(costs: updatedCosts);
  }

  void generateInvitationCode() {
    // Generate a random 6-digit invitation code
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final code = random.substring(max(0, random.length - 6));
    state = state.copyWith(invitationCode: code);
  }
}
