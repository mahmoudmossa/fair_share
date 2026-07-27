import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class MonthDetailSummaryTileWidget extends StatelessWidget {
  const MonthDetailSummaryTileWidget({
    super.key,
    required this.label,
    required this.amount,
    required this.colorScheme,
    required this.textTheme,
    this.highlightValue = false,
  });

  final String label;
  final double? amount;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool highlightValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        if (amount != null)
          Text(
            '€${amount!.toStringAsFixed(2)}',
            style: textTheme.titleLarge?.copyWith(
              color: highlightValue
                  ? colorScheme.primary
                  : colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          )
        else
          EmptyValueDashWidget(
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
      ],
    );
  }
}
