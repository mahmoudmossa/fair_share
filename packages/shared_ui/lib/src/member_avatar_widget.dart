import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// A reusable circular avatar widget that displays a base64-encoded image
/// when available, or falls back to a text initial.
///
/// Used in both the Profile screen and the Members list.
class MemberAvatarWidget extends StatelessWidget {
  final String? photoBase64;
  final String displayName;
  final double radius;

  const MemberAvatarWidget({
    super.key,
    required this.displayName,
    this.photoBase64,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final initial = displayName.isNotEmpty
        ? displayName.substring(0, 1).toUpperCase()
        : '?';

    Uint8List? imageBytes;
    if (photoBase64 != null && photoBase64!.isNotEmpty) {
      try {
        imageBytes = base64Decode(photoBase64!);
      } catch (_) {
        imageBytes = null;
      }
    }

    if (imageBytes != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(imageBytes),
        backgroundColor: colorScheme.primaryContainer,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        initial,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.75,
        ),
      ),
    );
  }
}
