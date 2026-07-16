import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'add_members/add_another_hint.dart';
import 'add_members/add_member_field.dart';
import 'add_members/admin_card.dart';
import 'add_members/member_card.dart';

class AddMembersStepWidget extends HookWidget {
  const AddMembersStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final members = useState<List<String>>([]);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    void addMember() {
      final name = nameController.text.trim();
      if (name.isEmpty) return;
      members.value = [...members.value, name];
      nameController.clear();
    }

    void removeMember(int index) {
      final updated = List<String>.from(members.value)..removeAt(index);
      members.value = updated;
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
            onAdd: addMember,
          ),
          const SizedBox(height: 24),
          Text(
            LocaleKeys.new_flat_setup_current_household.tr(),
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          const AdminCard(),
          const SizedBox(height: 8),
          ...members.value.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MemberCard(
                name: entry.value,
                onRemove: () => removeMember(entry.key),
              ),
            ),
          ),
          if (members.value.isEmpty) ...[
            const SizedBox(height: 8),
            const AddAnotherHint(),
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
