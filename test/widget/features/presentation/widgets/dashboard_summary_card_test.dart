import 'package:fair_share/features/dashboard/domain/entities/billing_cycle_entity.dart';
import 'package:fair_share/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:fair_share/features/dashboard/presentation/widgets/bento_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('summary card displays the correct total mount', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: BentoSummaryWidget(
              cycle: BillingCycleEntity(
                id: '1',
                monthName: 'April',
                status: 'published',
                totalCosts: 450.0,
                settledPercentage: 100.0,
              ),
            ),
          ),
        ),
      ),
    );

    final mountText = find.text('${(450.0 / 4).toStringAsFixed(2)}€');
    expect(mountText, findsOneWidget);
  });
}
