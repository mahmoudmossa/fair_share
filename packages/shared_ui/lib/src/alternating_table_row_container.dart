import 'package:flutter/material.dart';

/// Reusable table/list row container with alternating surface colors and bottom border.
class AlternatingTableRowContainer extends StatelessWidget {
  const AlternatingTableRowContainer({
    super.key,
    required this.isEven,
    required this.child,
    this.keyName,
    this.onTap,
    this.minHeight = 56.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final bool isEven;
  final Widget child;
  final Key? keyName;
  final VoidCallback? onTap;
  final double minHeight;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final containerWidget = Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding,
      decoration: BoxDecoration(
        color: isEven
            ? colorScheme.surface
            : colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        key: keyName,
        onTap: onTap,
        child: containerWidget,
      );
    }

    return containerWidget;
  }
}
