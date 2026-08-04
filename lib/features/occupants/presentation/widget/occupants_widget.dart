import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/presentation/providers/edit_flat_name_provider.dart';
import 'package:fair_share/features/occupants/presentation/providers/edit_member_provider.dart';
import 'package:fair_share/features/occupants/presentation/widget/billing_calculation_day_widget.dart';
import 'package:fair_share/features/occupants/presentation/widget/deep_link_invitation_widget.dart';
import 'package:fair_share/features/occupants/presentation/widget/edit_flat_name_dialog.dart';
import 'package:fair_share/features/occupants/presentation/widget/edit_member_list_widget.dart';
import 'package:fair_share/features/occupants/presentation/widget/encrypted_ledger_card_widget.dart';
import 'package:fair_share/features/occupants/presentation/widget/flat_header_widget.dart';
import 'package:fair_share/features/occupants/presentation/widget/invitation_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OccupantsWidget extends HookConsumerWidget {
  final List<Occupant>? occupantsList;
  final String inviteCode;
  final bool isCurrentAdmin;
  final String currentUserId;
  final String flatId;
  final String flatName;
  final int initialBillingDay;

  const OccupantsWidget({
    super.key,
    this.occupantsList,
    this.inviteCode = 'FAIR-8924',
    this.isCurrentAdmin = false,
    this.currentUserId = '',
    this.flatId = '',
    this.flatName = '',
    this.initialBillingDay = 1,
  });

  void _showEditFlatNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
    String flatId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditFlatNameDialog(
        currentFlatName: currentName,
        flatId: flatId,
        onSave: (newName) async {
          await ref
              .read(editFlatNameProvider.notifier)
              .editFlatName(flatId: flatId, newName: newName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultOccupants = occupantsList ??
        [
          Occupant(id: '1', name: 'Alex Thompson'),
          Occupant(id: '2', name: 'Elena Rodriguez'),
          Occupant(id: '3', name: 'Jordan Chen'),
          Occupant(id: '4', name: 'Sarah Miller'),
        ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 0. Flat Header Widget with Edit Flat Name capability
          FlatHeaderWidget(
            flatName: flatName,
            onEditTap: () => _showEditFlatNameDialog(
              context,
              ref,
              flatName,
              flatId,
            ),
          ),
          const SizedBox(height: 16),
          // 1. Invitation Card Widget
          const InvitationCardWidget(),
          const SizedBox(height: 24),
          // 2. Edit Members List Widget (Active Household)
          EditMemberListWidget(
            occupants: defaultOccupants,
            isCurrentAdmin: isCurrentAdmin,
            currentUserId: currentUserId,
            onEditMember: (updatedOccupant) async {
              await ref
                  .read(editMemberProvider.notifier)
                  .editMember(updatedOccupant);
            },
          ),
          const SizedBox(height: 24),
          // 3. Billing Calculation Day Widget (1-30 month calendar selector)
          BillingCalculationDayWidget(
            flatId: flatId,
            initialDay: initialBillingDay,
            isCurrentAdmin: isCurrentAdmin,
          ),
          const SizedBox(height: 24),
          // 4. Deep Link Invitation Widget
          const DeepLinkInvitationWidget(),
          const SizedBox(height: 24),
          // 5. Encrypted Shared Ledger Card Widget
          const EncryptedLedgerCardWidget(),
        ],
      ),
    );
  }
}