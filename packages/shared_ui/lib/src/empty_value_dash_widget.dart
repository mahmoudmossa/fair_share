import 'package:flutter/material.dart';

/// Reusable widget to display an empty value dash ("—") styled consistently across the app.
class EmptyValueDashWidget extends StatelessWidget {
  const EmptyValueDashWidget({
    super.key,
    this.style,
    this.color,
    this.textAlign = TextAlign.end,
  });

  final TextStyle? style;
  final Color? color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final defaultStyle =
        style ??
        textTheme.bodyLarge?.copyWith(
          color: color ?? colorScheme.onSurfaceVariant,
        );

    return Text('—', textAlign: textAlign, style: defaultStyle);
  }
}
