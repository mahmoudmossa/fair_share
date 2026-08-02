import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/presentation/providers/edit_member_provider.dart';
import 'package:fair_share/features/occupants/presentation/widget/deep_link_invitation_widget.dart';
import 'package:fair_share/features/occupants/presentation/widget/edit_member_list_widget.dart';
import 'package:fair_share/features/occupants/presentation/widget/encrypted_ledger_card_widget.dart';
import 'package:fair_share/features/occupants/presentation/widget/invitation_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OccupantsWidget extends HookConsumerWidget {
  final List<Occupant>? occupantsList;
  final String inviteCode;
  final bool isCurrentAdmin;
  final String currentUserId;

  const OccupantsWidget({
    super.key,
    this.occupantsList,
    this.inviteCode = 'FAIR-8924',
    this.isCurrentAdmin = false,
    this.currentUserId = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultOccupants = occupantsList ??
        [
          Occupant(id: '1', name: 'Alex Thompson'),
          Occupant(id: '2', name: 'Elena Rodriguez'),
          Occupant(id: '3', name: 'Jordan Chen'),
          Occupant(id: '4', name: 'Sarah Miller'),
        ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flat Administration & Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Invitation Card Widget
            const InvitationCardWidget(),
            const SizedBox(height: 24),
            // 2. Edit Members List Widget
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
            // 3. Deep Link Invitation Widget
            const DeepLinkInvitationWidget(),
            const SizedBox(height: 24),
            // 4. Encrypted Shared Ledger Card Widget
            const EncryptedLedgerCardWidget(),
          ],
        ),
      ),
    );
  }
}