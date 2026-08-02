import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditMemberListWidget extends HookConsumerWidget {
  final List<Occupant> occupants;
  final Future<void> Function(Occupant updatedOccupant)? onEditMember;
  final bool isCurrentAdmin;
  final String currentUserId;

  const EditMemberListWidget({
    super.key,
    required this.occupants,
    this.onEditMember,
    this.isCurrentAdmin = false,
    this.currentUserId = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Household',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${occupants.length} Members',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: occupants.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return _MemberTileWidget(
              occupant: occupants[index],
              onSave: onEditMember,
              isCurrentAdmin: isCurrentAdmin,
              currentUserId: currentUserId,
            );
          },
        ),
      ],
    );
  }
}

class _MemberTileWidget extends HookWidget {
  final Occupant occupant;
  final Future<void> Function(Occupant updatedOccupant)? onSave;
  final bool isCurrentAdmin;
  final String currentUserId;

  const _MemberTileWidget({
    required this.occupant,
    this.onSave,
    required this.isCurrentAdmin,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = useState(false);
    final isCopied = useState(false);
    final isSaving = useState(false);
    final controller = useTextEditingController(text: occupant.name);

    void saveEdit() async {
      if (controller.text.trim().isNotEmpty && controller.text != occupant.name) {
        isSaving.value = true;
        await onSave?.call(occupant.copyWith(name: controller.text.trim()));
        if (context.mounted) {
          isSaving.value = false;
        }
      }
      isEditing.value = false;
    }

    void copyToClipboard(String code) {
      Clipboard.setData(ClipboardData(text: code));
      isCopied.value = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Invite Code Copied'),
            ],
          ),
          duration: const Duration(seconds: 1),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        isCopied.value = false;
      });
    }

    final hasJoined = occupant.userId != null && occupant.userId!.isNotEmpty;
    final canEdit = isCurrentAdmin || (occupant.userId != null && occupant.userId == currentUserId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: occupant.avatarUrl != null
                ? NetworkImage(occupant.avatarUrl!)
                : null,
            child: occupant.avatarUrl == null
                ? Text(
                    occupant.name.isNotEmpty ? occupant.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEditing.value)
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => saveEdit(),
                  )
                else
                  Text(
                    occupant.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 4),
                if (!hasJoined)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Pending',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (occupant.invitationCode != null &&
                          occupant.invitationCode!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Code: ${occupant.invitationCode}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => copyToClipboard(occupant.invitationCode!),
                          child: Icon(
                            isCopied.value ? Icons.check : Icons.copy_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Active',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (canEdit)
            isSaving.value
                ? SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      isEditing.value ? Icons.check_circle : Icons.edit_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      if (isEditing.value) {
                        saveEdit();
                      } else {
                        isEditing.value = true;
                      }
                    },
                  ),
        ],
      ),
    );
  }
}
