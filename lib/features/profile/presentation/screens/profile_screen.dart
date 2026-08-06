import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_flat_provider.dart';
import 'package:fair_share/features/dashboard/presentation/providers/flat_members_provider.dart';


import '../providers/profile_notifier_provider.dart';
import '../widgets/profile_avatar_header_widget.dart';
import '../widgets/profile_membership_card_widget.dart';
import '../widgets/profile_general_settings_widget.dart';
import '../widgets/profile_version_info_widget.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(firestoreUserProvider);
    final flatAsync = ref.watch(dashboardFlatProvider);
    final membersAsync = ref.watch(flatMembersProvider);

    ref.listen<ActionState<void>>(profileProvider, (previous, next) {
      if (next is ActionSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.profile_update_success.tr())),
        );
      } else if (next is ActionError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.profile_update_error.tr(args: [next.error.toString()]),
            ),
          ),
        );
      }
    });

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          LocaleKeys.dashboard_error_loading_user.tr(args: [err.toString()]),
        ),
      ),
      data: (user) {
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final flatName = flatAsync.value?.name ?? '';
        final members = membersAsync.value ?? [];
        final membersCount = members.isNotEmpty ? members.length : 1;

        final currentMember = members.where((m) => m.id == user.id || m.userId == user.id).firstOrNull;
        final displayName = currentMember?.name ?? '';
        final photoBase64 = currentMember?.photoBase64;


        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              ProfileAvatarHeaderWidget(
                user: user,
                displayName: displayName,
                photoBase64: photoBase64,
              ),
              const SizedBox(height: 20),
              ProfileMembershipCardWidget(
                flatName: flatName,
                membersCount: membersCount,
              ),
              const SizedBox(height: 24),
              ProfileGeneralSettingsWidget(flatName: flatName),
              const SizedBox(height: 32),
              const ProfileVersionInfoWidget(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

