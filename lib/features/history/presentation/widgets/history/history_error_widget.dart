import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

class HistoryErrorWidget extends StatelessWidget {
  const HistoryErrorWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          LocaleKeys.history_loading_error.tr(args: [message]),
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
