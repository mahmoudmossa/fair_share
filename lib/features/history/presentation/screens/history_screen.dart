import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/history/yearly_costs_card_widget.dart';
import '../widgets/history/history_widget.dart';

@RoutePage()
class HistoryScreen extends HookConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const YearlyCostsCardWidget(),
        Expanded(
          child: const HistoryWidget(),
        ),
      ],
    );
  }
}

