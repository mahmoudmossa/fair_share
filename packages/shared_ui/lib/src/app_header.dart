import 'package:flutter/material.dart';

/// A standardized header / AppBar for the application.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Widget? notificationIcon;
  final String? avatarUrl;
  final Widget? avatarWidget;
  final Key? titleKey;

  const AppHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.notificationIcon,
    this.avatarUrl,
    this.avatarWidget,
    this.titleKey,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget? effectiveTitle = titleWidget;
    if (effectiveTitle == null && title != null) {
      effectiveTitle = Text(
        title!,
        key: titleKey,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    Widget? leadingOrAvatar = leading;
    if (leadingOrAvatar == null && (avatarWidget != null || avatarUrl != null)) {
      leadingOrAvatar = Padding(
        padding: const EdgeInsets.all(8.0),
        child: avatarWidget ??
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surfaceContainer,
                image: DecorationImage(
                  image: NetworkImage(avatarUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      );
    }

    final allActions = <Widget>[
      ...?notificationIcon != null ? [notificationIcon!] : null,
      ...?actions,
    ];

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leadingOrAvatar,
      title: effectiveTitle,
      actions: allActions.isNotEmpty ? allActions : null,
    );
  }
}
