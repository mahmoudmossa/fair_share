import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import '../providers/profile_notifier_provider.dart';

class ProfileAvatarHeaderWidget extends HookConsumerWidget {
  final UserEntity user;
  final String displayName;

  const ProfileAvatarHeaderWidget({
    super.key,
    required this.user,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectiveDisplayName =
        displayName.isNotEmpty ? displayName : 'User';

    final isEditing = useState(false);
    final nameController = useTextEditingController(text: effectiveDisplayName);

    useEffect(() {
      if (!isEditing.value) {
        nameController.text = effectiveDisplayName;
      }
      return null;
    }, [effectiveDisplayName]);

    Future<void> submitSave() async {
      final newName = nameController.text.trim();
      if (newName.isNotEmpty && newName != effectiveDisplayName) {
        isEditing.value = false;
        await ref.read(profileProvider.notifier).updateDisplayName(
              userId: user.id,
              flatId: user.flatId,
              newName: newName,
            );
      } else {
        isEditing.value = false;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(80),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  effectiveDisplayName.substring(0, 1).toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.photo_camera,
                    size: 16,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isEditing.value)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      key: AppKeys.profile.nameInputField,
                      controller: nameController,
                      autofocus: true,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: LocaleKeys.profile_name_label.tr(),
                      ),
                      onSubmitted: (_) => submitSave(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    key: AppKeys.profile.saveNameButton,
                    onPressed: submitSave,
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                  IconButton(
                    key: AppKeys.profile.cancelNameButton,
                    onPressed: () {
                      isEditing.value = false;
                      nameController.text = effectiveDisplayName;
                    },
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: colorScheme.error,
                      size: 24,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    effectiveDisplayName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  key: AppKeys.profile.editNameButton,
                  onPressed: () {
                    nameController.text = effectiveDisplayName;
                    isEditing.value = true;
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
