import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import '../providers/profile_notifier_provider.dart';

/// Bottom sheet that lets the user pick a photo from the camera or gallery.
/// The picked image is compressed and saved as base64 via [ProfileNotifier].
class ProfileAvatarPickerWidget extends HookConsumerWidget {
  final UserEntity user;

  const ProfileAvatarPickerWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLoading = useState(false);
    final profileNotifier = ref.watch(profileProvider.notifier);

    Future<void> pickAndUpload(ImageSource source) async {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: source,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 80,
      );

      if (picked == null) return;

      isLoading.value = true;
      try {
        // Compress to 200×200 @ quality 60
        final compressed = await FlutterImageCompress.compressWithFile(
          picked.path,
          minWidth: 200,
          minHeight: 200,
          quality: 60,
          format: CompressFormat.jpeg,
        );

        if (compressed == null) throw Exception('Image compression failed');

        final base64Photo = base64Encode(compressed);

        if (context.mounted) Navigator.of(context).pop();

        await profileNotifier.updateProfilePhoto(
          userId: user.id,
          flatId: user.flatId,
          base64Photo: base64Photo,
        );
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.profile_pick_photo_title.tr(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading.value)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )
            else ...[
              ListTile(
                key: const Key('profileGalleryButton'),
                leading: Icon(Icons.photo_library_outlined,
                    color: colorScheme.primary),
                title: Text(LocaleKeys.profile_pick_from_gallery.tr()),
                onTap: () => pickAndUpload(ImageSource.gallery),
              ),
              ListTile(
                key: const Key('profileCameraButton'),
                leading: Icon(Icons.camera_alt_outlined,
                    color: colorScheme.primary),
                title: Text(LocaleKeys.profile_take_photo.tr()),
                onTap: () => pickAndUpload(ImageSource.camera),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
