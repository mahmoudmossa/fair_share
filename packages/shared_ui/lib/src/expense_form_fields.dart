import 'package:flutter/material.dart';

class ExpenseFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final Key? titleKey;
  final Key? amountKey;
  final String titleLabel;
  final String titleHint;
  final String amountLabel;
  final String amountHint;
  final String paidByLabel;
  final String frequencyLabel;
  final FormFieldValidator<String>? titleValidator;
  final FormFieldValidator<String>? amountValidator;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onAmountChanged;
  final Widget payerDropdown;
  final Widget frequencySegmentedButton;

  const ExpenseFormFields({
    super.key,
    required this.titleController,
    required this.amountController,
    this.titleKey,
    this.amountKey,
    required this.titleLabel,
    required this.titleHint,
    required this.amountLabel,
    required this.amountHint,
    required this.paidByLabel,
    required this.frequencyLabel,
    this.titleValidator,
    this.amountValidator,
    this.onTitleChanged,
    this.onAmountChanged,
    required this.payerDropdown,
    required this.frequencySegmentedButton,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleLabel,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    key: titleKey,
                    controller: titleController,
                    validator: titleValidator,
                    onChanged: onTitleChanged,
                    decoration: InputDecoration(
                      hintText: titleHint,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amountLabel,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    key: amountKey,
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: amountValidator,
                    onChanged: onAmountChanged,
                    decoration: InputDecoration(
                      hintText: amountHint,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              paidByLabel,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            payerDropdown,
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              frequencyLabel,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(width: double.infinity, child: frequencySegmentedButton),
          ],
        ),
      ],
    );
  }
}
