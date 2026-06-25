import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import '../../domain/entities/activity_entity.dart';

class ActivityFeedWidget extends StatelessWidget {
  final List<ActivityEntity> activities;

  const ActivityFeedWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (activities.isEmpty) return const SizedBox.shrink();

    // Show only the 5 most recent activities to match dashboard feel
    final displayActivities = activities.take(5).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.dashboard_recent_activity.tr(),
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayActivities.length,
            itemBuilder: (context, index) {
              final act = displayActivities[index];

              // Alternate bullet color: first is primary, others are outline
              final bulletColor = index == 0 ? colorScheme.primary : colorScheme.outline;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Styled Bullet
                    Container(
                      margin: const EdgeInsets.only(top: 6, left: 4, right: 12),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bulletColor,
                      ),
                    ),
                    // Activity text
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontFamily: 'Inter',
                          ),
                          children: [
                            TextSpan(
                              text: '${act.userName} ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(text: act.action),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
