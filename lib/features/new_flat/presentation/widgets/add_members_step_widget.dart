import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import '../provider/flat_setup_provider.dart';
import 'add_members/add_another_hint.dart';
import 'add_members/add_member_field.dart';
import 'add_members/admin_card.dart';
import 'add_members/member_card.dart';
import 'add_members/no_members_attention.dart';

class AddMembersStepWidget extends HookConsumerWidget {
  const AddMembersStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final flatSetup = ref.watch(flatSetupProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isUserAdded = flatSetup.createdByName.trim().isNotEmpty;

    void onAddSubmitted() {
      final name = nameController.text.trim();
      if (name.isEmpty) return;

      if (!isUserAdded) {
        // First entry sets the user/creator username
        ref.read(flatSetupProvider.notifier).updateCreatorName(name);
        nameController.clear();
        return;
      }

      // Check if duplicate name
      if (flatSetup.createdByName.toLowerCase() == name.toLowerCase() ||
          flatSetup.members.any((m) => m.name.toLowerCase() == name.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.new_flat_setup_member_exists_error.tr(),
            ),
          ),
        );
        return;
      }

      ref.read(flatSetupProvider.notifier).addMember(name);
      nameController.clear();
    }

    void removeMember(String name) {
      ref.read(flatSetupProvider.notifier).removeMember(name);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.new_flat_setup_step2_headline.tr(),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.new_flat_setup_step2_subtitle.tr(),
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          AddMemberField(
            controller: nameController,
            onAdd: onAddSubmitted,
            hintText: isUserAdded
                ? LocaleKeys.new_flat_setup_flatmate_name_hint.tr()
                : LocaleKeys.new_flat_setup_your_name_hint.tr(),
          ),

          const SizedBox(height: 24),
          Text(
            LocaleKeys.new_flat_setup_current_household.tr(),
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          if (!isUserAdded) ...[
            const NoMembersAttention(),
          ] else ...[
            AdminCard(name: flatSetup.createdByName),
            const SizedBox(height: 8),
            ...flatSetup.members.map(
              (member) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: MemberCard(
                  name: member.name,
                  onRemove: () => removeMember(member.name),
                ),
              ),
            ),
            if (flatSetup.members.isEmpty) ...[
              const SizedBox(height: 8),
              const AddAnotherHint(),
            ],
          ],
          const SizedBox(height: 24),
          Center(
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.groups_outlined,
                size: 100,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
