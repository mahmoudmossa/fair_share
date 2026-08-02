import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

class ProfileMembershipCardWidget extends HookConsumerWidget {
  final String flatName;
  final int membersCount;

  const ProfileMembershipCardWidget({
    super.key,
    required this.flatName,
    required this.membersCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final cardBgColor = colorScheme.primary;
    final textColor = colorScheme.onPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.profile_membership_status.tr(),
            style: textTheme.labelSmall?.copyWith(
              color: textColor.withAlpha(200),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            flatName.isNotEmpty ? flatName : LocaleKeys.profile_premium_flat.tr(),
            style: textTheme.headlineSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 18,
                color: textColor.withAlpha(230),
              ),
              const SizedBox(width: 8),
              Text(
                '${LocaleKeys.profile_active_housemate.tr()} • ${LocaleKeys.profile_members_count.tr(args: [
                      membersCount.toString()
                    ])}',
                style: textTheme.bodyMedium?.copyWith(
                  color: textColor.withAlpha(230),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
