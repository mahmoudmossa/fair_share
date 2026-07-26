import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';
import 'package:fair_share/features/history/presentation/widgets/history/history_row_widget.dart';

void main() {
  group('HistoryRowWidget', () {
    final fakeEntity = MonthSummaryEntity(
      monthId: '2026-07',
      monthLabel: 'Jul 2026',
      total: 1240.50,
      myShare: 310.13,
      lockedAt: DateTime(2026, 7, 20),
    );

    testWidgets('displays month label, total, and my share', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HistoryRowWidget(
                entity: fakeEntity,
                isEven: true,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Jul 2026'), findsOneWidget);
      expect(find.text('€1240.50'), findsOneWidget);
      expect(find.text('€310.13'), findsOneWidget);
    });

    testWidgets('calls onTap when row is tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HistoryRowWidget(
                entity: fakeEntity,
                isEven: false,
                onTap: () => wasTapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(Key('historyRow_${fakeEntity.monthId}')));
      expect(wasTapped, isTrue);
    });
  });
}
